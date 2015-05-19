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
#import "QuestionBuilder.h"
#import "FakeQuestionBuilder.h"
#import <OCMock/OCMock.h>
#import "Question.h"

@interface QuestionCreationTests : XCTestCase <StackOverflowManagerDelegate>

@end

@implementation QuestionCreationTests {
    StackOverflowManager *_manager;
    NSError *_underlyingErrorFromDelegate;
    NSArray *_questionsArray;
    NSArray *_receivedQuestionsArrayFromDelegate;
}

- (void)setUp {
    [super setUp];
    _manager = [[StackOverflowManager alloc] init];
    _manager.delegate = self;
    Question *question = [[Question alloc] init];
    _questionsArray = @[question];
}

- (void)tearDown {
    _manager = nil;
    _manager.delegate = nil;
    _underlyingErrorFromDelegate = nil;
    _questionsArray = nil;
    [super tearDown];
}

- (void)testNonConfirmingObjectCannotBeDelegate {
    XCTAssertThrows(_manager.delegate = (id<StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate {
    XCTAssertNoThrow(_manager.delegate = self, @"Object confirming to the delegate protocol should be used");
}

- (void)testManagerAcceptsNilAsDelegate {
    XCTAssertNoThrow(_manager.delegate = nil, @"Object confirming to the delegate protocol should be used");
}

- (void)testAskingForQuestionsMeansRequestingData_OCMock {
    // given
    id communicatorMock = OCMClassMock([StackOverflowCommunicator class]);
    _manager.communicator = communicatorMock;
    OCMExpect([communicatorMock searchForQuestionsWithTag:nil]);
    
    // when
    [_manager fetchQuestionsOnTopic:nil];
    
    // then
    OCMExpect(communicatorMock);
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    // given
    NSError *error = [NSError new];
    
    // when
    [_manager searchingForQuestionsFailedWithError:error];
    
    //then
    XCTAssertFalse(_underlyingErrorFromDelegate == error, @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    // given
    NSError *error = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    // when
    [_manager searchingForQuestionsFailedWithError:error];
    
    // then
    XCTAssertEqualObjects([[_underlyingErrorFromDelegate userInfo] objectForKey:NSUnderlyingErrorKey], error, @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder {
    // given
    id mockQuestionBuilder = OCMClassMock([QuestionBuilder class]);
    OCMExpect([mockQuestionBuilder questionsFromJson:@"Fake JSON" error:[OCMArg anyObjectRef]]);
    _manager.questionBuilder = mockQuestionBuilder;
    
    // when
    [_manager receivedQuestionsJson:@"Fake JSON"];
    
    // then
    [mockQuestionBuilder verify];
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails {
    // given
    id mockQuestionBuilder = OCMClassMock([QuestionBuilder class]);
    OCMStub([mockQuestionBuilder questionsFromJson:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(nil);
    _manager.questionBuilder = mockQuestionBuilder;
    
    // when
    [_manager receivedQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertNotNil(_underlyingErrorFromDelegate, @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived {
    // given
    FakeQuestionBuilder *mockQuestionBuilder = [[FakeQuestionBuilder alloc] init];
    mockQuestionBuilder.arrayToReturn = _questionsArray;
    _manager.questionBuilder = mockQuestionBuilder;
    
    // when
    [_manager receivedQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertNil(_underlyingErrorFromDelegate, @"No error should be reported");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager {
    // given
    FakeQuestionBuilder *mockQuestionBuilder = [[FakeQuestionBuilder alloc] init];
    mockQuestionBuilder.arrayToReturn = _questionsArray;
    _manager.questionBuilder = mockQuestionBuilder;
    
    // when
    [_manager receivedQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertEqualObjects(_receivedQuestionsArrayFromDelegate, _questionsArray, @"The manager should have sent its questions to the delegate");
}

#pragma mark -- StackOverflowManagerDelegate
- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    _underlyingErrorFromDelegate = error;
}

- (void)didReceiveQuestions:(NSArray *)questions {
    _receivedQuestionsArrayFromDelegate = questions;
}

@end
