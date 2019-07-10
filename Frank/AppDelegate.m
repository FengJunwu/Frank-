//
//  AppDelegate.m
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "MainViewController.h"
#import "BluetoothConnectionViewController.h"
#import "DFZMovieView.h"
#import "PrivacyProtocolAlertView.h"
#import "BaseNavigationViewController.h"
#import "VoiceAssistantViewController.h"
#import <iflyMSC/iflyMSC.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self baseURL];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor purpleColor];
    //主界面
    MainViewController *vc = [[MainViewController alloc] init];
    //选择模特
    VoiceAssistantViewController *VoiceAssistantVC = [[VoiceAssistantViewController alloc] init];
    //配置NavigationBar
    NSString *characterId = [[NSUserDefaults standardUserDefaults] objectForKey:@"characterId"];
    NSString *ver = [[NSUserDefaults standardUserDefaults] objectForKey:@"ver"];
    BaseNavigationViewController *rootNav;
    if (characterId.length > 0 && ver.length > 0) {
        rootNav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    }else{
        rootNav = [[BaseNavigationViewController alloc] initWithRootViewController:VoiceAssistantVC];
    }
    
//    [rootNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarBackImage"] forBarMetrics:UIBarMetricsDefault];
//    rootNav.navigationBar.tintColor = [UIColor whiteColor];
//    [rootNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //左侧菜单
    DrawerViewController *leftVC = [[DrawerViewController alloc] init];
    //右侧菜单
//    BluetoothConnectionViewController *rightVC = [[BluetoothConnectionViewController alloc] init];
    //创建滑动菜单
    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
    slideMenu.slideEnabled = NO;
    //设置左右菜单
    slideMenu.leftViewController = leftVC;
    

    self.window.rootViewController = slideMenu;
    [self.window makeKeyAndVisible];
    
    NSString *versionCache = [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionCache"];// 本地缓存的版本号  第一次启动的时候本地是没有缓存版本号的。
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];// 当前应用版本号
    if (![versionCache isEqualToString:version]) { // 如果本地缓存的版本号和当前应用版本号不一样，则是第一次启动（更新版本也算第一次启动）
        //        DFZMovieController *movieVC = [[DFZMovieController alloc] init];
        DFZMovieView *movieVC = [DFZMovieView MovieView];
        movieVC.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"闪屏" ofType:@"mp4"]];// 选择本地的视屏
        [self.window addSubview:movieVC];
        
        // 设置上面这句话，将当前版本缓存到本地，下次对比一样，就不走启动视屏了。
        // 也可以将这句话放在WSMovieController.m的进入应用方法里面
        // 为了让每次都可以看到启动视屏，这句话先注释掉
        // [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"VersionCache"];
        
        bg_setDebug(NO);
        
    }
    
    //Set log level
    [IFlySetting setLogFile:LVL_NORMAL];
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
    
    return YES;
}


#pragma mark --baseURL
-(void)baseURL{
    // 通常放在appdelegate就可以了
    [HYBNetworking updateBaseUrl:URL_DOMAIN];
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [HYBNetworking configRequestType:kHYBRequestTypeJSON
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:NO
             callbackOnCancelRequest:NO];
    
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    //开启打印
    [HYBNetworking enableInterfaceDebug:YES];
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {
    //    是非支持横竖屏
    if (_allowRotation) {
        return UIInterfaceOrientationMaskAll;
    } else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotation) {
        return YES;
    }
    return NO;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
