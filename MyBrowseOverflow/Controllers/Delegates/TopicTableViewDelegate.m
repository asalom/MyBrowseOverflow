//
//  EmptyTableViewDelegate.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "TopicTableViewDelegate.h"
#import "TopicTableViewDataSource.h"

static NSString * const TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";

@implementation TopicTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification
                                                        object:self.tableViewDataSource.topics[indexPath.row]];
}

@end
