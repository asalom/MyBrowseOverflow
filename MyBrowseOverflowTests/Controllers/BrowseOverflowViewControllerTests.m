//
//  BrowseOverflowViewControllerTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@end

@interface BrowseOverflowViewControllerTests : XCTestCase

@end

@implementation BrowseOverflowViewControllerTests {
    BrowseOverflowViewController *_viewController;
    UITableView *_tableView;
    id<UITableViewDataSource> _dataSource;
}

- (void)setUp {
    [super setUp];
    _viewController = [BrowseOverflowViewController alloc];
    _tableView = [[UITableView alloc] init];
    _viewController.tableView = _tableView;
    _dataSource = [[TopicTableViewDataSource alloc] init];
    _viewController.dataSource = _dataSource;
}

- (void)tearDown {
    _viewController = nil;
    _dataSource = nil;
    _tableView = nil;
    [super tearDown];
}

- (void)testViewControllerHasATableViewProperty {
    // given
    objc_property_t tableViewProperty = class_getProperty([_viewController class], "tableView");
    
    // then
    XCTAssertTrue(tableViewProperty != NULL, @"BrowseOverflowViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty {
    // given
    objc_property_t dataSourceProperty = class_getProperty([_viewController class], "dataSource");
    
    // then
    XCTAssertTrue(dataSourceProperty != NULL, @"BrowseOverflowViewController needs a data source");
}

- (void)testViewControllerConnectsDataSourceInViewDidLoad {
    // given
    [_viewController view];
    
    // then
    XCTAssertEqualObjects(_tableView.dataSource, _dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad {
    // given
    [_viewController view];
    
    // then
    XCTAssertEqualObjects(_tableView.delegate, _dataSource, @"View controller should have set the table view's delegate");
}

@end
