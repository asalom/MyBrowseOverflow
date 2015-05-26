//
//  BrowseOverflowViewController.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "TopicTableViewDelegate.h"
#import "TopicTableViewDataSource.h"

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) TopicTableViewDataSource *dataSource;
@property (nonatomic, assign) TopicTableViewDelegate *delegate;
@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.delegate;
    self.delegate.tableViewDataSource = self.dataSource;
}

@end
