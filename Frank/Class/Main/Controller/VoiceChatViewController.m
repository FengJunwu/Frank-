//
//  VoiceChatViewController.m
//  Frank
//
//  Created by kingunionLCF on 2019/6/25.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VoiceChatViewController.h"
#import "PromptBoxAlertView.h"
#import "VoiceChatView.h"
#import "VoiceChaitModel.h"
#import "VoiceAssistantModel.h"
#import "ConnectedDevicesView.h"

//科大讯飞语音识别
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"

//forward declare
@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

@interface VoiceChatViewController ()<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>

@property (nonatomic,strong)UIButton *electricityBut;//电量
@property (nonatomic,strong)UIButton *promptBut;//提示
@property (nonatomic,strong)UIButton *voiceBut;//语音
@property (nonatomic,strong)UIButton *buyBut;//购买
@property (nonatomic,strong)VoiceChatView *chatView;
@property (nonatomic,strong)NSMutableArray *keyWordArr;


#pragma mark--分割线---------------科大讯飞语音识别----------------------------

/*!
 *  语音识别类<br>
 *  此类现在设计为单例，你在使用中只需要创建此对象，不能调用release/dealloc函数去释放此对象。所有关于语音识别的操作都在此类中。
 */
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
///录音控件
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;
///数据上传类，主要用于上传语法文件或上传联系人、词表等个性化数据。
@property (nonatomic, strong) IFlyDataUploader *uploader;//upload control
///无论它是否是音频流函数
@property (nonatomic,assign) BOOL isStreamRec;//Whether or not it is Audio Stream function
///SDK是否调用了beginOfSpeech的委托方法。
@property (nonatomic,assign) BOOL isBeginOfSpeech;//Whether or not SDK has invoke the delegate methods of beginOfSpeech.

@end


@implementation VoiceChatViewController

{
    NSString *_identifyResults;
}

-(NSMutableArray *)keyWordArr{
    if (!_keyWordArr) {
        _keyWordArr = [[NSMutableArray alloc] init];
    }
    return _keyWordArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    // 拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureView:)];
    [self.view addGestureRecognizer:pan];
    _identifyResults = @"";
    
    [self configUI];
    
    ///进入页面的第一条消息
    
    if(self.dataSource.count > 0){
        VoiceAssistantModel *VAModel = self.dataSource[0];
        NSString *ask = VAModel.desc;
        CGFloat height = [self getStringHeightWithText:ask font:[UIFont systemFontOfSize:12] viewWidth:kMainScreenWidth * 0.35 - 16];
        NSLog(@"%f",height);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:VAModel.characterId forKey:@"characterId"];
        [dic setObject:ask forKey:@"ask"];
        [dic setObject:[self getCurrentTimes] forKey:@"time"];
        [dic setObject:@(height) forKey:@"height"];
        
        VoiceChaitModel *model = [VoiceChaitModel modelWithDictionary:dic];
        [self.chatView setModel:model];
        
        for (NSDictionary *dic in VAModel.textRecognize) {
            textRecognize *model = [textRecognize modelWithDictionary:dic];
            [self.keyWordArr addObject:model.keyWord];
        }
        
        ///{\"userword\":[{\"name\":\"我的常用词\",\"words\":[\"佳晨实业\",\"蜀南庭苑\",\"高兰路\",\"复联二\"]},{\"name\":\"我的好友\",\"words\":[\"李馨琪\",\"鹿晓雷\",\"张集栋\",\"周家莉\",\"叶震珂\",\"熊泽萌\"]}]}
        
        NSDictionary *keyWordDic = @{@"userword":@[@{@"name":@"我的常用词",
                                                     @"words":self.keyWordArr
                                                     }]
                                     
                                     };
        self.uploader = [[IFlyDataUploader alloc] init];
        [self upWordBtnHandler:keyWordDic];
    }
}


