//
//  UserDefaultDefines.h
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#ifndef UserDefaultDefines_h
#define UserDefaultDefines_h


#define RGB16Color(rgbValue)  [UIColor colorWithRed:((float)((rgbValue& 0xFF0000) >>16))/255.0 green:((float)((rgbValue&  0xFF00)  >>8))/255.0 blue:((float)(rgbValue&  0xFF))/255.0 alpha:1.0]


//判断是否是ipad
#define iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !iPad : NO)

//iPhoneX系列
#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)

#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)

#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

#define Height_Bottom_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34.0 : 0.0)


/** 设备屏幕宽 */
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width
/** 设备屏幕高度 */
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define Width(R) (R)*(kMainScreenWidth)/375.0 //这里的375我是针对6s为标准适配的,如果需要其他标准可以修改
#define Height(R) (R)*(kMainScreenHeight)/667.0 //这里的667我是针对6s为标准适配的,如果需要其他标准可以修改 代码简单我就不介绍了, 以此思想,我们可以对字体下手
#define Font(R) (R)*(kMainScreenWidth)/375.0 //这里是6s屏幕字体


#define bg_tablename @"frank"
#define bg_reportedDatatableName @"reportedData"

//蓝牙
#define channelOnPeropheralView @"peripheralView"
#define writeOnCharacteristicView @"writeCharacteristicView"
#define readOnCharacteristicView @"readOnCharacteristicView"


#define KCode response[@"code"]

#endif /* UserDefaultDefines_h */
