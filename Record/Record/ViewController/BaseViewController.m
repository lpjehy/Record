//
//  BaseViewController.m
//  Imager
//
//  Created by Jehy Fan on 16/2/27.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "AnalyticsUtil.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBarTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, 128, 44);
    
    self.navigationItem.titleView = titleLabel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorBaseBackground;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSString *view = [[[self class] description] stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
    [AnalyticsUtil viewAppear:view];
    
    
    
    //isShowing = YES;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //didAppear = YES;
    //viewController = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    NSString *view = [[[self class] description] stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
    
    [AnalyticsUtil viewDisAppear:view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    //isShowing = NO;
    //didAppear = NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
