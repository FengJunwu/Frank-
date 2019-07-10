//
//  VoiceAssistantViewCell.h
//  Frank
//
//  Created by fengjunwu on 2019/6/20.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceAssistantModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfirmButBlock)(void);
@interface VoiceAssistantViewCell : UICollectionViewCell


@property (nonatomic,strong) VoiceAssistantModel *model;

@property (nonatomic,copy)ConfirmButBlock confirmBut;

@end

NS_ASSUME_NONNULL_END
