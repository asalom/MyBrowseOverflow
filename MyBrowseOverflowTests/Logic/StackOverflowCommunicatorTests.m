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
#import "FakeUrlResponse.h"
#import "StackOverflowManagerDelegate.h"

// Expose private API
@interface StackOverflowCommunicator ()
@property (strong) NSMutableData *receivedData;
@property (strong) NSURL *fetchingUrl;
@property (strong) NSURLConnection *fetchingConnection;
@end


@interface StackOverflowCommunicatorTests : XCTestCase <StackOverflowCommunicatorDelegate>

@end

@implementation StackOverflowCommunicatorTests {
    StackOverflowCommunicator *_communicator;
    FakeUrlResponse *_fourOhFourResponse;
    NSError *_errorFromDelegate;
    NSString *_resultFromDelegate;
    NSMutableData *_receivedData;
}

- (void)setUp {
    [super setUp];
    _communicator = [[StackOverflowCommunicator alloc] init];
    _communicator.delegate = self;
    _fourOhFourResponse = [[FakeUrlResponse alloc] initWithStatusCode:404];
    _errorFromDelegate = nil;
    _resultFromDelegate = nil;
    _receivedData = [[@"Result" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
}

- (void)tearDown {
    _communicator.delegate = nil;
    _communicator = nil;
    _fourOhFourResponse = nil;
    _errorFromDelegate = nil;
    _resultFromDelegate = nil;
    _receivedData = nil;
    [super tearDown];
}

- (void)testSearchingForQuestionsOnTopicCallsTopicApi {
    
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    
    // then
    XCTAssertEqualObjects([_communicator fetchingUrl].absoluteString, @"http://api.stackexchange.com/2.2/questions?tagged=ios&pagesize=20&site=stackoverflow", @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionApi {
    // when
    [_communicator downloadInformationForQuestionWithId:12345];
    
    // then
    XCTAssertEqualObjects([_communicator fetchingUrl].absoluteString, @"http://api.stackexchange.com/2.2/questions/12345?filter=withbody&site=stackoverflow");
}

- (void)testFetchingAnswersToQuestionCallsQuestionApi {
    // when
    [_communicator downloadAnswersToQuestionWithId:12345];
    
    // then
    XCTAssertEqualObjects([_communicator fetchingUrl].absoluteString, @"http://api.stackexchange.com/2.2/questions/12345/answers?filter=!-*f(6t*ZdXeu&site=stackoverflow");
}

- (void)testSearchingForQuestionsCreatesUrlConnection {
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    
    // then
    XCTAssertNotNil([_communicator fetchingConnection], @"There should be a URL connection in-flight now.");
    [_communicator cancelAndDiscardUrlConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection {
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    NSURLConnection *firstConnection = [_communicator fetchingConnection];
    [_communicator searchForQuestionsWithTag:@"cocoa"];
    NSURLConnection *secondConnection = [_communicator fetchingConnection];
    XCTAssertNotEqualObjects(firstConnection, secondConnection, @"The communicator needs to replace its URLConnection to start a new one");
    [_communicator cancelAndDiscardUrlConnection];
}

- (void)testReceivingResponseDiscardsExistingData {
    // given
    _communicator.receivedData = [[@"Hello" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    XCTAssertNotEqual(_communicator.receivedData.length, 0, @"Data should have been created");

    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    [_communicator connection:nil didReceiveResponse:nil];

    // then
    XCTAssertEqual(_communicator.receivedData.length, 0, @"Data should have been discarded");
}

- (void)testReceivingResponseWith404StatusPassesErrorToDelegate {
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    [_communicator connection:nil didReceiveResponse:(NSURLResponse *)_fourOhFourResponse];
    
    // then
    XCTAssertEqual(_errorFromDelegate.code, 404, @"Fetch failure was passed through to delegate");
}

- (void)testNoErrorReceivedOn200Status {
    // given
    FakeUrlResponse *twoHundredResponse = [[FakeUrlResponse alloc] initWithStatusCode:200];
    
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    [_communicator connection:nil didReceiveResponse:(NSURLResponse *)twoHundredResponse];
    
    // then
    XCTAssertNotEqual(_errorFromDelegate.code, 200, @"No need for error on 200 response");
}

- (void)testConnectionFailingPassesErrorToDelegate {
    // given
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
    
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    [_communicator connection:nil didFailWithError:error];
    
    // then
    XCTAssertEqual(_errorFromDelegate.code, 12345, @"Failure to connect should get passed to the delegate");
}

- (void)testSuccessfulQuestionSearchPassesDataToDelegate {
    // given
    _communicator.receivedData = _receivedData;
    
    // when
    [_communicator searchForQuestionsWithTag:@"ios"];
    [_communicator connectionDidFinishLoading:nil];
    
    // then
    XCTAssertEqualObjects(_resultFromDelegate, @"Result", @"The delegate should have received data on success");
}

- (void)testAdditionalDataAppendedToDownload {
    // given
    NSData *extraData = [@" appended" dataUsingEncoding:NSUTF8StringEncoding];
    _communicator.receivedData = _receivedData;
    
    // when
    [_communicator connection:nil didReceiveData:extraData];
    
    // then
    NSString *combinedString = [[NSString alloc] initWithData:_communicator.receivedData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(combinedString, @"Result appended");
}

#pragma mark - StackOverflowCommunicatorDelegate

- (void)searchingForQuestionsDidFailWithError:(NSError *)error {
    _errorFromDelegate = error;
}

- (void)fetchingQuestionBodyDidWithError:(NSError *)error {
    XCTAssert(@"Not implemented");
}

- (void)fetchingAnswersDidFailWithError:(NSError *)error {
    XCTAssert(@"Not implemented");
}

- (void)didReceiveQuestionsJson:(NSString *)objectNotation {
    _resultFromDelegate = [objectNotation copy];
}

- (void)didReceiveAnswerArrayJson:(NSString *)objectNotation {
    XCTAssert(@"Not implemented");
}

- (void)didReceiveQuestionBodyJson:(NSString *)objectNotation {
    XCTAssert(@"Not implemented");
}



@end