//
//  VideoViewController.m
//  Frank
//
//  Created by fengjunwu on 2019/6/21.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoListViewModel.h"
#import "VideoListModel.h"
#import <SGPlayer/SGPlayer.h>
#import "VideoTableViewCell.h"
#import "VideoSlider.h"

#import "UIView+BLLandscape.h"
#define kWith(R) (R)*(kMainScreenWidth)/667.0 //这里的375我是针对6s为标准适配的,如果需要其他标准可以修改
#define kHiht(R) (R)*(kMainScreenHeight)/375.0

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UIView *videoView;

@property (nonatomic,strong)SGPlayer * player;
@property (nonatomic,strong)UIButton *playBut;

@property (nonatomic,strong)UIView *toolbarView;
@property (nonatomic,strong)UIButton *playPauseBut;//播放或者暂停按钮
@property (nonatomic,strong)VideoSlider *progressSilder;
@property (nonatomic,assign)BOOL progressSilderTouching;
@property (nonatomic,strong)UILabel *playTime;
@property (nonatomic,strong)UIImageView *fingerImg;
@property (nonatomic,strong)UIButton *fullScreenButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
// 暂停
@property (nonatomic,strong)UIButton *PlayToSuspend;
//VR模式切换按钮
@property (nonatomic,strong)UIButton *VRBut;

@property (nonatomic,strong)UIView *topTooolBatView;
@property (nonatomic,strong)UIButton *backBut;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *connectedDeviceBut;
@property (nonatomic,strong)UIButton *electricityBut;


@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation VideoViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 211.0 * kScreenWidth/ 360, kScreenWidth, kheight - (211.0 * kScreenWidth/ 360) -Height_NavBar) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIView *)toolbarView{
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _toolbarView.size = CGSizeMake(kScreenWidth, Width(34));
        _toolbarView.top = 211.0 * kScreenWidth/ 360 - Width(34);
        _toolbarView.left = 0;
        
        _playPauseBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playPauseBut setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_playPauseBut setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateSelected];
        _playPauseBut.size = CGSizeMake(Width(44), Width(34));
        _playPauseBut.origin = CGPointMake(Width(5), 0);
        _playPauseBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_playPauseBut addTarget:self action:@selector(playPauseButAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbarView addSubview:_playPauseBut];
        
        
        _progressSilder = [[VideoSlider alloc] init];
        [_progressSilder addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_progressSilder addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_progressSilder addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchCancel];
        [_progressSilder addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        
        /*  修改进度条的样式  */
        [_progressSilder setThumbImage:[UIImage imageNamed:@"园点"] forState:UIControlStateNormal];
        _progressSilder.layer.masksToBounds = YES;
        _progressSilder.layer.cornerRadius = 3;
        _progressSilder.minimumTrackTintColor = UIColorHex(0xff9b24);
        _progressSilder.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _progressSilder.size = CGSizeMake(Width(kScreenWidth - Width(150)), Width(34));
        _progressSilder.left = _playPauseBut.right;
        _playPauseBut.top = 0;
        [_toolbarView addSubview:_progressSilder];
        
        _playTime = [[UILabel alloc] init];
        _playTime.size = CGSizeMake(Width(20), Width(34));
        _playTime.left = _progressSilder.right + Width(10);
        _playTime.top = 0;
        _playTime.textColor = UIColorHex(0xFFFFFF);
        _playTime.font = [UIFont systemFontOfSize:Font(6)];
        [_toolbarView addSubview:_playTime];
        
        _fingerImg = [[UIImageView alloc] init];
        _fingerImg.size = CGSizeMake(Width(14), Width(15));
        _fingerImg.left = _playTime.right + Width(10);
        _fingerImg.top = Width(9);
        _fingerImg.image = [UIImage imageNamed:@"拨动"];
        _fingerImg.contentMode = UIViewContentModeScaleAspectFit;
        [_toolbarView addSubview:_fingerImg];
        
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        _fullScreenButton.size = CGSizeMake(Width(44), Width(34));
        _fullScreenButton.left = _fingerImg.right;
        _fullScreenButton.top = 0;
        _fullScreenButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbarView addSubview:_fullScreenButton];
        
    }
    return _toolbarView;
}


-(UIButton *)playBut{
    if (!_playBut) {
        _playBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBut setImage:[UIImage imageNamed:@"播放大图标"] forState:UIControlStateNormal];
        [_playBut addTarget:self action:@selector(playButAction:) forControlEvents:UIControlEventTouchUpInside];
        _playBut.size = CGSizeMake(Width(80), Width(80));
        _playBut.center = self.player.view.center;
    }
    return _playBut;
}

