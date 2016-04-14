//
//  PackCollectionViewCell.h
//  Record
//
//  Created by Jehy Fan on 16/3/4.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * PackCollectionViewCellIdentifier = @"PackCollectionViewCellIdentifier";

static NSInteger const MaxDaysOfPack = 28;


@interface PackView : UIView


- (void)reloadData;

@end
