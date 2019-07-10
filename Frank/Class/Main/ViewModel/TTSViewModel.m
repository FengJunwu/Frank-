/*********************************************************/
/*                                                       *
 *                                                       *
 *   Follow your heart, but take your brain with you.    *
 *                                                       *
 *                                                       *
 *********************************************************/
//
//  TTSViewModel.m
//  CarTown
//
//  Created by 冯俊武 on 2018/8/7.
//  Copyright © 2018年 冯俊武. All rights reserved.
//

#import "TTSViewModel.h"

#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVSpeechSynthesis.h>

@interface TTSViewModel() <AVSpeechSynthesizerDelegate>

@property (nonatomic,strong)AVSpeechSynthesizer *AVSpeech;

@property (nonatomic,strong)AVSpeechUtterance *utterance;

@end

@implementation TTSViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.AVSpeech = [[AVSpeechSynthesizer alloc] init];
        self.AVSpeech.delegate = self;
    }
    return self;
}


-(void)startSpeach:(NSString *)speach language:(NSString *)language{
    
    self.utterance = [[AVSpeechUtterance alloc] initWithString:speach];
//    self.utterance.rate = 0.5;//语速
    
//    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
//    self.utterance.voice = voice;
    self.utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    self.utterance.rate = 0.5;
    self.utterance.pitchMultiplier = 0.8;
    self.utterance.postUtteranceDelay = 0.1;
    [self.AVSpeech speakUtterance:self.utterance];
}



- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
    if (self.startSpeachBlock) {
        self.startSpeachBlock();
    }
    
}



- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    if (self.stopSpeachBlock) {
        self.stopSpeachBlock();
        self.utterance = nil;
    }
    
}



- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    if (self.stopSpeachBlock) {
        self.stopSpeachBlock();
        self.utterance = nil;
    }
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    if (self.startSpeachBlock) {
        self.startSpeachBlock();
    }
    
}



- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    if (self.stopSpeachBlock) {
        self.stopSpeachBlock();
        self.utterance = nil;
    }
    
}



@end