-(UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        //设置小菊花的frame
        _activityIndicator.frame= CGRectMake(100, 100, 100, 100);
        _activityIndicator.center = self.player.view.center;
        //设置小菊花颜色
//        _activityIndicator.color = [UIColor redColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}


-(UIButton *)VRBut{
    if (!_VRBut) {
        _VRBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_VRBut setImage:[UIImage imageNamed:@"VR"] forState:UIControlStateNormal];
        _VRBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_VRBut addTarget:self action:@selector(VRButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbarView addSubview:_VRBut];
    }
    
    return _VRBut;
}

-(UIView *)topTooolBatView{
    if (!_topTooolBatView) {
        _topTooolBatView = [[UIView alloc] init];
        _topTooolBatView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
        _topTooolBatView.size = CGSizeMake(kMainScreenWidth, Width(64));
        _topTooolBatView.origin = CGPointMake(0, Width(10));
    
        _backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBut setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        _backBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backBut addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBut.size = CGSizeMake(Width(60), Width(44));
        _backBut.origin = CGPointMake(Width(20), 0);
        [_topTooolBatView addSubview:_backBut];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:Font(15)];
        _titleLabel.size = CGSizeMake(kMainScreenWidth - 150, Width(44));
        _titleLabel.origin = CGPointMake(_backBut.right + Width(10), 0);
        [_topTooolBatView addSubview:_titleLabel];
        
        
        _connectedDeviceBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectedDeviceBut setImage:[UIImage imageNamed:@"蓝牙链接图标"] forState:UIControlStateNormal];
        _connectedDeviceBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_connectedDeviceBut addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _connectedDeviceBut.size = CGSizeMake(Width(44), Width(44));
        _connectedDeviceBut.origin = CGPointMake(kMainScreenWidth - 100, 0);
        [_topTooolBatView addSubview:_connectedDeviceBut];
        
        
        _electricityBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_electricityBut setImage:[UIImage imageNamed:@"电池图标"] forState:UIControlStateNormal];
        _electricityBut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_electricityBut addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _electricityBut.size = CGSizeMake(Width(44), Width(44));
        _electricityBut.origin = CGPointMake(kMainScreenWidth - 50, 0);
        [_topTooolBatView addSubview:_electricityBut];
    
    }
    return _topTooolBatView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDataSource];
    [self configUI];
    [self.view addSubview:self.tableView];

    ///监听是否停止播放视频
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopPlayingVideoAction) name:@"StopPlayingVideo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopPlayingVideoAction) name:@"rightStopPlayingVideo" object:nil];
}

-(void)StopPlayingVideoAction{
    [self.player stop];
    self.playPauseBut.selected = NO;
}

-(void)getDataSource{
    [VideoListViewModel getCharacterListWithBlock:^(NSArray * _Nonnull dataSource, NSError * _Nonnull error) {
        
        if (!error) {
            self.dataSource = [NSMutableArray arrayWithArray:dataSource];
            if (self.dataSource.count > 0) {
                VideoListModel *model = self.dataSource[0];
                ///全景模式
                self.player.displayMode = SGDisplayModeNormal;
                [self.player replaceVideoWithURL:[NSURL URLWithString:model.url] videoType:SGVideoTypeVR];
                [self.player play];
                self.playBut.hidden = YES;
                self.titleLabel.text = model.title;
            }
            
            [self.tableView reloadData];
        }
    }];
    
}

-(void)configUI{
    
    self.videoView = [[UIView alloc] init];
    self.videoView.width = kScreenWidth;
    self.videoView.height =  211.0 * kScreenWidth/ 360;
    self.videoView.left = 0;
    self.videoView.top = 0;
    self.videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
    
    self.player = [SGPlayer player];
    [self.player registerPlayerNotificationTarget:self
                                  stateAction:@selector(stateAction:)
                               progressAction:@selector(progressAction:)
                               playableAction:@selector(playableAction:)
                                  errorAction:@selector(errorAction:)];
    [self.player setViewTapAction:^(SGPlayer * _Nonnull player, SGPLFView * _Nonnull view) {
        NSLog(@"player display view did click!");
    }];
    //这个方法控制视频全屏还是适应原来的尺寸
    self.player.viewGravityMode = SGGravityModeResizeAspect;
    self.player.view.frame = _videoView.bounds;
    [self.videoView insertSubview:self.player.view atIndex:0];
    [self.player.view addSubview:self.playBut];
    [self.player.view addSubview:self.activityIndicator];
    [self.player.view addSubview:self.toolbarView];
    [self.player.view addSubview:self.topTooolBatView];
    self.topTooolBatView.hidden = YES;
    self.titleLabel.text = @"这是一个测试视频";
    
    
//    static NSURL * normalVideo = nil;
//    static NSURL * vrVideo = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        normalVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"]];
//        vrVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"]];
//    });
    ///全景模式
//    self.player.displayMode = SGDisplayModeNormal;
//    [self.player replaceVideoWithURL:vrVideo videoType:SGVideoTypeVR];
    
    
}

