//
//  DFZMovieView.m
//  StartAppWithLaunchMovie
//
//  Created by 邓法芝 on 2017/7/8.
//  Copyright © 2017年 邓法芝. All rights reserved.
//

#import "DFZMovieView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+LaunchImage.h"
#import "PrivacyProtocolAlertView.h"


@interface AnimationDelegate : NSObject  <CAAnimationDelegate>

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.player play];
}

@end

@interface DFZMovieView() <CAAnimationDelegate>

@property (nonatomic, weak) AVPlayer *player;
@property (nonatomic, weak) UIButton *enterMainButton;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;

@end

@implementation DFZMovieView

+ (instancetype)MovieView {
    DFZMovieView *movieView = [[super alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return movieView;
}

- (void)setMovieURL:(NSURL *)movieURL {
    _movieURL = movieURL;
    CALayer *backLayer = [CALayer layer];
    backLayer.frame = [UIScreen mainScreen].bounds;
    backLayer.contents = (__bridge id _Nullable)([UIImage getLaunchImage].CGImage);
    [self.layer addSublayer:backLayer];
    
    AVPlayer *player = [[AVPlayer alloc] initWithURL:_movieURL];
    self.player = player;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerLayer = playerLayer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;///等比例填充，直到一个维度到达区域边界
    playerLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer addSublayer:playerLayer];
    
//    UIButton *enterMainButton = [[UIButton alloc] init];
//    self.enterMainButton = enterMainButton;
//    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
//    [self addSubview:enterMainButton];
//    enterMainButton.layer.borderWidth = 1;
//    enterMainButton.layer.cornerRadius = 24;
//    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
//    enterMainButton.alpha = 0.0;
//
//    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.scaleAnimation = scaleAnimation;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = 3.0f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    AnimationDelegate *animationDelegate = [AnimationDelegate new];
    animationDelegate.player = self.player;
    scaleAnimation.delegate = animationDelegate;
    [self.playerLayer addAnimation:scaleAnimation forKey:nil];
    [UIView animateWithDuration:3.0 animations:^{
        self.enterMainButton.alpha = 1.0;
    }];
}

- (void)removeFromSuperview {
    [self.player pause];
    self.player = nil;
    self.scaleAnimation.delegate = nil;
    self.scaleAnimation = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

-(void)dealloc {
    NSLog(@"视频已移除");
}

- (void)playbackFinished:(NSNotification *)notifation {
    // 回到视频的播放起点
//    [self.player seekToTime:kCMTimeZero];
//    [self.player play];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAgree"] isEqualToString:@"agree"]){
        [self removeFromSuperview];
    }else{
        PrivacyProtocolAlertView *alertView = [[PrivacyProtocolAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [alertView setWeb_Url:@"http://193.112.161.208/bahuangweb/Privacypolicy.html"];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        
        __weak __typeof(self) weakSelf = self;
        alertView.exitApplication = ^{
            [weakSelf exitApplication];
        };
        alertView.agreedToApplication = ^{
            [[NSUserDefaults standardUserDefaults] setObject:@"agree" forKey:@"isAgree"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf removeFromSuperview];
        };
    }
}

- (void)exitApplication {
    //直接退，看起来好像是 crash 所以做个动画
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        //退出代码
        exit(0);
    }
}


- (void)enterMainAction:(UIButton *)btn {
    [self removeFromSuperview];
    
}

@end
