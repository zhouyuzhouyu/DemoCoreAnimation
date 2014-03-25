//
//  BitItVC.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

#import "BitItVC.h"

@interface BitItVC ()
@property (nonatomic, strong) CALayer *layer;
@end

@implementation BitItVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    UIImage *image = [UIImage imageNamed:@"heart.png"];
    
    self.layer = [CALayer layer];
    self.layer.contents = (id)image.CGImage;
    self.layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    self.layer.position = CGPointMake(160, 200);
    [self.layer setValue:@(0.8f) forKeyPath:@"transform.scale"];
    [self.view.layer addSublayer:self.layer];
    
#if 0
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.toValue = @0.3f;
	animation.fromValue = @(self.layer.opacity);
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
	animation.duration = 1.0;
	self.layer.opacity = 0.0; // This is required to update the model's value.  Comment out to see what happens.
	[self.layer addAnimation:animation forKey:@"animateOpacity"];

    CABasicAnimation *animationS = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	animationS.toValue = @(1.0f);
	animationS.fromValue = [self.layer valueForKeyPath:@"transform.scale"];
    animationS.repeatCount = HUGE_VALF;
    animationS.autoreverses = YES;
	animationS.duration = 1.0;
	self.layer.opacity = 0.0; // This is required to update the model's value.  Comment out to see what happens.
	[self.layer addAnimation:animationS forKey:@"animateTransformScale"];
#else
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.toValue = @0.3f;
	animation.fromValue = @(self.layer.opacity);
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
	animation.duration = 1.0;
    
    CABasicAnimation *animationS = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	animationS.toValue = @(1.0f);
	animationS.fromValue = [self.layer valueForKeyPath:@"transform.scale"];
    animationS.repeatCount = HUGE_VALF;
    animationS.autoreverses = YES;
	animationS.duration = 1.0;
    
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 2.0f;
	animationGroup.autoreverses = YES;
	animationGroup.repeatCount = HUGE_VALF;
	[animationGroup setAnimations:@[animation, animationS]];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
	[self.layer addAnimation:animationGroup forKey:@"animationGroup"];
#endif
}
@end