#pragma mark--以下是播放动作
#pragma mark--横屏
-(void)fullScreenButtonAction:(UIButton *)sender{
    
   
    if (self.videoView.viewStatus == BLLandscapeViewStatusPortrait) {
        
        [self.videoView bl_landscapeAnimated:YES animations:^{
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            self.player.view.frame = self.view.bounds;
            self.player.view.left = 0;
            self.player.view.top = 0;
            self.player.view.width = kMainScreenHeight;
            self.player.view.height = kMainScreenWidth;
            
            
            self.toolbarView.frame = CGRectMake(0, kMainScreenWidth - Width(44), kMainScreenHeight, Width(44));
        
            self.playPauseBut.size = CGSizeMake(Width(44), Width(44));
            self.playPauseBut.origin = CGPointMake(Width(30), 0);

            self.progressSilder.size = CGSizeMake(Width(kMainScreenHeight - Width(200)), Width(44));
            self.progressSilder.left = self.playPauseBut.right + Width(10);
            self.playPauseBut.top = 0;
            
            self.playTime.size = CGSizeMake(Width(30), Width(44));
            self.playTime.left = self.progressSilder.right + Width(10);
            self.playTime.top = 0;
            
            self.playBut.center = self.player.view.center;
            
            self.activityIndicator.center = self.player.view.center;
            
            self.VRBut.size = CGSizeMake(Width(50), Width(44));
            self.VRBut.left = self.playTime.right;
            self.VRBut.top = 0;
            
            
            self.topTooolBatView.size = CGSizeMake(kMainScreenHeight, Width(59));
            self.topTooolBatView.left = 0;
            self.topTooolBatView.top = 0;
            [self.player.view addSubview:self.topTooolBatView];
            
    
            self.backBut.size = CGSizeMake(Width(60), Width(44));
            self.backBut.left = Width(20);
            self.backBut.top = Width(15);
            
            self.titleLabel.size = CGSizeMake(kMainScreenHeight - 150, Width(44));
            self.titleLabel.origin = CGPointMake(self.backBut.right + Width(10),Width(15));
            
            self.connectedDeviceBut.size = CGSizeMake(Width(44), Width(44));
            self.connectedDeviceBut.origin = CGPointMake(kMainScreenHeight - Width(140), Width(15));
            
            self.electricityBut.size = CGSizeMake(Width(44), Width(44));
            self.electricityBut.origin = CGPointMake(kMainScreenHeight - Width(80), Width(15));
            
            self.fingerImg.hidden = YES;
            self.fullScreenButton.hidden = YES;
            self.VRBut.hidden = NO;
            self.topTooolBatView.hidden = NO;
            
            
        } complete:^{
            
        }];
    }
    else if (self.videoView.viewStatus == BLLandscapeViewStatusLandscape){
        
        [self.videoView bl_protraitAnimated:YES animations:^{
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
//            self.videoView.left = 0;
//            self.videoView.top = 0;
            self.player.view.left = 0;
            self.player.view.top = 0;
            self.player.view.width = kMainScreenHeight;
            self.player.view.height =  211.0 * kMainScreenHeight/ 360;
            self.player.displayMode = SGDisplayModeNormal;
            
            [self.player.view addSubview:self.activityIndicator];
            
            self.toolbarView.size = CGSizeMake(kMainScreenHeight, kHiht(34));
            self.toolbarView.top = 211.0 * kMainScreenHeight/ 360 - kHiht(34);
            self.toolbarView.left = 0;
            
            self.playPauseBut.size = CGSizeMake(kHiht(44), kHiht(34));
            self.playPauseBut.origin = CGPointMake(kHiht(5), 0);
            
            self.progressSilder.size = CGSizeMake(kHiht(kMainScreenHeight - kHiht(150)), kHiht(34));
            self.progressSilder.left = self.playPauseBut.right;
            self.playPauseBut.top = 0;
            
            self.playTime.size = CGSizeMake(kHiht(20), kHiht(34));
            self.playTime.left = self.progressSilder.right + kHiht(10);
            self.playTime.top = 0;
            
            self.playBut.center = self.player.view.center;
            
            self.activityIndicator.center = self.player.view.center;
            
            self.fingerImg.hidden = NO;
            self.fullScreenButton.hidden = NO;
            self.VRBut.hidden = YES;
            self.topTooolBatView.hidden = YES;
            
            NSLog(@"很顺");
            
        } complete:^{
            
        }];
    }
}

