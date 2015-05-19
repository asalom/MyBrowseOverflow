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
#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicator.h"
#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "Topic.h"
#import <OCMock/OCMock.h>

@interface QuestionCreationTests : XCTestCase <StackOverflowManagerDelegate>

@end

@implementation QuestionCreationTests {
    StackOverflowManager *_manager;
    NSError *_underlyingError;
}

- (void)setUp {
    [super setUp];
    _manager = [[StackOverflowManager alloc] init];
    _manager.delegate = self;
}

- (void)tearDown {
    _manager = nil;
    _manager.delegate = nil;
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

- (void)testAskingForQuestionsMeansRequestingData_OCMock {
    // when
    id communicatorMock = OCMClassMock([StackOverflowCommunicator class]);
    _manager.communicator = communicatorMock;
    OCMExpect([communicatorMock searchForQuestionsWithTag:nil]);
    
    // given
    [_manager fetchQuestionsOnTopic:nil];
    
    // then
    OCMExpect(communicatorMock);
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    // when
    NSError *error = [NSError new];
    
    // given
    [_manager searchingForQuestionsFailedWithError:error];
    
    //then
    XCTAssertFalse(_underlyingError == error, @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    // when
    NSError *error = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    //given
    [_manager searchingForQuestionsFailedWithError:error];
    
    // then
    XCTAssertEqualObjects([[_underlyingError userInfo] objectForKey:NSUnderlyingErrorKey], error, @"The underlying error should be available to client code");
}

#pragma mark -- StackOverflowManagerDelegate
- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    _underlyingError = error;
}

@end
