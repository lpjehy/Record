//
//  TextEditViewController.h
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "BaseViewController.h"

@protocol TextEditViewDelegate<NSObject>
@optional

// Display customization

- (void)textEditViewTextChanged:(NSString *)text;
@end;

@interface TextEditViewController : BaseViewController

@property(nonatomic, strong) NSString *text;

@property(nonatomic, weak) id<TextEditViewDelegate> delegate;

@end
