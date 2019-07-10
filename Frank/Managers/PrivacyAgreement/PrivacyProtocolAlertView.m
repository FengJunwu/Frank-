//
//  PrivacyProtocolAlertView.m
//  Alert
//
//  Created by 冯俊武 on 2018/11/28.
//  Copyright © 2018 冯俊武. All rights reserved.
//

#import "PrivacyProtocolAlertView.h"



#pragma mark 获取屏幕的宽
#define MainWidth [UIScreen mainScreen].bounds.size.width
#pragma mark 获取屏幕的高
#define MainHeight [UIScreen mainScreen].bounds.size.height

@interface PrivacyProtocolAlertView ()

@property (nonatomic,strong)UIView *bg_View;
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation PrivacyProtocolAlertView


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


-(void)setWeb_Url:(NSString *)web_Url{
    
    NSString *encodedString = [web_Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:weburl]];
}


-(void)configUI{
    
    UIView *bg_View = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bg_View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self addSubview:bg_View];
    self.bg_View = bg_View;
    
    UIView *white_View = [[UIView alloc] init];
    white_View.backgroundColor = [UIColor whiteColor];
    [bg_View addSubview:white_View];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"隐私协议";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 2;
    [white_View addSubview:titleLabel];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    [white_View addSubview:webView];
    self.webView = webView;
    
    UIView *line_View1 = [[UIView alloc] init];
    line_View1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [white_View addSubview:line_View1];
    
    UIView *line_View2 = [[UIView alloc] init];
    line_View2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [white_View addSubview:line_View2];
    
    UIButton *agreeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBut setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    agreeBut.titleLabel.font = [UIFont systemFontOfSize:18];
    [agreeBut addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [white_View addSubview:agreeBut];
    
    UIButton *centerBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBut setTitle:@"不同意" forState:UIControlStateNormal];
    [centerBut setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    centerBut.titleLabel.font = [UIFont systemFontOfSize:18];
    [centerBut addTarget:self action:@selector(centerAction:) forControlEvents:UIControlEventTouchUpInside];
    centerBut.userInteractionEnabled = YES;
    [white_View addSubview:centerBut];
    
    white_View.sd_layout
    .centerXEqualToView(bg_View)
    .centerYEqualToView(bg_View)
    .widthRatioToView(bg_View, 0.8)
    .heightRatioToView(bg_View, 0.6);
    white_View.sd_cornerRadius = @20;
    
    
    titleLabel.sd_layout
    .topSpaceToView(white_View, 30)
    .leftSpaceToView(white_View, 30)
    .rightSpaceToView(white_View, 20)
    .heightIs(50);
    
    webView.sd_layout
    .topSpaceToView(titleLabel, 10)
    .leftSpaceToView(white_View, 30)
    .rightSpaceToView(white_View, 30)
    .bottomSpaceToView(white_View, 60);

    line_View1.sd_layout
    .bottomSpaceToView(white_View, 51)
    .leftSpaceToView(white_View, 10)
    .rightSpaceToView(white_View, 10)
    .heightIs(1.5);
    
    line_View2.sd_layout
    .topEqualToView(line_View1)
    .bottomEqualToView(white_View)
    .centerXEqualToView(white_View)
    .widthIs(1.5);
    
    agreeBut.sd_layout
    .topEqualToView(line_View1)
    .leftEqualToView(line_View2)
    .rightEqualToView(white_View)
    .bottomEqualToView(white_View);
    
    centerBut.sd_layout
    .topEqualToView(line_View1)
    .leftEqualToView(white_View)
    .rightEqualToView(line_View2)
    .bottomEqualToView(white_View);
    
}

#pragma mark--同意
-(void)agreeAction:(UIButton *)sender{

    [self removeFromSuperview];
    [self.bg_View removeFromSuperview];
    [[self.bg_View subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bg_View = nil;
    //存储同意的标识 下次不再弹出
    [[NSUserDefaults standardUserDefaults] setObject:@"agree" forKey:@"isAgree"];
    if (self.agreedToApplication) {
        self.agreedToApplication();
    }
}
#pragma mark--退出应用
-(void)centerAction:(UIButton *)sender{
    
    if (self.exitApplication) {
        self.exitApplication();
    }
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
