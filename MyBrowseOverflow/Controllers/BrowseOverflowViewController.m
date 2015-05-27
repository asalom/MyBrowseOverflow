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

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<UITableViewDataSource, UITableViewDelegate> dataSource;
@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectTopicNotification:)
                                                 name:TopicTableDidSelectTopicNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidSelectTopicNotification:(NSNotification *)notification {
    BrowseOverflowViewController *newController = [[BrowseOverflowViewController alloc] init];
    QuestionListTableViewDataSource *dataSource = [[QuestionListTableViewDataSource alloc] init];
    dataSource.topic = notification.object;
    newController.dataSource = dataSource;
    [self.navigationController pushViewController:newController animated:YES];
}

@end
