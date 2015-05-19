//
//  QuestionCreationTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"
#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "Topic.h"
#import <OCMock/OCMock.h>

@interface QuestionCreationTests : XCTestCase

@end

@implementation QuestionCreationTests {
    StackOverflowManager *_manager;
    MockStackOverflowManagerDelegate *_delegate;
    NSError *_underlyingError;
}

- (void)setUp {
    [super setUp];
    _manager = [[StackOverflowManager alloc] init];
    _delegate = [[MockStackOverflowManagerDelegate alloc] init];
    _manager.delegate = _delegate;
    _underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
}

- (void)tearDown {
    _manager = nil;
    _manager.delegate = nil;
    _delegate = nil;
    _underlyingError = nil;
    [super tearDown];
}

- (void)testNonConfirmingObjectCannotBeDelegate {
    XCTAssertThrows(_manager.delegate = (id<StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate {
    id<StackOverflowManagerDelegate> delegate = [[MockStackOverflowManagerDelegate alloc] init];
    XCTAssertNoThrow(_manager.delegate = delegate, @"Object confirming to the delegate protocol should be used");
}

- (void)testManagerAcceptsNilAsDelegate {
    XCTAssertNoThrow(_manager.delegate = nil, @"Object confirming to the delegate protocol should be used");
}

#pragma mark - Custom Mocks
- (void)testAskingForQuestionsMeansRequestingData {
    MockStackOverflowCommunicator *communicator = [[MockStackOverflowCommunicator alloc] init];
    _manager.communicator = communicator;
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    [_manager fetchQuestionsOnTopic:topic];
    XCTAssertTrue(communicator.wasAskedToFetchQuestions, @"The communicator should need to fetch data");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    [_manager searchingForQuestionsFailedWithError:_underlyingError];
    XCTAssertFalse(_underlyingError == [_delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    [_manager searchingForQuestionsFailedWithError:_underlyingError];
    XCTAssertEqualObjects([[[_delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], _underlyingError, @"The underlying error should be available to client code");
}

#pragma mark - OCMock
- (void)testAskingForQuestionsMeansRequestingData_OCMock {
    id communicatorMock = OCMClassMock([StackOverflowCommunicator class]);
    //[communicatorMock stub] searchingForQuestionsFailedWithError:<#(NSError *)#>
}

@end