#pragma mark--播放按钮
-(void)playButAction:(UIButton *)sender{
    [self.player play];
    self.PlayToSuspend.selected = YES;
    sender.hidden = YES;
}

-(void)playPauseButAction:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        [self.player pause];
    }else{
        sender.selected = YES;
        [self.player play];
    }
}

#pragma mark--VR和全景切换
-(void)VRButtonAction:(UIButton *)sender{
    
    if (sender.selected) {
        self.player.displayMode = SGDisplayModeNormal;
        sender.selected = NO;
    }else{
        self.player.displayMode = SGDisplayModeBox;
        sender.selected = YES;
    }
}

- (void)stateAction:(NSNotification *)notification
{
    SGState * state = [SGState stateFromUserInfo:notification.userInfo];
    
    NSString * text;
    switch (state.current) {
            case SGPlayerStateNone:
            text = @"None";
            break;
            case SGPlayerStateBuffering:
        {
            NSLog(@"正在缓冲");
            [self.activityIndicator startAnimating];
            ///正在缓冲
        }
            break;
            case SGPlayerStateReadyToPlay:
        {
            NSLog(@"播放准备完成");
            [self.activityIndicator stopAnimating];
            ///播放准备完成
        }
            break;
            case SGPlayerStatePlaying:
        {
            NSLog(@"正在播放");
            [self.activityIndicator stopAnimating];
            self.playBut.hidden = YES;
        }
            break;
            case SGPlayerStateSuspend:
        {
            NSLog(@"暂停播放");
        }
            break;
            case SGPlayerStateFinished:
        {
            NSLog(@"播放完成");
            ///播放完成
            self.playBut.hidden = NO;
        }
            break;
            case SGPlayerStateFailed:
        {
            NSLog(@"播放失败");
        }
            break;
    }
//    self.stateLabel.text = text;
}

- (void)progressTouchDown:(id)sender
{
    self.progressSilderTouching = YES;
}

- (void)progressTouchUp:(id)sender
{
    self.progressSilderTouching = NO;
    [self.player seekToTime:self.player.duration * self.progressSilder.value];
    self.playTime.text = [self timeStringFromSeconds:self.progressSilder.value];
}

//播放进度，改变播放时间和进度条进度
- (void)progressAction:(NSNotification *)notification
{
    SGProgress * progress = [SGProgress progressFromUserInfo:notification.userInfo];
    if (!self.progressSilderTouching) {
        self.progressSilder.value = progress.percent;
    }
    self.playTime.text = [self timeStringFromSeconds:progress.current];
}
//缓冲进度
- (void)playableAction:(NSNotification *)notification
{
    SGPlayable * playable = [SGPlayable playableFromUserInfo:notification.userInfo];
    [UIView animateWithDuration:0.1 animations:^{
        self.progressSilder.playableProgress = playable.percent;
    }];
    NSLog(@"playable time : %f", playable.current);

}

- (void)errorAction:(NSNotification *)notification
{
    SGError * error = [SGError errorFromUserInfo:notification.userInfo];
    NSLog(@"player did error : %@", error.error);
}

- (NSString *)timeStringFromSeconds:(CGFloat)seconds
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

- (void)dealloc
{
    [self.player removePlayerNotificationTarget:self];
}


#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VideoListModel *model = self.dataSource[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.img] placeholder:nil];
    cell.titlelabel.text = model.title;
    cell.sublabel.text = [NSString stringWithFormat:@"%d Views",model.plays];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108 * (kScreenWidth - 30) / 330.0 + 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorHex(0x151618);
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hot List";
    label.font = [UIFont systemFontOfSize:Font(16)];
    label.textColor = UIColorHex(0xFFFFFF);
    label.size = CGSizeMake(kScreenWidth - Width(60), 21);
    label.origin = CGPointMake(Width(15), 15);
    [headerView addSubview:label];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListModel *model = self.dataSource[indexPath.row];
    [self.player replaceVideoWithURL:[NSURL URLWithString:model.url] videoType:SGVideoTypeVR];
    [self.player play];
    self.playBut.hidden = YES;
    self.titleLabel.text = model.title;
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
