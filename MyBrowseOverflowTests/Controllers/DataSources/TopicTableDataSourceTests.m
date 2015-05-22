//
//  TopicTableDataSourceTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TopicTableViewDataSource.h"
#import "Topic.h"

@interface TopicTableDataSourceTests : XCTestCase

@end

@implementation TopicTableDataSourceTests {
    TopicTableViewDataSource *_dataSource;
    NSArray *_topicsList;
}

- (void)setUp {
    [super setUp];
    _dataSource = [[TopicTableViewDataSource alloc] init];
    Topic *sampleTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"ios"];
    _topicsList = @[sampleTopic];
    _dataSource.topics = _topicsList;
}

- (void)tearDown {
    _dataSource = nil;
    [super tearDown];
}

- (void)testTopicDataSourceCanReceiveAListOfTopics {
    // given
    TopicTableViewDataSource *dataSource = [[TopicTableViewDataSource alloc] init];
    
    // when
    dataSource.topics = _topicsList;
    
    // then
    XCTAssertTrue(dataSource.topics > 0, @"The data source needs a list of topics");
}

- (void)testOneTableRowForOneTopic {
    // when & then
    XCTAssertEqual((NSInteger)_topicsList.count, [_dataSource tableView:nil numberOfRowsInSection:0], @"As there's one topic, there should be one row in the table");
}

- (void)testTwoTableRowsForTwoTopics {
    // given
    Topic *topic1 = [[Topic alloc] initWithName:@"Mac OS X" tag:@"macosx"];
    Topic *topic2 = [[Topic alloc] initWithName:@"Cocoa" tag:@"cocoa"];
    NSArray *twoTopicsArray = @[topic1, topic2];
    _dataSource.topics = twoTopicsArray;
    
    // when & then
    XCTAssertEqual(twoTopicsArray.count, [_dataSource tableView:nil numberOfRowsInSection:0], @"There should be two rows in the table for two topics");
}

- (void)testOneSectionInTheTableViewOnly {
    XCTAssertThrows([_dataSource tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional sections");
}



@end
