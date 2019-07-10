//
//  VideoListModel.h
//  Frank
//
//  Created by fengjunwu on 2019/6/28.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListModel : NSObject
/*
 config =             (
 {
 cmdId = 0102;
 time = "00:01:02";
 },
 {
 cmdId = 0202;
 time = "00:05:01";
 }
 );
 img = "https://frank-video-test.s3.us-east-2.amazonaws.com/other/IMG_3120.png";
 plays = 0;
 subtitle = "oh my god";
 title = "the fantasty video!!!";
 url = "https://frank-video-test.s3.us-east-2.amazonaws.com/video//TEST01.mp4";
 videoId = VID01;
 */

@property (nonatomic,strong)NSString *img;
@property (nonatomic,assign)int plays;
@property (nonatomic,strong)NSString *subtitle;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *videoId;
@property (nonatomic,strong)NSArray *config;


@end

@interface ConfigModel : NSObject

@property (nonatomic,strong)NSString *cmdId;
@property (nonatomic,strong)NSString *time;

@end


NS_ASSUME_NONNULL_END
