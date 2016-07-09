//
//  SoundsViewController.h
//  Record
//
//  Created by Jehy Fan on 16/3/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SoundType) {
    SoundTypeRefill,//默认从0开始
    SoundTypeRemind
};


@interface SoundsViewController : BaseViewController


@property(nonatomic) SoundType type;

@end
