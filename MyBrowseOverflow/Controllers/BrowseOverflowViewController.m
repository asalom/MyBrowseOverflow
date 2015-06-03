//
//  BrowseOverflowViewController.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"
#import "Topic.h"
#import "QuestionListTableViewDataSource.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([self.dataSource class], "tableView");
    if (tableViewProperty) {
        [self.dataSource setValue:self.tableView forKey:@"tableView"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectTopicNotification:)
                                                 name:TopicTableDidSelectTopicNotification
                                               object:nil];
    if ([self.dataSource isKindOfClass:[QuestionListTableViewDataSource class]]) {
        ((QuestionListTableViewDataSource *)self.dataSource).notificationCenter = [NSNotificationCenter defaultCenter];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidSelectTopicNotification:(NSNotification *)notification {
    BrowseOverflowViewController *newController = [[BrowseOverflowViewController alloc] init];
    QuestionListTableViewDataSource *dataSource = [[QuestionListTableViewDataSource alloc] init];
    dataSource.tableView = self.tableView;
    dataSource.topic = notification.object;
    newController.dataSource = dataSource;
    newController.objectConfiguration = self.objectConfiguration;
    [self.navigationController pushViewController:newController animated:YES];
}

@end
