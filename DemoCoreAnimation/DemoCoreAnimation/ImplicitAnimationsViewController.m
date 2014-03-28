//
//  ImplicitAnimationsViewController.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

#import "ImplicitAnimationsViewController.h"
#import "AnchorPointLayer.h"

@interface ImplicitAnimationsViewController ()
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, assign) BOOL disableAction;
@property (nonatomic, assign) float animationDuration;
@end

@implementation ImplicitAnimationsViewController

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
    
    self.disableAction = NO;
    self.animationDuration = 1.0f;
    
    self.layer = [CALayer layer];
    self.layer.bounds  = CGRectMake(0, 0, 200, 200);
    self.layer.position = CGPointMake(160, 150);
    self.layer.backgroundColor = [[UIColor redColor] CGColor];
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view.layer addSublayer:self.layer];
    
    AnchorPointLayer *anchorPointLayer = [[AnchorPointLayer alloc] init];
    [anchorPointLayer setPosition:CalculateAnchorPointPositionForLayer(self.layer)];
    [self.layer addSublayer:anchorPointLayer];
    
    NSArray *arrTitle = @[@"bounds",@"corner",@"corlor",@"opacity",@"position",@"border"];
    for (int i = 0;i<[arrTitle count];i++) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(30+90*(i%3), 300+(i/3)*50, 80, 40)];
        [btn1 setTitle:arrTitle[i] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn1.tag = i;
        btn1.layer.borderWidth = 1;
        btn1.layer.borderColor = [UIColor blackColor].CGColor;
        
        btn1.layer.cornerRadius = 5;
        [btn1 addTarget:self action:@selector(toggleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
    }
}

- (void)toggleBtnPressed:(id)sender
{
    UIButton *btn = sender;
    int tag = (int)btn.tag;
    
    __weak ImplicitAnimationsViewController *weakSelf = self;
    [CATransaction setDisableActions:self.disableAction];
    [CATransaction setAnimationDuration:self.animationDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{
        [weakSelf AnimationcompleteWithTag:tag];
    }];
    
    switch (tag) {
        case 0:
        {
            CGRect rcBounds = self.layer.bounds;
            if (rcBounds.size.width == 200) {
                rcBounds.size.width = 300;
                rcBounds.size.height = 300;
            }else
            {
                rcBounds.size.width = 200;
                rcBounds.size.height = 200;
            }
            self.layer.bounds = rcBounds;
            AnchorPointLayer *anchorPointLayer = [[_layer sublayers] objectAtIndex:0];
            [anchorPointLayer setPosition:CalculateAnchorPointPositionForLayer(self.layer)];
        }
            break;
        case 1:
        {
            self.layer.cornerRadius = (self.layer.cornerRadius == 0.0f) ? 100.0f : 0.0f;
        }
            break;
        case 2:
        {
            CGColorRef redColor = [UIColor redColor].CGColor, blueColor = [UIColor blueColor].CGColor;
            self.layer.backgroundColor = (self.layer.backgroundColor == redColor) ? blueColor : redColor;
        }
            break;
        case 3:
        {
            self.layer.opacity = (self.layer.opacity == 0.10f) ? 1.0f : 0.10f;
        }
            break;
        case 4:
        {
            self.layer.position = (self.layer.position.x == 160)?CGPointMake(210, 200):CGPointMake(160, 150);
        }
            break;
        case 5:
        {
            self.layer.borderWidth = (self.layer.borderWidth == 0)?10:0;
        }
            break;
            
        default:
            break;
    }
}

- (void)AnimationcompleteWithTag:(int)tag
{
    NSLog(@"%d complete",tag);
}

@end
