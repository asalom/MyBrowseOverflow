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
#import "AvatarStore.h"

@interface BrowseOverflowObjectConfigurationTests : XCTestCase

@end

@implementation BrowseOverflowObjectConfigurationTests {
    BrowseOverflowObjectConfiguration *_configuration;
}

- (void)setUp {
    [super setUp];
    _configuration = [BrowseOverflowObjectConfiguration new];
}

- (void)tearDown {
    _configuration = nil;
    [super tearDown];
}

- (void)testConfigurationOfCreatedStackOverflowManager {
    // given
    StackOverflowManager *manager = [_configuration stackOverflowManager];

    // then
    XCTAssertNotNil(manager, @"The Stack Overflow Manager should exist");
    XCTAssertNotNil(manager.communicator, @"Manager should have a StackOverflowCommunicator");
    XCTAssertNotNil(manager.bodyCommunicator, @"Manager should have a StackOverflowCommunicator for body requests");
    XCTAssertNotNil(manager.questionBuilder, @"Manager should have a QuestionBuilder");
    XCTAssertNotNil(manager.answerBuilder, @"Manager should have an AnswerBuilder");
    XCTAssertEqualObjects(manager.communicator.delegate, manager, @"The manager is the communicator's delegate");
}

- (void)testConfigurationOfCreatedAvatarStore {
    // given
    AvatarStore *store = [_configuration avatarStore];
    
    // then
    XCTAssertEqualObjects(store.notificationCenter, [NSNotificationCenter defaultCenter], @"Configured AvatarStore pots notifications to the default center");
}

- (void)testSameAvatarStoreAlwaysReturned {
    // given
    AvatarStore *store1 = [_configuration avatarStore];
    AvatarStore *store2 = [_configuration avatarStore];
    
    // then
    XCTAssertEqualObjects(store1, store2, @"The same store should always be used");
}

@end
