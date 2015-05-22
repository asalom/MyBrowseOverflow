//
//  BrowseOverflowViewController.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowViewController.h"

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.delegate;
}

@end
