//
//  VideoListViewModel.m
//  Frank
//
//  Created by fengjunwu on 2019/6/28.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VideoListViewModel.h"
#import "VideoListModel.h"


@implementation VideoListViewModel

+(void)getCharacterListWithBlock:(void (^)(NSArray * _Nonnull, NSError * _Nonnull))block{
    
    [HYBNetworking postWithUrl:URL_video_list refreshCache:YES params:nil success:^(id response) {
        
        if ([KCode isEqualToString:@"000"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *dataSource = [NSMutableArray new];
                NSError *error = nil;
                
                NSLog(@"%@",response);
                for (NSDictionary *dic in response[@"data"]) {
                    VideoListModel *model = [VideoListModel  modelWithDictionary:dic];
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