-(void)configUI{
    
    _electricityBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_electricityBut setImage:[UIImage imageNamed:@"电池图标"] forState:UIControlStateNormal];
    _electricityBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _electricityBut.size = CGSizeMake(Width(40), Width(40));
    _electricityBut.left = kMainScreenWidth - Width(55);
    _electricityBut.top = Width(10);
    [self.view addSubview:_electricityBut];
    
    
    _buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyBut setImage:[UIImage imageNamed:@"提醒购买"] forState:UIControlStateNormal];
    _buyBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buyBut.size = CGSizeMake(Width(40), Width(40));
    _buyBut.left = kMainScreenWidth - Width(55);
    _buyBut.top = _electricityBut.bottom +  Width(15);
    [_buyBut addTarget:self action:@selector(buyButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyBut];
    
    _voiceBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBut setImage:[UIImage imageNamed:@"提醒购买"] forState:UIControlStateNormal];
    _voiceBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _voiceBut.size = CGSizeMake(Width(40), Width(40));
    _voiceBut.left = kMainScreenWidth - Width(55);
    _voiceBut.top = _buyBut.bottom + Height(400);
    [_voiceBut addTarget:self action:@selector(voiceButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_voiceBut];
    
    _promptBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promptBut setImage:[UIImage imageNamed:@"蓝牙链接图标"] forState:UIControlStateNormal];
    _promptBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _promptBut.size = CGSizeMake(Width(40), Width(40));
    _promptBut.left = kMainScreenWidth - Width(55);
    _promptBut.top = _voiceBut.bottom + Width(15);
    [_promptBut addTarget:self action:@selector(promptButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_promptBut];
    
    _chatView = [[VoiceChatView alloc] initWithFrame:CGRectMake(15, kMainScreenHeight - kMainScreenWidth *0.35 - 30 - Height_NavBar, kMainScreenWidth * 0.7, kMainScreenWidth *0.35)];
    [self.view addSubview:_chatView];
    
}

