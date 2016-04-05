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

- (void)showCancel {
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(0, 0, 64, 44);
    [rightButton setTitle:@"Cancel" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBack {
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:NSLocalizedString(@"button_title_back", nil) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)setNavigationBarTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
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
