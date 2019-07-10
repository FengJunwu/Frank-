//
//  VideoSlider.h
//  Frank
//
//  Created by fengjunwu on 2019/6/29.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoSlider : UISlider
/** 缓冲条进度 */
@property (assign,nonatomic) CGFloat playableProgress;

@end

NS_ASSUME_NONNULL_END
