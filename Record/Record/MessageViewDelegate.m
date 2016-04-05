//
//  MessageViewDelegate.m
//  Record
//
//  Created by Jehy Fan on 16/3/13.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MessageViewDelegate.h"

#import "MessageManager.h"

@implementation MessageViewDelegate

+ (MessageViewDelegate *)getInstance {
    static MessageViewDelegate *instance = nil;
    if (instance == nil) {
        instance = [[MessageViewDelegate alloc] init];
    }
    
    return instance;
}



/*

#pragma mark tableView编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MessageManager deleteMessage:[NSString stringWithInteger:cell.tag]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MessageManager deleteMessage:[NSString stringWithInteger:cell.tag]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //[tableView reloadData];
        
    }];
    
    return @[deleteAction];
}
 
 */

@end
