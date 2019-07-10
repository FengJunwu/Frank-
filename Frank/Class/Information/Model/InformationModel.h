//
//  InformationModel.h
//  Frank
//
//  Created by fengjunwu on 2019/7/7.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationModel : NSObject

/*
  = "the second news !!!!";
  = "https://www.baidu.com";
  = INFO02;
  = "http://internal";
  = "https://frank-video-test.s3.us-east-2.amazonaws.com/other/IMG_3120.png";
  = "Latest Software  Update!!! 2222";
  = 1;
 */

@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *externalUrl;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *internalUrl;
@property (nonatomic,strong)NSString *pic;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *type;

@end

NS_ASSUME_NONNULL_END