#pragma mark - action
- (void)panGestureView:(UIPanGestureRecognizer*)pan
{
    CGPoint point = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateChanged){
        if (point.x <= 0 )  return;
        self.view.left = point.x;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (point.x <  self.view.width/6){ // 临界点
            [UIView animateWithDuration:0.3 animations:^{
                self.view.left = 0;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.view.left = self.view.width;
            }completion:^(BOOL finished) {
                
            }];
        }
    }
}
//
-(void)buyButAction:(UIButton *)sender{
//    PromptBoxAlertView *alertView = [[PromptBoxAlertView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.8, kMainScreenHeight *0.55)];
//    alertView.centerX = kMainScreenWidth / 2.0;
//    alertView.centerY = kMainScreenHeight / 2.0 -Height_NavBar;
//    alertView.dataSource = self.dataSource;
//    [self.view addSubview:alertView];
    
    PromptBoxAlertView *alertView = [[PromptBoxAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    alertView.centerX = kMainScreenWidth / 2.0;
//    alertView.centerY = kMainScreenHeight / 2.0 -Height_NavBar;
    alertView.dataSource = self.dataSource;
//    [self.view addSubview:alertView];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
}

#pragma mark--蓝牙连接图标
-(void)promptButAction:(UIButton *)sender{
    
    ConnectedDevicesView *alertView = [[ConnectedDevicesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];

}


//获取当前的时间
-(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}
//获取字符串高度
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}


#pragma mark--语音

//开始识别
-(void)voiceButAction:(UIButton *)sender{
    
    if (self.keyWordArr.count > 0) {
        NSDictionary *keyWordDic = @{@"userword":@[@{@"name":@"我的常用词",
                                                     @"words":self.keyWordArr
                                                     }]
                                     
                                     };
        self.uploader = [[IFlyDataUploader alloc] init];
        [self upWordBtnHandler:keyWordDic];
    }
    
    self.isStreamRec = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    //取消本次会话
    [_iFlySpeechRecognizer cancel];
    
    //Set microphone as audio source
    //设置麦克风为音频源
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //Set result type
    //返回结果数据类型
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
    //设置在SDK本地存储路径中生成时保存的录音文件的音频名称，默认在库/缓存中。
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置委托对象
    [_iFlySpeechRecognizer setDelegate:self];
    
    /*!
     *  开始识别
     *
     *  同时只能进行一路会话，这次会话没有结束不能进行下一路会话，否则会报错。若有需要多次回话，请在onCompleted回调返回后请求下一路回话。
     *
     *  成功返回YES；失败返回NO
     */
    BOOL ret = [_iFlySpeechRecognizer startListening];
    if (ret) {
        NSLog(@"开始识别");
    }else{
        
        NSLog(@"同时只能进行一路会话，这次会话没有结束不能进行下一路会话，否则会报错。若有需要多次回话，请在onCompleted回调返回后请求下一路回话。");
        
    }
}

///停止识别
- (void)stopBtnHandler:(id)sender {
    
    NSLog(@"%s",__func__);
    
    if(self.isStreamRec && !self.isBeginOfSpeech){
        NSLog(@"%s,stop recording",__func__);
        //停止录音
        [_pcmRecorder stop];
    }
    /*!
     *  停止录音<br>
     *  调用此函数会停止录音，并开始进行语音识别
     */
    [_iFlySpeechRecognizer stopListening];
}

/**
 cancel speech recognition
 取消识别
 **/
- (void)cancelBtnHandler:(id)sender {
    NSLog(@"%s",__func__);
    
    if(self.isStreamRec && !self.isBeginOfSpeech){
        NSLog(@"%s,stop recording",__func__);
        [_pcmRecorder stop];
    }
    
    [_iFlySpeechRecognizer cancel];
}


/**
 upload customized words
 上传词汇表
 **/
- (void)upWordBtnHandler:(NSDictionary *)dic{
    
    [_iFlySpeechRecognizer stopListening];
    //业务类型。
    [_uploader setParameter:@"uup" forKey:[IFlySpeechConstant SUBJECT]];
    //个性化数据上传类型
    [_uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:[self convertToJsonData:dic]];
    
    [_uploader uploadDataWithCompletionHandler:
     ^(NSString * grammerID, IFlySpeechError *error)
     {
         if (error.errorCode == 0) {
             NSLog(@"上传成功");
         }else{
             NSLog(@"上传失败");
         }
         
     } name:@"userwords" data:[iFlyUserWords toString]];
    
}


#pragma mark-- 科大讯飞
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进入页面
    [self initRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    //stop Grammar Recognition
    //离开页面
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [_pcmRecorder stop];
    _pcmRecorder.delegate = nil;
    [super viewWillDisappear:animated];
}


/**
 语音识别类 初始化
 */
-(void)initRecognizer{
    //recognition singleton without view
    //返回识别对象的单例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    }
    //扩展参数。
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //set recognition domain
    //应用领域key
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置委托
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        
        //set timeout of recording
        ///语音输入超时时间key 默认 30000
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //set VAD timeout of end of speech(EOS)
        /*!
         *  VAD后端点超时。<br>
         *  可选范围：0-10000(单位ms)
         *
         *  @return VAD后端点超时key
         */
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //set VAD timeout of beginning of speech(BOS)
        /*!
         *  VAD前端点超时<br>
         *  范围：0-10000(单位ms)
         *
         *  @return VAD前端点超时key
         */
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //set network timeout
        /*!
         *  网络连接超时时间<br>
         *  单位：ms，默认20000
         *
         *  @return 网络连接超时时间key
         */
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //set sample rate, 16K as a recommended option
        /*!
         *  合成、识别、唤醒、评测、声纹等业务采样率。
         *
         *  @return 合成及识别采样率key。
         */
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //set language
        /*!
         *  语言<br>
         *  支持：zh_cn，zh_tw，en_us<br>
         *
         *  @return 语言key
         */
        [_iFlySpeechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
        //set accent
        /*!
         *  语言区域。
         *
         *  @return 语言区域key。
         */
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        
        //set whether or not to show punctuation in recognition results
        /*!
         *  设置是否有标点符号
         *
         *  @return 设置是否有标点符号key
         */
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    }
    
    //Initialize recorder
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    _pcmRecorder.delegate = self;
    /*!
     *  设置音频采样率
     *
     *  @param rate -[in] 采样率，8k/16k
     */
    [_pcmRecorder setSample:@"16000"];
    //音频保存路径
    [_pcmRecorder setSaveAudioPath:nil];
    
}


#pragma mark - IFlyPcmRecorderDelegate
/*!
 *  回调音频数据
 *
 *  @param buffer 音频数据
 *  @param size   表示音频的长度
 */
- (void)onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
        
    }
}

