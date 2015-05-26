//
//  EmptyTableViewDataSource.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;

static NSString * const TopicTableDidSelectTopicNotification;

@interface TopicTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong) NSArray *topics;

@end
