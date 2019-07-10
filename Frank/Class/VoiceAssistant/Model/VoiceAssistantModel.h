//
//  VoiceAssistantModel.h
//  Frank
//
//  Created by fengjunwu on 2019/6/22.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class textRecognize;
@interface VoiceAssistantModel : NSObject

/*
 "": "J002",
 "": "5",
 "": "Bella",
 "": "My name is Bella",
 "": "/J002_5/pictures/j002.png",
 "": "/J002_5/voice/j002.mp3",
 "textRecognize": [{
 */
@property(nonatomic,copy)NSString* characterId;
@property(nonatomic,copy)NSString* ver;
@property(nonatomic,copy)NSString* nickName;
@property(nonatomic,copy)NSString* desc;
@property(nonatomic,copy)NSString* bgImg;
@property(nonatomic,copy)NSString* descVoice;
@property(nonatomic,copy)NSArray* textRecognize;

@end


@interface textRecognize : NSObject
/*
 "": "How are you",
 "": "I'm fine,thank you",
 "": "1",
 "": "",
 "": "/J002_5/voice/j002_a002.mp3",
 "": "/J002_5/videos/j002_b002.mp4",
 "": "a002",
 "": "/J002_5/pictures/c2.png"
 */

@property(nonatomic,copy)NSString* keyWord;
@property(nonatomic,copy)NSString* responce;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* bgImg;
@property(nonatomic,copy)NSString* bgVoice;
@property(nonatomic,copy)NSString* bgVideo;
@property(nonatomic,copy)NSString* command;
@property(nonatomic,copy)NSString* commandImg;

@end

@interface DataModel : NSObject
/*
  = J001;
  = "https://frank-video-test.s3.us-east-2.amazonaws.com/character/J001/J001_5.zip";
  = 5;
 */
@property(nonatomic,copy)NSString* characterId;
@property(nonatomic,copy)NSString* resourceUrl;
@property(nonatomic,copy)NSString* ver;

@end



NS_ASSUME_NONNULL_END
