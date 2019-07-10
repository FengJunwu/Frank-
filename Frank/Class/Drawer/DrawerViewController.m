//
//  DrawerViewController.m
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "DrawerViewController.h"

#import "BaseNavigationViewController.h"
#import "MainViewController.h"
#import "VoiceAssistantViewController.h"
#import "BluetoothConnectionViewController.h"
#import "AboutUsViewController.h"
#import "InformationViewController.h"

@interface DrawerViewController ()<BluetoothDelegate>


@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"抽屉背景"]];
    bgImg.frame = self.view.bounds;
    [self.view addSubview:bgImg];
    
    UIButton *missdollBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [missdollBut setTitle:@"Missdoll" forState:UIControlStateNormal];
    [missdollBut setTitleColor:RGB16Color(0xFFFFFF) forState:UIControlStateNormal];
    missdollBut.titleLabel.font = AAFont(28);
    missdollBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    missdollBut.frame = AAdaptionRect(80, 480, 275, 60);
    [missdollBut addTarget:self action:@selector(missdollButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:missdollBut];
    
    UIView *missdollView = [[UIView alloc] init];
    missdollView.backgroundColor = RGB16Color(0xE58703);
    missdollView.size = AAdaptionSize(3, 37);
    missdollView.left = AAdaption(58);
    missdollView.centerY = missdollBut.centerY;
    [self.view addSubview:missdollView];
    
    
    UIButton *voiceAssistantBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceAssistantBut setTitle:@"Voice Assistant" forState:UIControlStateNormal];
    [voiceAssistantBut setTitleColor:RGB16Color(0xFFFFFF) forState:UIControlStateNormal];
    voiceAssistantBut.titleLabel.font = AAFont(28);
    voiceAssistantBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    voiceAssistantBut.frame = AAdaptionRect(80, 556, 275, 60);
    [voiceAssistantBut addTarget:self action:@selector(voiceAssistantButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceAssistantBut];
    
    UIView *voiceAssistantView = [[UIView alloc] init];
    voiceAssistantView.backgroundColor = RGB16Color(0xE58703);
    voiceAssistantView.size = AAdaptionSize(3, 37);
    voiceAssistantView.left = AAdaption(58);
    voiceAssistantView.centerY = voiceAssistantBut.centerY;
    [self.view addSubview:voiceAssistantView];
    
    UIButton *activationEquipmentBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [activationEquipmentBut setTitle:@"Activation equipment" forState:UIControlStateNormal];
    [activationEquipmentBut setTitleColor:RGB16Color(0xFFFFFF) forState:UIControlStateNormal];
    activationEquipmentBut.titleLabel.font = AAFont(28);
    activationEquipmentBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    activationEquipmentBut.frame = AAdaptionRect(80, 632, 275, 60);
    [activationEquipmentBut addTarget:self action:@selector(activationEquipmentButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activationEquipmentBut];
    
    UIView *activationEquipmentView = [[UIView alloc] init];
    activationEquipmentView.backgroundColor = RGB16Color(0xE58703);
    activationEquipmentView.size = AAdaptionSize(3, 37);
    activationEquipmentView.left = AAdaption(58);
    activationEquipmentView.centerY = activationEquipmentBut.centerY;
    [self.view addSubview:activationEquipmentView];
    
    UIButton *aboutUsBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutUsBut setTitle:@"About us" forState:UIControlStateNormal];
    [aboutUsBut setTitleColor:RGB16Color(0xFFFFFF) forState:UIControlStateNormal];
    aboutUsBut.titleLabel.font = AAFont(28);
    aboutUsBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    aboutUsBut.frame = AAdaptionRect(80, 708, 275, 60);
    [aboutUsBut addTarget:self action:@selector(aboutUsButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutUsBut];
    
    UIView *aboutUsView = [[UIView alloc] init];
    aboutUsView.backgroundColor = RGB16Color(0xE58703);
    aboutUsView.size = AAdaptionSize(3, 37);
    aboutUsView.left = AAdaption(58);
    aboutUsView.centerY = aboutUsBut.centerY;
    [self.view addSubview:aboutUsView];
    
    UIButton *informationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [informationBut setTitle:@"Information" forState:UIControlStateNormal];
    [informationBut setTitleColor:RGB16Color(0xFFFFFF) forState:UIControlStateNormal];
    informationBut.titleLabel.font = AAFont(28);
    informationBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    informationBut.frame = AAdaptionRect(80, 784, 275, 60);
    [informationBut addTarget:self action:@selector(informationButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:informationBut];
    
    UIView *informationView = [[UIView alloc] init];
    informationView.backgroundColor = RGB16Color(0xE58703);
    informationView.size = AAdaptionSize(3, 37);
    informationView.left = AAdaption(58);
    informationView.centerY = informationBut.centerY;
    [self.view addSubview:informationView];
}


-(void)missdollButAction:(UIButton *)sender{
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
    self.xl_sldeMenu.slideEnabled = NO;
    MainViewController *MainVC = [[MainViewController alloc] init];
    MainVC.peripheral = self.peripheral;
    MainVC.readCharacteristics = self.readCharacteristics;
    MainVC.writeCharacteristics = self.writeCharacteristics;
    UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:MainVC animated:NO];
//    BaseNavigationViewController *rootNav = [[BaseNavigationViewController alloc] initWithRootViewController:MainVC];
//    //创建滑动菜单
//    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
//    //设置左右菜单
//    slideMenu.leftViewController = self;
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = self.xl_sldeMenu;
//    [window makeKeyAndVisible];
    
}

-(void)voiceAssistantButAction:(UIButton *)sender{
    
    
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
    self.xl_sldeMenu.slideEnabled = NO;
    VoiceAssistantViewController *VoiceAssistantVC = [[VoiceAssistantViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:VoiceAssistantVC animated:NO];
    
//    BaseNavigationViewController *rootNav = [[BaseNavigationViewController alloc] initWithRootViewController:VoiceAssistantVC];
//    //创建滑动菜单
//    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
//    //设置左右菜单
//    slideMenu.leftViewController = self;
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = self.xl_sldeMenu;
//    [window makeKeyAndVisible];
}

-(void)activationEquipmentButAction:(UIButton *)sender{
    
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
    self.xl_sldeMenu.slideEnabled = NO;
    BluetoothConnectionViewController *BluetoothConnectionVC = [[BluetoothConnectionViewController alloc] init];
    BluetoothConnectionVC.delegate = self;
    UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:BluetoothConnectionVC animated:NO];
//    BaseNavigationViewController *rootNav = [[BaseNavigationViewController alloc] initWithRootViewController:BluetoothConnectionVC];
//    //创建滑动菜单
//    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
//    //设置左右菜单
//    slideMenu.leftViewController = self;
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = self.xl_sldeMenu;
//    [window makeKeyAndVisible];
}

-(void)aboutUsButAction:(UIButton *)sender{
    
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
    self.xl_sldeMenu.slideEnabled = NO;
    AboutUsViewController *AboutUsV = [[AboutUsViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:AboutUsV animated:false];
}

-(void)informationButAction:(UIButton *)sender{
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
    self.xl_sldeMenu.slideEnabled = NO;
    InformationViewController *InformationVC = [[InformationViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:InformationVC animated:false];
    
}

#pragma mark--BluetoothDelegate
-(void)changeCBPeripheral:(CBPeripheral *)peripheral CBCharacteristic:(CBCharacteristic *)writeCharacteristics CBCharacteristic:(CBCharacteristic *)readCharacteristics{
    
    _peripheral = peripheral;
    _writeCharacteristics = writeCharacteristics;
    _readCharacteristics = readCharacteristics;
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
