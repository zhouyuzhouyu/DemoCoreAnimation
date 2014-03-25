//
//  AnchorPointLayer.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

#import "AnchorPointLayer.h"

@implementation AnchorPointLayer
#pragma mark - Object Life Cycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setBounds:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        [self setNeedsDisplay];
    }
    return self;
}

#pragma mark - Layer Drawing

- (void)drawInContext:(CGContextRef)context
{
    [self setContentsScale:[[UIScreen mainScreen] scale]];
    
    CGRect bounds = [self bounds];
    CGPoint center = {CGRectGetMidX(bounds), CGRectGetMidY(bounds)};
    
    CGFloat strokeWidth = 2.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, bounds.size.width / 2 - strokeWidth, 0.0, (CGFloat)(M_PI * 2.0), 0);
    
    
    CGContextSetFillColorWithColor(context, [[[UIColor redColor] colorWithAlphaComponent:0.5] CGColor]);
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] CGColor]);
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CFRelease(path);
}

@end
#pragma mark - Anchor Point Function

CGPoint CalculateAnchorPointPositionForLayer(CALayer *superLayer) {
    CGRect superLayerBounds = [superLayer bounds];
    CGPoint anchorPoint = [superLayer anchorPoint];
    return CGPointMake(superLayerBounds.size.width * anchorPoint.x, superLayerBounds.size.height * anchorPoint.y);
}
