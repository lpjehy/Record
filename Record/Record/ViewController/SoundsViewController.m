//
//  SoundsViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SoundsViewController.h"

#import "ReminderManager.h"
#import "RefillManager.h"

#import "AudioManager.h"

@interface SoundsViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mainTableView;
    
}

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SoundsViewController

@synthesize selectedIndexPath;

@synthesize type;

- (void)createLayout {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(15, 20, 80, 44);
    [leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = LocalizedString(@"navigation_title_sounds");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
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
    
    return [AudioManager getInstance].soundArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.tintColor = [UIColor whiteColor];
    }
    
    NSString *text = [[AudioManager getInstance].soundArray validObjectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    
    NSString *sound = @"";
    if (type == SoundTypeRefill) {
        sound = [RefillManager notifySound];
    } else {
        sound = [ReminderManager notifySound];
    }
    
    if ([text isEqualToString:sound]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
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
    
    NSArray *soundArray = [AudioManager getInstance].soundArray;
    NSString *filename = [soundArray validObjectAtIndex:indexPath.row];
    
    if (![filename isEqualToString:SoundNameMute]) {
        [[AudioManager getInstance] playWithFilename:filename];
    }
    
    
    if (type == SoundTypeRefill) {
        [RefillManager setNotifySound:filename];
    } else {
        [ReminderManager setNotifySound:filename];
    }
    
    
}


@end
