//
//  TextEditViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController () {
    UITextView *mainTextView;
}

@end

@implementation TextEditViewController

@synthesize text;

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        //键盘高度监听
        [NotificationCenter addObserver:self
                                                 selector:@selector(keyboardWillAppear:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
    }
    
    
    return self;
}

- (void)dealloc {
    
    [NotificationCenter removeObserver:self];
    
}

#pragma mark - keyBoardObser
-(void)keyboardWillAppear:(NSNotification *)notification {
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        
        
        [UIView animateWithDuration:0.64 animations:^{
            mainTextView.height = ScreenHeight - 64 - curkeyBoardHeight;
            [self.view layoutIfNeeded];
            
        }];
    }
}

- (void)save {
    [mainTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([delegate respondsToSelector:@selector(textEditViewTextChanged:)]) {
        [delegate textEditViewTextChanged:mainTextView.text];
    }
}

- (void)createLayout {
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, 64, 44);
    [leftButton setTitle:LocalizedString(@"button_title_cancel") forState:UIControlStateNormal];
    leftButton.titleLabel.font = FontMiddle;
    [leftButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(0, 0, 64, 44);
    [rightButton setTitle:LocalizedString(@"button_title_save") forState:UIControlStateNormal];
    rightButton.titleLabel.font = FontMiddle;
    [rightButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    mainTextView = [[UITextView alloc] init];
    mainTextView.text = text;
    mainTextView.frame = CGRectMake(0, 0, ScreenWidth, 320);
    [self.view addSubview:mainTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLayout];
    
    [mainTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
