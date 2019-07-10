//
//  PrivacyProtocolAlertView.h
//  Alert
//
//  Created by 冯俊武 on 2018/11/28.
//  Copyright © 2018 冯俊武. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//退出应用
typedef void(^exitApplication)(void);
typedef void(^AgreedToApplication)(void);
@interface PrivacyProtocolAlertView : UIView
@property (nonatomic,strong) NSString *web_Url;

@property (nonatomic,copy)exitApplication exitApplication;

@property (nonatomic,copy)AgreedToApplication agreedToApplication;

@end

NS_ASSUME_NONNULL_END
