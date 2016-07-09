//
//  RateView.m
//  Reminder
//
//  Created by Jehy Fan on 16/6/7.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "FeedBackView.h"

#import <MessageUI/MFMailComposeViewController.h>

typedef NS_ENUM(NSInteger, FeedBackStage) {
    FeedBackStageStart,//默认从0开始
    FeedBackStageEmail,
    FeedBackStageRate,
    FeedBackStageDone
};



static NSString *FeedBackStageKey = @"FeedBackStage";


@interface FeedBackView () <MFMailComposeViewControllerDelegate> {
    UILabel *textLabel;
    UIImageView *emojiImageView;
    
    UIButton *yesButton;
    UIImageView *yesImageView;
    
    UIButton *noButton;
    UIImageView *noImageView;
    
    FeedBackStage stage;
    
    BOOL isShowed;
}

@end

@implementation FeedBackView

+ (FeedBackView *)getInstance {
    FeedBackStage stage = [FeedBackView stage];
    if (stage != FeedBackStageStart) {
        return nil;
    }
    
    
    static FeedBackView *instance = nil;
    if (instance == nil) {
        instance = [[FeedBackView alloc] init];
    }
    
    return instance;
}

+ (BOOL)shouldShow {
    
    NSInteger count = [ActionManager countForAction:Action_APP_Init];
    NSInteger r = count % 5;
    NSInteger q = count / 5;
    if (r == 0 && q >= 1) {
        return YES;
    }
    
    return NO;
}

