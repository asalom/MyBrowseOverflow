//
//  BrowseOverflowViewController.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;
@class BrowseOverflowObjectConfiguration;

@interface BrowseOverflowViewController : UIViewController

@property (nonatomic, strong) NSObject<UITableViewDataSource, UITableViewDelegate> *dataSource;
@property (nonatomic, strong) BrowseOverflowObjectConfiguration *objectConfiguration;

- (void)userDidSelectTopicNotification:(NSNotification *)notification;

@end
