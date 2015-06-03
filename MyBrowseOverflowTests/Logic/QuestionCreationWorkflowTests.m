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
#import "Topic.h"

@interface QuestionCreationWorkflowTests : XCTestCase <StackOverflowManagerDelegate>

@end

@implementation QuestionCreationWorkflowTests {
    StackOverflowManager *_manager;
    NSError *_underlyingErrorFromDelegate;
    NSArray *_questionsArray;
    NSArray *_receivedQuestionsArrayFromDelegate;
    Question *_receivedQuestionBodyFromDelegate;
    id _mockQuestionBuilder;
    Question *_questionToFetch;
    id _mockCommunicator;
}

- (void)setUp {
    [super setUp];
    _manager = [[StackOverflowManager alloc] init];
    _manager.delegate = self;
    _questionToFetch = [[Question alloc] init];
    _questionToFetch.questionId = 1234;
    _questionsArray = @[_questionToFetch];
    _mockQuestionBuilder = OCMClassMock([QuestionBuilder class]);
    _manager.questionBuilder = _mockQuestionBuilder;
    _mockCommunicator = OCMClassMock([StackOverflowCommunicator class]);
    _manager.communicator = _mockCommunicator;
}

- (void)tearDown {
    _manager = nil;
    _manager.delegate = nil;
    _underlyingErrorFromDelegate = nil;
    _questionToFetch = nil;
    _questionsArray = nil;
    _mockCommunicator = nil;
    _receivedQuestionBodyFromDelegate = nil;
    _receivedQuestionsArrayFromDelegate = nil;
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
    
    // when
    [_manager fetchQuestionsOnTopic:nil];
    
    // then
    OCMVerify([communicatorMock searchForQuestionsWithTag:[OCMArg any]]);
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    // given
    NSError *error = [NSError new];
    
    // when
    [_manager searchingForQuestionsDidFailWithError:error];
    
    // then
    XCTAssertFalse(_underlyingErrorFromDelegate == error, @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    // given
    NSError *error = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    // when
    [_manager searchingForQuestionsDidFailWithError:error];
    
    // then
    XCTAssertEqualObjects([[_underlyingErrorFromDelegate userInfo] objectForKey:NSUnderlyingErrorKey], error, @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder {

    // when
    [_manager didReceiveQuestionsJson:@"Fake JSON"];
    
    // then
    //[_mockQuestionBuilder verify];
    OCMVerify([_mockQuestionBuilder questionsFromJson:@"Fake JSON" error:[OCMArg anyObjectRef]]);
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails {
    // given
    OCMStub([_mockQuestionBuilder questionsFromJson:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(nil);
    
    // when
    [_manager didReceiveQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertNotNil(_underlyingErrorFromDelegate, @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived {
    // given
    OCMStub([_mockQuestionBuilder questionsFromJson:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(_questionsArray);
    
    // when
    [_manager didReceiveQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertNil(_underlyingErrorFromDelegate, @"No error should be reported");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager {
    // given
    OCMStub([_mockQuestionBuilder questionsFromJson:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(_questionsArray);
    
    // when
    [_manager didReceiveQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertEqualObjects(_receivedQuestionsArrayFromDelegate, _questionsArray, @"The manager should have sent its questions to the delegate");
}

- (void)testEmptyArrayIsPassedToDelegate {
    // given
    OCMStub([_mockQuestionBuilder questionsFromJson:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn([NSArray array]);
    
    // when
    [_manager didReceiveQuestionsJson:@"Fake JSON"];
    
    // then
    XCTAssertEqualObjects(_receivedQuestionsArrayFromDelegate, [NSArray array], @"Returning empty array is not an error");
}

- (void)testAskingForQuestionBodyMeansRequestingData {
    // when
    [_manager fetchBodyForQuestion:_questionToFetch];
    
    // then
    OCMVerify([_mockCommunicator downloadInformationForQuestionWithId:_questionToFetch.questionId]);
}

- (void)testDelegateNotifiedOfFailureToFetchQuestion {
    // given
    NSError *error = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    // when
    [_manager fetchingQuestionBodyDidFailWithError:error];
    
    // then
    XCTAssertNotNil(_underlyingErrorFromDelegate.userInfo, @"Delegate should have found about this error");
}

- (void)testManagerPassesRetrievedQuestionBodyToQuestionBuilder {
    // when
    [_manager didReceiveQuestionBodyJson:@"Fake JSON"];
    
    // then
    OCMVerify([_mockQuestionBuilder fillInDetailsForQuestion:[OCMArg any] fromJson:@"Fake JSON"]);
}

- (void)testManagerPassesQuestionItWasSentToQuestionBuilderForFillingIn {
    // when
    [_manager fetchBodyForQuestion:_questionToFetch];
    [_manager didReceiveQuestionBodyJson:@"Fake JSON"];
    
    // then
    OCMVerify([_mockQuestionBuilder fillInDetailsForQuestion:_questionToFetch fromJson:[OCMArg any]]);
}

#pragma mark -- StackOverflowManagerDelegate
- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    _underlyingErrorFromDelegate = error;
}

- (void)didReceiveQuestions:(NSArray *)questions {
    _receivedQuestionsArrayFromDelegate = questions;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    _underlyingErrorFromDelegate = error;
}

- (void)didReceiveBodyForQuestion:(Question *)question {
    _receivedQuestionBodyFromDelegate = question;
}

@end
