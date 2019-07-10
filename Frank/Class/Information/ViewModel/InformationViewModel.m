//
//  InformationViewModel.m
//  Frank
//
//  Created by fengjunwu on 2019/7/7.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "InformationViewModel.h"
#import "InformationModel.h"

@implementation InformationViewModel

+(void)getNotificationListWithBlock:(void (^)(NSArray * _Nonnull, NSError * _Nonnull))block{
    
    [HYBNetworking postWithUrl:URL_notification_list refreshCache:YES params:nil success:^(id response) {
        
        if ([KCode isEqualToString:@"000"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableArray *dataSource = [NSMutableArray new];
                NSError *error = nil;

                NSLog(@"%@",response);
                for (NSDictionary *dic in response[@"data"]) {
                    InformationModel *model = [InformationModel  modelWithDictionary:dic];
                    [dataSource addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(dataSource, error);
                });
            });
        }
        
    } fail:^(NSError *error) {
        
    }];
}

@end
