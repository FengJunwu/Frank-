//
//  InformationViewModel.h
//  Frank
//
//  Created by fengjunwu on 2019/7/7.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationViewModel : NSObject

+(void)getNotificationListWithBlock:(void(^)(NSArray *dataSource,NSError *error))block;

@end

NS_ASSUME_NONNULL_END
