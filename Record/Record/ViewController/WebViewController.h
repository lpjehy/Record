//
//  WebViewController.h
//  eCook
//
//  Created by Jehy Fan on 12-7-16.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface WebViewController : BaseViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    UIWebView *baseWebView;
    
    
    NSString *baseUrl;
    NSString *baseTitle;
    
    NSString *currentUrl;
        
    NSString *cookID;
    NSString *weiboID;
    
    
    UILabel *titleLabel;
    
    BOOL didShowding;
    BOOL shouldStartLoad;
}

@property(nonatomic, copy) NSString *baseUrl;//传入的原始url
@property(nonatomic, copy) NSString *baseTitle;//传入的初始title

@property(strong, nonatomic) UIButton * shareBtn;

@property(nonatomic, copy) NSString *htmlString;//传入的初始title

@end
