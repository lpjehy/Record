//
//  PackViewDelegate.h
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackViewDelegate : NSObject <UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+ (PackViewDelegate *)getInstance;

@end
