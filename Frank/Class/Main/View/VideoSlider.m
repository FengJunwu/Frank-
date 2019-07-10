//
//  VideoSlider.m
//  Frank
//
//  Created by fengjunwu on 2019/6/29.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VideoSlider.h"

@implementation VideoSlider

-(void)setPlayableProgress:(CGFloat)playableProgress{
    if (_playableProgress != playableProgress){
        _playableProgress = playableProgress;
        [self setNeedsDisplay];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

-(void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [[[UIColor whiteColor] colorWithAlphaComponent:0.7] set];
    
    CGRect r = [self trackRectForBounds:self.bounds];
    r = CGRectInset(r, 0, 0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:r.size.height/2.0];
    CGContextAddPath(c, bezierPath.CGPath);
    CGContextSetLineWidth(c, 0);
    CGContextStrokePath(c);
    CGContextAddPath(c, bezierPath.CGPath);
    CGContextClip(c);
    CGContextFillRect(c, CGRectMake(r.origin.x, r.origin.y, r.size.width * _playableProgress, r.size.height));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
