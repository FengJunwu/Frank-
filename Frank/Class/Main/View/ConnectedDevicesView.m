//
//  ConnectedDevicesView.m
//  Frank
//
//  Created by fengjunwu on 2019/7/6.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "ConnectedDevicesView.h"

@interface ConnectedDevicesView()
@property (nonatomic,strong)UIView *bg_View;

@end

@implementation ConnectedDevicesView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *bg_View = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bg_View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
    [self addSubview:bg_View];
    self.bg_View = bg_View;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.bg_View  addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    UIView *white_View = [[UIView alloc] init];
    white_View.backgroundColor = [UIColor whiteColor];
    [self addSubview:white_View];
    //    [bg_View addSubview:white_View];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Content a Bluetooth device for a surprise experience (you can continue to experience the product without a device)";
    titleLabel.textColor = UIColorHex(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    [white_View addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(0x9B9B9B);
    [white_View addSubview:lineView];
    
    UIButton *continueExperienceBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueExperienceBut setTitle:@"Continue to experience" forState:UIControlStateNormal];
    continueExperienceBut.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [continueExperienceBut setTitleColor:UIColorHex(0x007AFF) forState:UIControlStateNormal];
    [continueExperienceBut addTarget:self action:@selector(continueExperienceButAction) forControlEvents:UIControlEventTouchUpInside];
    [white_View addSubview:continueExperienceBut];
    
    UIButton *connectionBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [connectionBut setTitle:@"Connection" forState:UIControlStateNormal];
    connectionBut.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [connectionBut setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
    connectionBut.backgroundColor = UIColorHex(0xFFAA33);
    [connectionBut addTarget:self action:@selector(connectionButAction) forControlEvents:UIControlEventTouchUpInside];
    [white_View addSubview:connectionBut];
    
    
    UIButton *buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBut setTitle:@"Buy" forState:UIControlStateNormal];
    buyBut.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [buyBut setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
    buyBut.backgroundColor = UIColorHex(0xFF9500);
    [buyBut addTarget:self action:@selector(buyButAction) forControlEvents:UIControlEventTouchUpInside];
    [white_View addSubview:buyBut];
    
    
    white_View.sd_layout
    .centerXEqualToView(bg_View)
    .centerYEqualToView(bg_View)
    .widthRatioToView(bg_View, 0.7)
    .heightEqualToWidth();
    white_View.sd_cornerRadius = @20;
    
    
    titleLabel.sd_layout
    .topSpaceToView(white_View, 18)
    .leftSpaceToView(white_View, 30)
    .rightSpaceToView(white_View, 20)
    .autoHeightRatio(0);
    
    lineView.sd_layout
    .bottomSpaceToView(white_View, Width(55))
    .leftEqualToView(white_View)
    .rightEqualToView(white_View)
    .heightIs(1);
    
    continueExperienceBut.sd_layout
    .topSpaceToView(lineView, 0)
    .leftEqualToView(white_View)
    .rightEqualToView(white_View)
    .bottomEqualToView(white_View);
    
    connectionBut.sd_layout
    .bottomSpaceToView(lineView, Width(20))
    .leftSpaceToView(white_View, Width(20))
    .widthIs(kMainScreenWidth * 0.7 / 2.0 - Width(20))
    .heightIs(Width(44));
    
    buyBut.sd_layout
    .bottomSpaceToView(lineView, Width(20))
    .rightSpaceToView(white_View, Width(20))
    .widthIs(kMainScreenWidth * 0.7 / 2.0 - Width(20))
    .heightIs(Width(44));
    
    
}


#pragma mark-- 单击手势
-(void)singleTap{
    [self removeFromSuperview];
    [self.bg_View removeFromSuperview];
    [[self.bg_View subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bg_View = nil;
}

#pragma mark--继续浏览
-(void)continueExperienceButAction{
    [self removeFromSuperview];
    [self.bg_View removeFromSuperview];
    [[self.bg_View subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bg_View = nil;
}
#pragma mark--连接
-(void)connectionButAction{
    NSLog(@"连接");
}

#pragma mark--购买
-(void)buyButAction{
    NSLog(@"购买");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
