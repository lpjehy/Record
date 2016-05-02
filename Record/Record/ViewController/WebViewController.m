//
//  WebViewController.m
//  eCook
//
//  Created by Jehy Fan on 12-7-16.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import "WebViewController.h"




@interface WebViewController () {
    NSString *mineUrl;
    UIButton *leftButton;
    UIButton *closeButton;
    BOOL isShowCloseButton;
}

@property(nonatomic, copy) NSString *loadingUrl;//实际加载的url

@property(nonatomic, copy) NSString *currentUrl;

@property(nonatomic, copy) NSString *cookID;
@property(nonatomic, copy) NSString *weiboID;

@end

@implementation WebViewController

@synthesize baseTitle, baseUrl, loadingUrl, currentUrl, cookID, weiboID, htmlString;

- (void)setBaseUrl:(NSString *)url
{
    if (baseUrl) {
       
        baseUrl = nil;
    }
    
    baseUrl = [url copy];

    
    
    
    self.loadingUrl = url;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}




#pragma mark - Function

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loadingUrl]];
    [baseWebView loadRequest:request];
}


- (NSString *)showUserAgent {
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return userAgent;
}


#pragma mark - buttonPressed

- (void)leftButtonPressed {
    if (baseWebView.canGoBack) {
        [baseWebView goBack];
        isShowCloseButton = YES;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - Layout

- (void)createLayout
{
    [self setNavigationBarTitle:@"加载中⋯⋯"];
  
    UIButton *moreButton = [[UIButton alloc] init];
    self.shareBtn = moreButton;
    moreButton.frame = CGRectMake(0, 0, 64, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"Icon_Navbar_Back.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = FontMiddle;
    [leftButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    leftButton.adjustsImageWhenHighlighted = NO;
    leftButton.frame = CGRectMake(0, 0, leftButton.titleLabel.textSize.width + 20, 44);
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    if (DeviceSystemVersion >= 7.0) {
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    closeButton = [[UIButton alloc] init];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = FontMiddle;
    [closeButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
    closeButton.adjustsImageWhenHighlighted = NO;
    closeButton.showsTouchWhenHighlighted = YES;
    closeButton.hidden = YES;
    closeButton.frame = CGRectMake(0, 0, closeButton.titleLabel.textSize.width, 44);
    [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    if (DeviceSystemVersion >= 7.0) {
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    }
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
 
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftItem,closeItem ,nil]];
    
    
    titleLabel = (UILabel *)self.navigationItem.titleView;
    titleLabel.miniFontSize = 16;

    
    baseWebView = [[UIWebView alloc] init];
    //baseWebView.scalesPageToFit = YES;
    baseWebView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
 
    baseWebView.delegate = self;
    //baseWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:baseWebView];
    
    NSLog(@"height %f", ScreenHeight - 64);
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createLayout];

    if (htmlString) {
        [baseWebView loadHTMLString:htmlString baseURL:nil];
        return;
    }
    
    
    if ([baseUrl hasPrefix:@"reminder://"]) {   //保证下一个页面在本页面加载完后开始加载
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:baseUrl]];
        [baseWebView performSelector:@selector(loadRequest:) withObject:request afterDelay:1];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loadingUrl]];
        [baseWebView loadRequest:request];
    }
    

    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    didShowding = YES;
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlAbsoluteString = request.URL.absoluteString;

    if ([urlAbsoluteString hasPrefix:AppScheme]) {
        [UrlUtil openUrl:urlAbsoluteString];
        
        return NO;
    }
    
    
    shouldStartLoad = YES;
    
    
    
    
    

    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    titleLabel.text = @"加载中⋯⋯";

    if (isShowCloseButton) {
        closeButton.hidden = NO;
    } else {
        closeButton.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (baseTitle) {
        titleLabel.text = baseTitle;
    } else {
        titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    
    //NSString *urlAbsoluteString = webView.request.URL.absoluteString;
    
    [self performSelector:@selector(getHeight) withObject:nil afterDelay:5];
}

- (void)getHeight {
    CGSize fittingSize = [baseWebView sizeThatFits:CGSizeZero];
    
    NSLog(@"webViewDidFinishLoad %f", fittingSize.height);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((title == nil || title.length == 0) && shouldStartLoad) {
        title = @"加载失败~";
    }
    
    titleLabel.text = title;
    
}


@end