+ (void)setStage:(NSInteger)stage {
    [[NSUserDefaults standardUserDefaults] setInteger:stage forKey:FeedBackStageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)stage {
    //return FeedBackStageStart;
    return [[NSUserDefaults standardUserDefaults] integerForKey:FeedBackStageKey];
}

- (void)initView {
    self.frame = CGRectMake(ScreenWidth - 192, -114, 192, 114);
    
    
    
    self.userInteractionEnabled = YES;
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake(32, 0, 127, 114);
    backImageView.image = [UIImage imageNamed:@"review_bg.png"];
    
    [self addSubview:backImageView];
    
    
    
    emojiImageView = [[UIImageView alloc] init];
    emojiImageView.frame = CGRectMake(backImageView.width - 12.5, 32, 25, 25);
    
    
    [backImageView addSubview:emojiImageView];
    
    
    
    
    
    textLabel = [[UILabel alloc] init];
    
    textLabel.frame = CGRectMake(10, 48, 108, 32);
    textLabel.textColor = ColorTextDark;
    textLabel.font = FontSmall;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.minimumScaleFactor = 0.7;
    textLabel.numberOfLines = 2;
    
    [backImageView addSubview:textLabel];
    
    
    noImageView = [[UIImageView alloc] init];
    
    noImageView.frame = CGRectMake(8, 92, 32, 35);
    noImageView.image = [UIImage imageNamed:@"review_no.png"];
    
    [backImageView addSubview:noImageView];
    
    
    noButton = [[UIButton alloc] init];
    
    [noButton addTarget:self action:@selector(noButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //noButton.layer.borderWidth = 1;
    //noButton.layer.borderColor = [UIColor blueColor].CGColor;
    noButton.frame = CGRectMake(0, 32, 96, 96);
    [self addSubview:noButton];
    
    
    yesImageView = [[UIImageView alloc] init];
    
    yesImageView.frame = CGRectMake(86, 92, 32, 35);
    yesImageView.image = [UIImage imageNamed:@"review_yes.png"];
    
    [backImageView addSubview:yesImageView];
    
    
    yesButton = [[UIButton alloc] init];
    
    [yesButton addTarget:self action:@selector(yesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //yesButton.layer.borderWidth = 1;
    //yesButton.layer.borderColor = [UIColor redColor].CGColor;
    yesButton.frame = CGRectMake(96, 32, 96, 96);
    [self addSubview:yesButton];
    
    
}

- (id)init {
    self = [super init];
    if (self) {
        
        
        [self initView];
    }
    
    
    return self;
}

/**
 *  点击no
 */
- (void)noButtonPressed {
    
    
    
    if (stage == FeedBackStageStart) {
        
        char name[100] = {0};
        strcat(name, __FUNCTION__);
        strcat(name, "_start");
        
        
        [AnalyticsUtil buttonClicked:name];
        
        stage = FeedBackStageEmail;
        [FeedBackView setStage:stage];
        
        //进入反馈询问
        [UIView animateWithDuration:0.36
                         animations:^{
                             noImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             
                             textLabel.alpha = 0;
                             yesImageView.alpha = 0;
                         }
                         completion:^(BOOL finish){
                             
                             textLabel.text = LocalizedString(@"feedback_feedbacks");
                             emojiImageView.image = [UIImage imageNamed:@"emoji-sad.png"];
                             
                             [UIView animateWithDuration:.36
                                              animations:^{
                                                  noImageView.alpha = 0;
                                                  
                                                  textLabel.alpha = 1;
                                                  emojiImageView.alpha = 1;
                                              } completion:^(BOOL finished) {
                                                  
                                                  noImageView.transform = CGAffineTransformMakeScale(1, 1);
                                                  
                                                  
                                                  
                                                  [UIView animateWithDuration:0.36
                                                                   animations:^{
                                                                       
                                                                       noImageView.alpha = 1;
                                                                       yesImageView.alpha = 1;
                                                                       
                                                                   }];
                                              }];
                         }];
    } else {
        
        char name[100] = {0};
        strcat(name, __FUNCTION__);
        strcat(name, "_done");
        
        
        [AnalyticsUtil buttonClicked:name];
        
        [FeedBackView setStage:FeedBackStageDone];
        
        [UIView animateWithDuration:.36
                         animations:^{
                             noImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             
                             yesImageView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self hide];
                         }];
        
    }
    
}

- (void)yesButtonPressed {
    
    if (stage == FeedBackStageStart) {
        
        char name[100] = {0};
        strcat(name, __FUNCTION__);
        strcat(name, "_start");
        
        
        [AnalyticsUtil buttonClicked:name];
        
        
        stage = FeedBackStageRate;
        [FeedBackView setStage:stage];
        
        //进入反馈询问
        [UIView animateWithDuration:0.36
                         animations:^{
                             yesImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             
                             noImageView.alpha = 0;
                             textLabel.alpha = 0;
                         }
                         completion:^(BOOL finish){
                             
                             textLabel.text = LocalizedString(@"feedback_rate");
                             emojiImageView.image = [UIImage imageNamed:@"emoji-happy.png"];
                             
                             [UIView animateWithDuration:0.36
                                              animations:^{
                                                  yesImageView.alpha = 0;
                                                  
                                                  textLabel.alpha = 1;
                                                  emojiImageView.alpha = 1;
                                              }
                                              completion:^(BOOL finish){
                                                  
                                                  
                                                  
                                                  yesImageView.transform = CGAffineTransformMakeScale(1, 1);
                                                  
                                                  
                                                  
                                                  [UIView animateWithDuration:0.24
                                                                   animations:^{
                                                                       
                                                                       noImageView.alpha = 1;
                                                                       yesImageView.alpha = 1;
                                                                   }];
                                              }];
                         }];
        
    } else {
        [FeedBackView setStage:FeedBackStageDone];
        
        if (stage == FeedBackStageEmail) {
            char name[100] = {0};
            strcat(name, __FUNCTION__);
            strcat(name, "_email");
            
            
            [AnalyticsUtil buttonClicked:name];
        } else {
            char name[100] = {0};
            strcat(name, __FUNCTION__);
            strcat(name, "_rate");
            
            
            [AnalyticsUtil buttonClicked:name];
        }
        
        [UIView animateWithDuration:.36
                         animations:^{
                             
                             yesImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             
                             noImageView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self hide];
                             
                             if (stage == FeedBackStageEmail) {
                                 //发送邮件
                                 
                                 
                                 [self displayMailPicker];
                                 
                                 
                             } else if (stage == FeedBackStageRate) {
                                 // 点评
                                 
                                 
                                 [NSURL openUrl:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1108865988&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
                                 
                                 
                             }
                         }];
    }
}


- (void)showInView:(UIView *)view {
    
    if (isShowed == YES || view == nil) {
        return;
    }
    
    isShowed = YES;
    
    [view addSubview:self];
    
    
    
    stage = [FeedBackView stage];
    
    if (stage == FeedBackStageStart) {
        textLabel.text = LocalizedString(@"feedback_enjoy");
        emojiImageView.alpha = 0;
        
    } else if (stage == FeedBackStageEmail) {
        textLabel.text = LocalizedString(@"feedback_feedbacks");
        emojiImageView.image = [UIImage imageNamed:@"emoji-sad.png"];
        
    } else if (stage == FeedBackStageRate) {
        textLabel.text = LocalizedString(@"feedback_rate");
        emojiImageView.image = [UIImage imageNamed:@"emoji-happy.png"];
    }
    
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            self.originY = 0;
                            
                        } completion:^(BOOL finished) {
                            
                        }];
    
}

- (void)hide {
    if (isShowed == NO) {
        return;
    }
    
    [UIView animateWithDuration:0.36 animations:^{
        self.originY = -self.height - 32;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 在应用内发送邮件


//调出邮件发送窗口
- (void)displayMailPicker
{
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [dic objectForKey:@"CFBundleVersion"];
    NSString *emailBody = [NSString stringWithFormat:@"%@-%@-%@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], version];
    if (![MFMailComposeViewController canSendMail]) {
        [NSURL openUrl:[@"mailto:AveryReminder@gmail.com?subject=Feedback&body=" stringByAppendingString:emailBody]];
        return;
    }
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject:@"Feedback"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:@"AveryReminder@gmail.com"];
    [mailPicker setToRecipients: toRecipients];
    
    emailBody = [@"<br/><br/><br/>" stringByAppendingString:emailBody];
    
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [KeyWindow.rootViewController presentViewController:mailPicker
                                               animated:YES completion:^{
                                                   
                                               }];
    
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    NSLog(@"msg %@", msg);
}

@end
