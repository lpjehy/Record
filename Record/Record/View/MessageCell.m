//
//  MessageCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MessageCell.h"


@interface MessageCell(){
    UILabel *dateLabel;
    UILabel *contentLabel;
    
    
    
}
@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dateLabel = [[UILabel alloc] init];
        dateLabel.frame = CGRectMake(10, 0, 64, 44);
        dateLabel.textColor = ColorTextGray;
        [self.contentView addSubview:dateLabel];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.frame = CGRectMake(80, 0, ScreenWidth - 100, 44);
        contentLabel.textColor = ColorTextDark;
        [self.contentView addSubview:contentLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMessage:(Message *)message {
    
    NSDateComponents *dateComponents = [[message.time dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] components];
    dateLabel.text = [NSString stringWithFormat:@"%zi月 %zi日", dateComponents.month, dateComponents.day];
    
    contentLabel.text = message.content;
    
    self.tag = message.serialid.integerValue;
}

@end
