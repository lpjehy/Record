//
//  HelpView.h
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIView

+ (HelpView *)getInstance;

+ (void)firstShow;

@property(nonatomic, assign) BOOL show;

@end
