/*********************************************************/
/*                                                       *
 *                                                       *
 *   Follow your heart, but take your brain with you.    *
 *                                                       *
 *                                                       *
 *********************************************************/
//
//  TTSViewModel.h
//  CarTown
//
//  Created by 冯俊武 on 2018/8/7.
//  Copyright © 2018年 冯俊武. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^startSpeachBlock)(void);
typedef void(^stopSpeachBlock)(void);

@interface TTSViewModel : NSObject

@property (nonatomic,copy)startSpeachBlock startSpeachBlock;
@property (nonatomic,copy)stopSpeachBlock stopSpeachBlock;

-(void)startSpeach:(NSString *)speach language:(NSString *)language;

@end
