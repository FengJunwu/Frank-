//
//  VoiceChaitModel.h
//  Frank
//
//  Created by fengjunwu on 2019/7/4.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceChaitModel : NSObject

@property (nonatomic,strong) NSString *characterId;
@property (nonatomic,strong) NSString *ask;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
