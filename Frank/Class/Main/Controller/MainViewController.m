//
//  MainViewController.m
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "MainViewController.h"

#import "SGPagingView.h"
#import "NavigationBarTitleView.h"
#import "VoiceViewController.h"
#import "VideoViewController.h"

@interface MainViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *childArr;

@property (nonatomic,assign) BOOL isShow;
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"Missdoll";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单图标"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = back;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    _isShow = YES;
    
    [self setupNavigationBar];
}

#pragma mark--显示左菜单
-(void)backClick{
    //通知停止播放视频
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopPlayingVideo" object:nil];
    if (_isShow) {
        _isShow = NO;
        [self.xl_sldeMenu showLeftViewControllerAnimated:true];
    }else{
        
        [self.xl_sldeMenu showRootViewControllerAnimated:true];
        _isShow = YES;
    }
    
}


-(NSMutableArray *)childArr{
    if (!_childArr) {
        _childArr = [[NSMutableArray alloc] init];
    }
    return _childArr;
}

- (void)setupNavigationBar {
    
    VoiceViewController *VoiceVC = [[VoiceViewController alloc] init];
    VoiceVC.ver = self.ver;
    VoiceVC.characterId = self.characterId;
    VoiceVC.writeCharacteristics = self.writeCharacteristics;
    VoiceVC.readCharacteristics = self.readCharacteristics;
    VoiceVC.peripheral = self.peripheral;
    [self.childArr addObject:VoiceVC];
    
    
    VideoViewController *VideoVC = [[VideoViewController alloc] init];
    [self.childArr addObject:VideoVC];
    VideoVC.writeCharacteristics = self.writeCharacteristics;
    VideoVC.readCharacteristics = self.readCharacteristics;
    VideoVC.peripheral = self.peripheral;
    self.titleArr = @[@"Voice",@"Video"];
    

    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.indicatorScrollStyle = SGIndicatorScrollStyleDefault;
    configure.bottomSeparatorColor = [UIColor clearColor];
    configure.titleFont = [UIFont boldSystemFontOfSize:Font(16)];
    configure.titleSelectedFont = [UIFont boldSystemFontOfSize:Font(16)];
    configure.titleColor = [UIColorHex(0xFFFFFF) colorWithAlphaComponent:0.4];
    configure.titleSelectedColor = UIColorHex(0xFF9500);
    configure.indicatorColor = UIColorHex(0xFF9500);
    configure.indicatorHeight = 2;
    configure.indicatorCornerRadius = 2;
    configure.indicatorDynamicWidth = Width(47);
    //    configure.
    configure.indicatorToBottomDistance = 1;
    /// pageTitleView
    // 这里的 - 10 是为了让 SGPageTitleView 超出父视图，给用户一种效果体验
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - Width(200), 44) delegate:self titleNames:self.titleArr configure:configure];
//    self.pageTitleView.isNeedBounces = NO;
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    
    // 对 navigationItem.titleView 的包装，为的是 让View 占据整个视图宽度
    NavigationBarTitleView *view = [[NavigationBarTitleView alloc] initWithFrame:CGRectMake(Width(100), 0, [UIScreen mainScreen].bounds.size.width - Width(200), 44)];
    self.navigationItem.titleView = view;
    [view addSubview:_pageTitleView];
    
    CGFloat contentViewHeight = self.view.frame.size.height;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:self.childArr];
    _pageContentView.delegatePageContentView = self;
    _pageContentView.isScrollEnabled = NO;
    _pageTitleView.selectedIndex = 0;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
    
    if (selectedIndex == 1) {
        NSLog(@"停止视频播放");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftStopPlayingVideo" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rightStopPlayingVideo" object:nil];
    }
    
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
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
