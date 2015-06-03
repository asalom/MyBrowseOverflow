//
//  BrowseOverflowViewController.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;

@interface BrowseOverflowViewController : UIViewController

@property (nonatomic, strong) NSObject<UITableViewDataSource, UITableViewDelegate> *dataSource;

- (void)userDidSelectTopicNotification:(NSNotification *)notification;

@end
