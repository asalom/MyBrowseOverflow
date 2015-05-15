//
//  TopicTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Topic.h"

@interface TopicTests : XCTestCase

@end

@implementation TopicTests {
    Topic *_topic;
}

- (void)setUp {
    [super setUp];
    _topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void)tearDown {
    _topic = nil;
    [super tearDown];
}

- (void)testThatTopicExists {
    XCTAssertNotNil(_topic, @"Should be able to create a Topic instance");
}

- (void)testThatTopicCanBeNamed {
    XCTAssertEqualObjects(_topic.name, @"iPhone", @"Topics need to have names");
}

- (void)testThatTopicHasATag {
    XCTAssertEqualObjects(_topic.tag, @"iphone", @"Topics need to have tags");
}

- (void)testForAListOfQuestions {
    XCTAssertTrue([_topic.recentQuestions isKindOfClass:[NSArray class]], @"Topics should provide a list of recentQuestions");
}

@end
