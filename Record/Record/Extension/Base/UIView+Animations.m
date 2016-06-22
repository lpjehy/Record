//
//  UIViewExtension.m
//  eCook
//
//  Created by Jehy Fan on 14-8-8.
//
//

#import "UIView+Animations.h"


@implementation UIView(Animations)

- (void)animatExpand {
    [self animatExpandWithRange:0.1];
}

- (void)animatExpandWithRange:(CGFloat)range {
    [UIView animateWithDuration:0.24
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1 + range, 1 + range);
                     }
                     completion:^(BOOL finish){
                         [UIView animateWithDuration:0.24
                                          animations:^{
                                              self.transform = CGAffineTransformMakeScale(1 - range, 1 - range);
                                          }
                                          completion:^(BOOL finish){
                                              [UIView animateWithDuration:0.24
                                                               animations:^{
                                                                   self.transform = CGAffineTransformMakeScale(1, 1);
                                                               }
                                                               completion:^(BOOL finish){
                                                                   
                                                               }];
                                          }];
                     }];
}

@end


