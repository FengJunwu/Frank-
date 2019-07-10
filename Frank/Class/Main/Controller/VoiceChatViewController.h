//
//  VoiceChatViewController.h
//  Frank
//
//  Created by kingunionLCF on 2019/6/25.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VoiceChatViewDelegate <NSObject>


/**
 播放视频

 @param videoUrl 视频url
 */
-(void)playVideo:(NSString *)videoUrl;

/**
 播放Mp3

 @param mp3Url mp3 URL
 */
-(void)playMp3:(NSString *)mp3Url bgImg:(NSString *)bgImg;

/**
 播放对话

 @param DialogueContent 对话内容
 */
-(void)playDialogue:(NSString *)DialogueContent;


@end


@interface VoiceChatViewController : UIViewController

@property (nonatomic,weak) id<VoiceChatViewDelegate>delegate;

@property (nonatomic,strong)NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END
