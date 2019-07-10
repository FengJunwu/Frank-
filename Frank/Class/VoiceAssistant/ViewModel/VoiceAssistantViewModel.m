//
//  VoiceAssistantViewModel.m
//  Frank
//
//  Created by fengjunwu on 2019/6/21.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VoiceAssistantViewModel.h"
#import "VoiceAssistantModel.h"

@implementation VoiceAssistantViewModel


+(void)getCharacterListWithBlock:(void (^)(NSArray * _Nonnull, NSError * _Nonnull))block{
    
    [HYBNetworking postWithUrl:URL_character_list refreshCache:YES params:nil success:^(id response) {
        
        if ([KCode isEqualToString:@"000"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *dataSource = [NSMutableArray new];
                NSError *error = nil;
                for (NSDictionary *dic in response[@"data"]) {
                    DataModel *model = [DataModel  modelWithDictionary:dic];
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
