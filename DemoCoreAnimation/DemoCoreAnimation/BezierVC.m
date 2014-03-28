//
//  BezierVC.m
//  DemoCoreAnimation
//
//  Created by Allen1 on 14-3-24.
//  Copyright (c) 2014年 zhouyu. All rights reserved.
//

#import "BezierVC.h"
#import "BezierPathView.h"

@interface BezierVC ()
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) BezierPathView *bezierPathView;
@end

@implementation BezierVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    {
        self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnRight setBounds:CGRectMake(0, 0, 100, 40)];
        [self.btnRight setTitle:@"animate" forState:UIControlStateNormal];
        [self.btnRight setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btnRight setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.btnRight.layer.borderWidth = 1;
        self.btnRight.layer.borderColor = [UIColor blackColor].CGColor;
        self.btnRight.layer.cornerRadius = 5;
        [self.btnRight addTarget:self action:@selector(toggleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    }
    
    
    self.bezierPathView = [[BezierPathView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bezierPathView];
    
    UIImage *image = [UIImage imageNamed:@"caLogo.png"];
    self.layer = [CALayer layer];
    self.layer.contents = (id)image.CGImage;
    self.layer.bounds = CGRectMake(0, 0, image.size.width/4.0f, image.size.height/4.0f);
    self.layer.position = CGPointMake(200, 200);
//    [self.view.layer addSublayer:self.layer];
    
}


- (void)toggleBtnPressed:(id)sender
{
    if ([self.btnRight.titleLabel.text isEqualToString:@"stop"]) {
        [self.btnRight setTitle:@"animate" forState:UIControlStateNormal];
        
        [CATransaction setCompletionBlock:^{
            [_layer removeAllAnimations];
            [_layer removeFromSuperlayer];
        }];
        [_layer setOpacity:0.0];
    }
    else
    {
        [self.btnRight setTitle:@"stop" forState:UIControlStateNormal];
        
        [[self.bezierPathView layer] addSublayer:self.layer];
        [self.layer setOpacity:1.0];
        
        [self updateAnimationForPath:[self.bezierPathView bezierPath]];
    }
    
}
- (void)updateAnimationForPath:(CGPathRef)path
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:MAXFLOAT];
    [animation setDuration:5.0];
    [animation setDelegate:self];
    [animation setCalculationMode:kCAAnimationPaced];
    
    [_layer addAnimation:animation forKey:@"bezierPathAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
