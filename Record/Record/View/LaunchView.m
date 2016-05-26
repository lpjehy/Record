//
//  LaunchView.m
//  Record
//
//  Created by Jehy Fan on 16/4/29.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LaunchView.h"

@implementation LaunchView

- (id)init {
    self = [super init];
    if (self) {
        NSString *imageName = nil;
        
        if (ScreenHeight == ScreenHeight480) {
            imageName = @"Default.png";
        } else if (ScreenHeight == ScreenHeight568) {
            imageName = @"Default-568h.png";
        } else if (ScreenHeight == ScreenHeight667) {
            imageName = @"Default-375w-667h.png";
        } else if (ScreenHeight == ScreenHeight736) {
            imageName = @"Default-414w-736h.png";
        } else {
            imageName = @"Default-Portrait~ipad.png";
        }
        
        self.image = [UIImage imageNamed:imageName];
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1];
    }
    
    
    return self;
}

+ (void)show {
    LaunchView *view = [[LaunchView alloc] init];
    
    [KeyWindow addSubview:view];
}


- (void)hide {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewDidHide)];
    
    self.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)viewDidHide {
    [self removeFromSuperview];
}


@end
