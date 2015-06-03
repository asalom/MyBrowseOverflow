//
//  BrowseOverflowAppDelegateTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 3/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BrowseOverflowAppDelegate.h"
#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"

@interface BrowseOverflowAppDelegateTests : XCTestCase

@end

@implementation BrowseOverflowAppDelegateTests {
    BrowseOverflowAppDelegate *_appDelegate;
    UIStoryboard *_storyboard;
    UINavigationController *_navigationController;
    UIWindow *_window;
    BrowseOverflowViewController *_topViewController;
}

- (void)setUp {
    [super setUp];
    _navigationController = [_storyboard instantiateInitialViewController];
    _appDelegate = [UIApplication sharedApplication].delegate;
    _window = _appDelegate.window;
    _navigationController = (UINavigationController *)_window.rootViewController;
    _topViewController = (BrowseOverflowViewController *)_navigationController.topViewController;
}

- (void)tearDown {
    _appDelegate = nil;
    _storyboard = nil;
    _navigationController = nil;
    _window = nil;
    _topViewController = nil;
    [super tearDown];
}

- (void)testAppDidFinishLaunchingReturnsYES {
    // then
    XCTAssertTrue([_appDelegate application:nil didFinishLaunchingWithOptions:nil], @"Method should return YES");
}

- (void)testInitialSetupUsesNavigationController {
    // given
    id visibleController = _window.rootViewController;
    
    // then
    XCTAssertTrue([visibleController isKindOfClass:[UINavigationController class]], @"Initial navigation is based in UINavigationController");
}

- (void)testNavigationControllerShowsABrowseOverflowViewController {
    // given
    UINavigationController *visibleController = (UINavigationController *)_window.rootViewController;
    
    // then
    XCTAssertTrue([visibleController.topViewController isKindOfClass:[BrowseOverflowViewController class]], @"Views in this app are supplied by BrowseOverflowViewControllers");
}

- (void)testFirstViewControllerHasATopicTableDataSource {
    // then
    XCTAssertTrue([_topViewController.dataSource isKindOfClass:[TopicTableViewDataSource class]]);
}

- (void)testTopicListIsNotEmptyOnAppLaunch {
    // given
    id<UITableViewDataSource> dataSource = _topViewController.dataSource;
    
    // then
    XCTAssertNotEqual([dataSource tableView:nil numberOfRowsInSection:0], 0, @"There should be some rows to display");
}

@end
