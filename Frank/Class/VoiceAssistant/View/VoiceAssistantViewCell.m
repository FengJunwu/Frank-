//
//  VoiceAssistantViewCell.m
//  Frank
//
//  Created by fengjunwu on 2019/6/20.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VoiceAssistantViewCell.h"

@interface VoiceAssistantViewCell()

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong) YYLabel *titleLabel;
@property (nonatomic,strong) YYLabel *subTextLabel;


@end

@implementation VoiceAssistantViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"%f--%f",frame.size.width,frame.size.height);
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = self.bounds;
//        _imgView.image = [UIImage imageNamed:@"语音适配3"];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [[YYLabel alloc] init];
//        _titleLabel.text = @"jessica jane clement";
        _titleLabel.size = CGSizeMake(kMainScreenWidth - Width(30), Width(30));
        _titleLabel.left = Width(15);
        _titleLabel.top = Height(344);
        _titleLabel.font = [UIFont boldSystemFontOfSize:Font(22)];
        _titleLabel.textColor = UIColorHex(0xFFFFFF);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _subTextLabel = [[YYLabel alloc] init];
//        _subTextLabel.text = @"Jessica-Jane Stafford was born on February 24, 1985 in Sheffield, South ...Sister of Robert Clement. Star Sign Pisces...";
        _subTextLabel.numberOfLines = 3;
        _subTextLabel.width = kMainScreenWidth - Width(60);
        _subTextLabel.height = Width(68);
        _subTextLabel.left = Width(30);
        _subTextLabel.top = _titleLabel.bottom + Width(4);
        _subTextLabel.font = [UIFont systemFontOfSize:Font(13)];
        _subTextLabel.textColor = UIColorHex(0xFFFFFF);
        _subTextLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTextLabel];
        
        UIButton *confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBut.size = CGSizeMake(Width(125), Width(43));
        confirmBut.centerX = self.contentView.centerX;
        confirmBut.top = _subTextLabel.bottom + Height(37);
        [confirmBut setBackgroundImage:[UIImage imageNamed:@"确定按钮"] forState:UIControlStateNormal];
        [confirmBut setTitle:@"Confirm" forState:UIControlStateNormal];
        [confirmBut setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
        confirmBut.titleLabel.font = [UIFont systemFontOfSize:Font(10)];
        [confirmBut addTarget:self action:@selector(confirmButAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:confirmBut];
        
    }
    return self;
}

-(void)setImgURL:(NSString *)imgURL{
    
    self.imgView.image = [UIImage imageNamed:imgURL];
}

-(void)setModel:(VoiceAssistantModel *)model{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgImg];
    self.imgView.image = [UIImage imageWithContentsOfFile:path];
    
    _titleLabel.text = model.nickName;
    _subTextLabel.text = model.desc;
    
}
#pragma mark--提交
-(void)confirmButAction{
    if (self.confirmBut) {
        self.confirmBut();
    }
}

@end
