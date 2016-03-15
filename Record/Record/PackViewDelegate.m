//
//  PackViewDelegate.m
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackViewDelegate.h"

#import "PackCollectionViewCell.h"

@interface PackViewDelegate ()  {
    

    
}

@end


@implementation PackViewDelegate

+ (PackViewDelegate *)getInstance {
    static PackViewDelegate *instance = nil;
    if (instance == nil) {
        instance = [[PackViewDelegate alloc] init];
    }
    
    return instance;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PackCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PackCollectionViewCellIdentifier
                                                                              forIndexPath:indexPath];
    [cell reloadData];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, collectionView.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
