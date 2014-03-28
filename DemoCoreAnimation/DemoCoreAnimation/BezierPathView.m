//
//  BezierPathView.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

// Simple layer that draws a control point.
@interface ControlPointLayer : CALayer
@end

// Simple layer that draws a control point.
@interface EndPointLayer : CALayer
@end

@interface ShiZiLayer : CALayer
@property (nonatomic, assign) CGPoint pointCenter;

- (void)setXPoint:(CGPoint)point;

@end

#import "BezierPathView.h"

@interface BezierPathView ()
@property (nonatomic, strong) CALayer *beginPointLayer;
@property (nonatomic, strong) CALayer *endPointLayer;
@property (nonatomic, strong) CALayer *beginPointControlPointLayer;
@property (nonatomic, strong) CALayer *endPointControlPointLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) ShiZiLayer *shiziLayer;
@property (nonatomic, assign) CGPoint xpoint;

@property (nonatomic, strong) NSArray *arrHitTestLayer;
//@property (nonatomic, strong) NSMutableDictionary *dicTouchesToLayer;
@property (nonatomic) CFMutableDictionaryRef dicTouchesToLayer;

CGPathRef PathCreateForCurrentControlPointPositions(CALayer *beginPointLayer, CALayer *endPointLayer, CALayer *beginPointControlPointLayer, CALayer *endPointControlPointLayer);

@end

@implementation BezierPathView
- (void)dealloc
{
    if (self.dicTouchesToLayer) {
        CFRelease(self.dicTouchesToLayer);
    }
}


static NSString *kCubicBezierPathLocationOffset = @"kCubicBezierPathLocationOffset";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initLayers];
        self.arrHitTestLayer = @[self.beginPointControlPointLayer,self.endPointControlPointLayer,self.beginPointLayer,self.endPointLayer];
        self.dicTouchesToLayer = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
        
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}

- (void)initLayers
{
    CGFloat midX = CGRectGetMidX([self bounds]);
    CGFloat midY = CGRectGetMidY([self bounds]);
//    NSLog(@"--%f,%f",midX,midY);
    self.beginPointLayer = [EndPointLayer layer];
    [self.beginPointLayer setPosition:CGPointMake(midX, 80)];
    
    self.endPointLayer = [EndPointLayer layer];
    [self.endPointLayer setPosition:CGPointMake(midX, CGRectGetMaxY([self bounds])-40)];
    
    self.beginPointControlPointLayer = [ControlPointLayer layer];
    [self.beginPointControlPointLayer setPosition:CGPointMake(40.0, midY)];
    
    self.endPointControlPointLayer = [ControlPointLayer layer];
    [self.endPointControlPointLayer setPosition:CGPointMake([self bounds].size.width - 40.0, midY)];
    
    CGPathRef path = PathCreateForCurrentControlPointPositions(_beginPointLayer, _endPointLayer, _beginPointControlPointLayer, _endPointControlPointLayer);
    self.shapeLayer = [CAShapeLayer layer];
    [self.shapeLayer setPath:path];
    [self.shapeLayer setFillRule:kCAFillRuleEvenOdd];
    [self.shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [self.shapeLayer setLineWidth:2.0];
    CGPathRelease(path);
    
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.beginPointLayer];
    [self.layer addSublayer:self.endPointLayer];
    [self.layer addSublayer:self.beginPointControlPointLayer];
    [self.layer addSublayer:self.endPointControlPointLayer];
    
    self.shiziLayer = [ShiZiLayer layer];
    [self.shiziLayer setBounds:self.bounds];
    [self.shiziLayer setPosition:self.layer.position];
    [self.layer addSublayer:self.shiziLayer];
}

