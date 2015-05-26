//
//  TopicTableDelegateTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 26/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TopicTableViewDataSource.h"
#import "Topic.h"

@interface TopicTableDelegateTests : XCTestCase

@end

@implementation TopicTableDelegateTests {
    NSNotification *_receivedNotification;
    TopicTableViewDataSource *_dataSource;
    Topic *_iPhoneTopic;
}

- (void)setUp {
    [super setUp];
    _dataSource = [[TopicTableViewDataSource alloc] init];
    _iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    _dataSource.topics = @[_iPhoneTopic];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:TopicTableDidSelectTopicNotification
                                               object:nil];
}

- (void)tearDown {
    _dataSource = nil;
    _iPhoneTopic = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

- (void)testDelegatePostsNotificationOnSelectionShowingWhichTopicWasSelected {
    // given
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // when
    [_dataSource tableView:nil didSelectRowAtIndexPath:indexPath];
    
    // then
    XCTAssertEqualObjects(_receivedNotification.name, @"TopicTableDidSelectTopicNotification", @"The delegate should notify that a topic was selected");
    XCTAssertEqualObjects(_receivedNotification.object, _iPhoneTopic, @"The notification should indicate which topic was selected");
}

#pragma mark - Notifications
- (void)didReceiveNotification:(NSNotification *)notification {
    _receivedNotification = notification;
}

@end
