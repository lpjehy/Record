//
//  MessageCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MessageCell.h"


@interface MessageCell(){
    
    UILabel *contentLabel;
    
    
    
}
@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.font = FontSmall;
        contentLabel.frame = CGRectMake(20, 0, ScreenWidth - 40, 44);
        contentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:contentLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMessage:(NSString *)message {
    
    contentLabel.text = message;
    
}

@end
