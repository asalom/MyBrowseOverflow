//
//  EmptyTableViewDataSource.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "TopicTableViewDataSource.h"
#import "Topic.h"

static NSString * const TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";

@implementation TopicTableViewDataSource

- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath {
    return self.topics[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < self.topics.count);
    static NSString *reuseIdentifier = @"TopicCellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    Topic *topic = [self topicForIndexPath:indexPath];
    cell.textLabel.text = topic.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification
                                                        object:self.topics[indexPath.row]];
}

@end
