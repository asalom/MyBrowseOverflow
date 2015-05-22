//
//  EmptyTableViewDataSource.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "TopicTableViewDataSource.h"
#import "Topic.h"

@implementation TopicTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < self.topics.count);
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Topic *topic = self.topics[indexPath.row];
    cell.textLabel.text = topic.name;
    return cell;
}

@end
