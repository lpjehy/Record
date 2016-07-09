//
//  LanguagesViewController.m
//  Record
//
//  Created by Jehy Fan on 16/5/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LanguagesViewController.h"

#import "MainViewController.h"

#import "LanguageManager.h"

@interface LanguagesViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mainTableView;
    
    UIButton *doneButton;
    
    NSArray *languageArray;
    
    NSInteger originalRow;
    
}

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation LanguagesViewController

@synthesize selectedIndexPath;


- (void)doneButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    NSString *languageKey = [languageArray validObjectAtIndex:selectedIndexPath.row];
    [LanguageManager setLanguage:languageKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LanguageChangedNotification object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        MainViewController *mainViewController = [[MainViewController alloc] init];
        
        
        UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
        KeyWindow.rootViewController = mainNavigationController;
    }];
    
    
}

- (void)createLayout {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(15, 20, 80, 44);
    [leftButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = LocalizedString(@"navigation_title_languages");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    doneButton = [[UIButton alloc] init];
    doneButton.hidden = YES;
    doneButton.frame = CGRectMake(ScreenWidth - 74, 20, 64, 44);
    [doneButton setTitle:LocalizedString(@"button_title_done") forState:UIControlStateNormal];
    doneButton.titleLabel.font = FontMiddle;
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:doneButton];
    
    self.view.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    languageArray = [LanguageManager languages];
    
    
    [self createLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return languageArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.tintColor = [UIColor whiteColor];
    }
    
    NSString *languageKey = [languageArray validObjectAtIndex:indexPath.row];
    NSString *language = [LanguageManager languageName:languageKey];
    
    
    cell.textLabel.text = language;
    
    if ([languageKey isEqualToString:[LanguageManager language]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
        originalRow = indexPath.row;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:YES];
    
    if (selectedIndexPath.row != indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    self.selectedIndexPath = indexPath;
    
    if (indexPath.row == originalRow) {
        doneButton.hidden = YES;
    } else {
        doneButton.hidden = NO;
    }
    
}



@end
