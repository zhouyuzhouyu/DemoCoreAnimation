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
//    self.view = [[BezierPathView alloc] init];
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    
    UIImage *image = [UIImage imageNamed:@"caLogo.png"];
    self.layer = [CALayer layer];
    self.layer.contents = (id)image.CGImage;
    self.layer.bounds = CGRectMake(0, 0, 60, 60);
    self.layer.position = CGPointZero;
    [self.view.layer addSublayer:self.layer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