/*!
 *  回调音频的错误码
 *
 *  @param recoder 录音器
 *  @param error   错误码
 */
- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error
{
    
}

//range from 0 to 30
/*!
 *  回调录音音量
 *
 *  @param power 音量值
 */
- (void) onIFlyRecorderVolumeChanged:(int) power
{
    

}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 volume callback,range from 0 to 30.
 **/
- (void) onVolumeChanged: (int)volume
{

}

/**
 Beginning Of Speech
 **/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
}

/**
 End Of Speech
 **/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    [_pcmRecorder stop];
}


/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  errorCode 错误描述
 */
- (void) onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    if (error.errorCode == 0 ) {
        NSLog(@"没有错误");
        
        if(self.dataSource.count > 0 && _identifyResults.length > 0){
            
            VoiceAssistantModel *VAModel = self.dataSource[0];
            //先添加自己说的话
            NSString *ask = _identifyResults;
            CGFloat height = [self getStringHeightWithText:ask font:[UIFont systemFontOfSize:12] viewWidth:kMainScreenWidth * 0.7 - 16];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:VAModel.characterId forKey:@"characterId"];
            [dic setObject:ask forKey:@"ask"];
            [dic setObject:[self getCurrentTimes] forKey:@"time"];
            [dic setObject:@(height) forKey:@"height"];
            VoiceChaitModel *model = [VoiceChaitModel modelWithDictionary:dic];
            [self.chatView setModel:model];
            
            model.bg_tableName = bg_reportedDatatableName;//自定义数据库表名称(库自带的字段).
            /**
             存储.
             */
            [model bg_save];
            
            
            for (NSDictionary *dic in VAModel.textRecognize) {
                textRecognize *model = [textRecognize modelWithDictionary:dic];
                if ([model.keyWord isEqualToString:_identifyResults]) {
                    
                    NSString *ask = model.responce;
                    CGFloat height = [self getStringHeightWithText:ask font:[UIFont systemFontOfSize:12] viewWidth:kMainScreenWidth * 0.35 - 16];
                    NSLog(@"%f",height);
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:VAModel.characterId forKey:@"characterId"];
                    [dic setObject:ask forKey:@"ask"];
                    [dic setObject:[self getCurrentTimes] forKey:@"time"];
                    [dic setObject:@(height) forKey:@"height"];
                    ///添加到对话框
                    VoiceChaitModel *chatModel = [VoiceChaitModel modelWithDictionary:dic];
                    [self.chatView setModel:chatModel];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(playDialogue:)]) {
                        [self.delegate playDialogue:model.responce];
                    }
                    
                    if ([model.type isEqualToString:@"0"]) {
                        NSString *pathMp3 = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgVoice];
                        NSString *pathBgImg = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgImg];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(playMp3:bgImg:)]) {
                            [self.delegate playMp3:pathMp3 bgImg:pathBgImg];
                        }
                    }else if ([model.type isEqualToString:@"1"]){
                        NSString *pathVideo = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgVideo];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(playVideo:)]) {
                            [self.delegate playVideo:pathVideo];
                        }
                    }
                    _identifyResults = @"";
                    return;
                }
            }
            //把文字制空
            _identifyResults = @"";
        }
    }
}

/**
 result callback of recognition without view
 results：recognition results
 isLast：whether or not this is the last result
 **/
- (void) onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  nil;
    resultFromJson = [[ISRDataHelper stringFromJson:resultString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _identifyResults = [NSString stringWithFormat:@"%@%@",_identifyResults,resultFromJson];
    NSLog(@"+++++++++++++++++resultFromJson=%@",_identifyResults);
    NSLog(@"+++++++++++++++++isLast=%d",isLast);
    
    
}

/**
 callback of canceling recognition
 **/
- (void) onCancel
{
    NSLog(@"Recognition is cancelled");
}




#pragma mark--字典转json
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    return jsonString;
    
}

#pragma mark-- json 解析
-(id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
