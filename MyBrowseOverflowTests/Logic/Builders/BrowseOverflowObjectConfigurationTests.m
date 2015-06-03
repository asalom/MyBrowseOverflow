//
//  BrowseOverflowObjectConfigurationTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 3/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BrowseOverflowObjectConfiguration.h"
#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"

@interface BrowseOverflowObjectConfigurationTests : XCTestCase

@end

@implementation BrowseOverflowObjectConfigurationTests

- (void)testConfigurationOfCreatedStackOverflowManager {
    // given
    BrowseOverflowObjectConfiguration *configuration = [BrowseOverflowObjectConfiguration new];
    StackOverflowManager *manager = [configuration stackOverflowManager];

    // then
    XCTAssertNotNil(manager, @"The Stack Overflow Manager should exist");
    XCTAssertNotNil(manager.communicator, @"Manager should have a StackOverflowCommunicator");
    XCTAssertNotNil(manager.questionBuilder, @"Manager should have a QuestionBuilder");
    XCTAssertNotNil(manager.answerBuilder, @"Manager should have an AnswerBuilder");
    XCTAssertEqualObjects(manager.communicator.delegate, manager, @"The manager is the communicator's delegate");
}

@end