#pragma mark - Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLoactionInView = [touch locationInView:self];
        
        [self.shiziLayer setXPoint:touchLoactionInView];
        [self setTouchPoint:touchLoactionInView];
        
        for (CALayer *layer in self.arrHitTestLayer) {
            CGRect rectLayer = [layer convertRect:[layer bounds] toLayer:self.layer];
            
            CGRect hitRectLayer = CGRectInset(rectLayer, -20, -20);
            if (CGRectContainsPoint(hitRectLayer, touchLoactionInView)) {
                CFDictionarySetValue(self.dicTouchesToLayer, (__bridge CFTypeRef)touch, (__bridge CFTypeRef)layer);
                
                CGPoint offsetFromCenter = CGPointMake([layer position].x - touchLoactionInView.x, [layer position].y - touchLoactionInView.y);
                  [layer setValue:[NSValue valueWithCGPoint:offsetFromCenter] forKey:kCubicBezierPathLocationOffset];
                break;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint pointLocationInView = [touch locationInView:self];
         [self.shiziLayer setXPoint:pointLocationInView];
        [self setTouchPoint:pointLocationInView];
    }
    
    if (CFDictionaryGetCount(self.dicTouchesToLayer) == 0) {
        return;
    }
    
    // Turn off implicit actions for the rest of the current run loop.
    // - we do this so that the layer is not implicitly animated when changing the position.
#if 0
    [CATransaction setDisableActions:YES];
    
    CGRect bounds = [self bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    for (UITouch *currentTouch in touches) {
        CALayer *layerToMove = (__bridge CALayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)currentTouch);
        CGPoint locationInView = [currentTouch locationInView:self];
        
        CGPoint offsetFromCenter = [(NSValue *)[layerToMove valueForKey:kBTSCubicBezierPathLocationOffset] CGPointValue];
        CGFloat x = MAX(0.0, locationInView.x + offsetFromCenter.x);
        x = MIN(width, x);
        
        CGFloat y = MAX(80.0, locationInView.y + offsetFromCenter.y);
        y = MIN(height, y);
        CGPoint newPosition = CGPointMake(x, y);
        
        [layerToMove setPosition:newPosition];
    }
#endif
    
    [CATransaction setDisableActions:YES];
    
    CGRect bounds = [self bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    for (UITouch *touch in touches) {
        CGPoint pointLocationInView = [touch locationInView:self];
        
        
        CALayer *layerToMove = CFDictionaryGetValue(self.dicTouchesToLayer, (__bridge CFTypeRef)touch);
        
        CGPoint offsetFromCenter = [[layerToMove valueForKey:kCubicBezierPathLocationOffset] CGPointValue];
        
        CGFloat x = MAX(0.0, pointLocationInView.x + offsetFromCenter.x);
        x = MIN(width, x);
        
        CGFloat y = MAX(80.0, pointLocationInView.y + offsetFromCenter.y);
        y = MIN(height, y);
        
        [layerToMove setPosition:CGPointMake(x, y)];
    }
    
    CGPathRef path = PathCreateForCurrentControlPointPositions(self.beginPointLayer, self.endPointLayer, self.beginPointControlPointLayer, self.endPointControlPointLayer);
    [self.shapeLayer setPath:path];
    CFRelease(path);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.shiziLayer setXPoint:CGPointZero];
    [self setTouchPoint:CGPointZero];
    if (CFDictionaryGetCount(self.dicTouchesToLayer) == 0) {
        return;
    }
    for (UITouch *currentTouch in touches) {
        CALayer *layer = (__bridge CALayer *)CFDictionaryGetValue(self.dicTouchesToLayer, (__bridge CFTypeRef)currentTouch);
        [layer setValue:nil forKey:kCubicBezierPathLocationOffset];
        CFDictionaryRemoveValue(self.dicTouchesToLayer, (__bridge CFTypeRef)currentTouch);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (CGPathRef)bezierPath
{
    return [self.shapeLayer path];
}

- (void)setTouchPoint:(CGPoint)point
{
    if (CGRectContainsPoint([self bounds], point)) {
        self.xpoint = point;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.xpoint.x, self.xpoint.y);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.xpoint.x, self.xpoint.y);
    CGContextStrokePath(context);
}

// ownership is transferred to the caller
CGPathRef PathCreateForCurrentControlPointPositions(CALayer *beginPointLayer, CALayer *endPointLayer, CALayer *beginPointControlPointLayer, CALayer *endPointControlPointLayer) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, [beginPointLayer position].x, [beginPointLayer position].y);
    CGPathAddCurveToPoint(path, NULL, [beginPointControlPointLayer position].x, [beginPointControlPointLayer position].y, [endPointControlPointLayer position].x, [endPointControlPointLayer position].y, [endPointLayer position].x, [endPointLayer position].y);
    return path;
}
@end



#pragma mark - Private CALayers

// TODO: merge the layers and parameterize the color and size.

@implementation ControlPointLayer

- (id)init
{
    self = [super init];
    if (self) {
        [self setBounds:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        [self setContentsScale:[[UIScreen mainScreen] scale]];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];
    
    CGContextSetFillColorWithColor(context, [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]);
    
    CGFloat centerX = CGRectGetMidX([self bounds]);
    CGFloat centerY = CGRectGetMidY([self bounds]);
    CGFloat radius = MIN(CGRectGetWidth([self bounds]) / 2.0, CGRectGetHeight([self bounds]) / 2.0) - 2.0;
    
    CGContextAddArc(context, centerX, centerY, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextAddArc(context, centerX, centerY, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
}

@end

@implementation EndPointLayer

- (id)init
{
    self = [super init];
    if (self) {
        [self setBounds:CGRectMake(0.0, 0.0, 30.0, 20.0)];
        [self setContentsScale:[[UIScreen mainScreen] scale]];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];
    
    CGContextSetFillColorWithColor(context, [[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor]);
    
    CGFloat centerX = CGRectGetMidX([self bounds]);
    CGFloat centerY = CGRectGetMidY([self bounds]);
    CGFloat radius = MIN(CGRectGetWidth([self bounds]) / 2.0, CGRectGetHeight([self bounds]) / 2.0) - 2.0;
    
    CGContextAddArc(context, centerX, centerY, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextAddArc(context, centerX, centerY, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
}



@end
@implementation ShiZiLayer
- (id)init
{
    self = [super init];
    if (self) {
        [self setBounds:CGRectMake(0.0, 0.0, 30.0, 20.0)];
        [self setContentsScale:[[UIScreen mainScreen] scale]];
        self.pointCenter = CGPointZero;
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];
    
    if (!CGPointEqualToPoint(self.pointCenter, CGPointZero)) {
        CGContextSetFillColorWithColor(context, [[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor]);
        
//        CGFloat centerX = CGRectGetMidX([self bounds]);
//        CGFloat centerY = CGRectGetMidY([self bounds]);
        CGFloat radius = 20 - 2.0;
        
        CGContextAddArc(context, self.pointCenter.x, self.pointCenter.y, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
        CGContextFillPath(context);
        
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextAddArc(context, self.pointCenter.x, self.pointCenter.y, radius, 0.0, (CGFloat)(M_PI * 2.0), 0);
        CGContextSetLineWidth(context, 2.0);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, 0, self.pointCenter.y);
        CGContextAddLineToPoint(context, CGRectGetMaxX([self bounds]), self.pointCenter.y);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, self.pointCenter.x, 0);
        CGContextAddLineToPoint(context, self.pointCenter.x, CGRectGetMaxY([self bounds]));
        CGContextStrokePath(context);
        
    }
    
}

- (void)setXPoint:(CGPoint)point
{
    if (CGRectContainsPoint([self bounds], point)) {
        self.pointCenter = point;
        [self setNeedsDisplay];
    }
}



@end
