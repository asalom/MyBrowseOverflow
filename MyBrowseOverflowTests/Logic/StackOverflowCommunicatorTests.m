//
//  StackOverflowCommunicatorTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "StackOverflowCommunicator.h"
#import "InspectableStackOverflowCommunicator.h"

@interface StackOverflowCommunicatorTests : XCTestCase

@end

@implementation StackOverflowCommunicatorTests {
    InspectableStackOverflowCommunicator *_communicator;
}

- (void)setUp {
    [super setUp];
    _communicator = [[InspectableStackOverflowCommunicator alloc] init];
}

- (void)tearDown {
    _communicator = nil;
    [super tearDown];
}

- (void)testSearchingForQuestionsOnTopicCallsTopicApi {
    
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    
    // then
    XCTAssertEqualObjects([_communicator urlToFetch].absoluteString, @"http://api.stackexchange.com/2.2/questions?tagged=ios&pagesize=20&site=stackoverflow", @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionApi {
    // when
    [_communicator downloadInformationForQuestionWithId:12345];
    
    // then
    XCTAssertEqualObjects([_communicator urlToFetch].absoluteString, @"http://api.stackexchange.com/2.2/questions/12345?filter=withbody&site=stackoverflow");
}

- (void)testFetchingAnswersToQuestionCallsQuestionApi {
    // when
    [_communicator downloadAnswersToQuestionWithId:12345];
    
    // then
    XCTAssertEqualObjects([_communicator urlToFetch].absoluteString, @"http://api.stackexchange.com/2.2/questions/12345/answers?filter=!-*f(6t*ZdXeu&site=stackoverflow");
}

- (void)testSearchingForQuestionsCreatesUrlConnection {
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    
    // then
    XCTAssertNotNil([_communicator currentUrlConnection], @"There should be a URL connection in-flight now.");
    [_communicator cancelAndDiscardUrlConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection {
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    NSURLConnection *firstConnection = [_communicator currentUrlConnection];
    [_communicator searchForQuestionsWithTag:@"cocoa"];
    NSURLConnection *secondConnection = [_communicator currentUrlConnection];
    XCTAssertNotEqualObjects(firstConnection, secondConnection, @"The communicator needs to replace its URLConnection to start a new one");
    [_communicator cancelAndDiscardUrlConnection];
}

@end
