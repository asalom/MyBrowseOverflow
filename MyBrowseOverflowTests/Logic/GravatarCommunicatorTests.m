//
//  GravatarCommunicatorTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 2/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GravatarCommunicator.h"
#import "GravatarCommunicatorDelegate.h"

@interface GravatarCommunicatorTests : XCTestCase <GravatarCommunicatorDelegate>

@end

@implementation GravatarCommunicatorTests {
    GravatarCommunicator *_communicator;
    NSData *_fakeData;
    NSURL *_delegateUrl;
    NSData *_delegateData;
}

- (void)setUp {
    [super setUp];
    _communicator = [[GravatarCommunicator alloc] init];
    _communicator.url = [NSURL URLWithString:@"http://example.com/avatar"];
    _communicator.delegate = self;
    _fakeData = [@"Fake data" dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown {
    _communicator = nil;
    _fakeData = nil;
    _delegateUrl = nil;
    _delegateData = nil;
    [super tearDown];
}

- (void)testCommunicatorPassesUrlBackWhenCompleted {
    // when
    [_communicator connectionDidFinishLoading:nil];
    
    // then
    XCTAssertEqualObjects(_delegateUrl, _communicator.url, @"The communicator needs to explain which URL it's downloaded content for");
}

- (void)testCommunicatorPassesDataWhenCompleted {
    // given
    _communicator.receivedData = [_fakeData mutableCopy];
    
    // when
    [_communicator connectionDidFinishLoading:nil];
    
    // then
    XCTAssertEqualObjects(_delegateData, _fakeData, @"The communicator needs to pass its data to the delegate");
}

- (void)testCommunicatorKeepsUrlRequested {
    // given
    NSURL *differentUrl = [NSURL URLWithString:@"http://example.org/notthesameUrl"];
    
    // when
    [_communicator fetchDataForUrl:differentUrl];
    
    // then
    XCTAssertEqualObjects(_communicator.url, differentUrl, @"Communicators holds on to URL");
}

- (void)testCommunicatorCreatesAUrlConnection {
    // when
    [_communicator fetchDataForUrl:_communicator.url];
    
    // then
    XCTAssertNotNil(_communicator.connection, @"The communicator should create an NSURLConnection here");
}

- (void)testCommunicatorDiscardsDataWhenResponseReceived {
    // given
    _communicator.receivedData = [_fakeData mutableCopy];
    
    // when
    [_communicator connection:nil didReceiveResponse:nil];
    
    // then
    XCTAssertEqual(_communicator.receivedData.length, 0, @"Data should have been dicarded");
}

- (void)testCommunicatorAppendsReceivedData {
    // given
    _communicator.receivedData = [_fakeData mutableCopy];
    NSData *extraData = [@" more" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *expectedData = [@"Fake data more" dataUsingEncoding:NSUTF8StringEncoding];
    
    // when
    [_communicator connection:nil didReceiveData:extraData];
    
    // then
    XCTAssertEqualObjects([_communicator.receivedData copy], expectedData, @"Should append data when it gets received");
}

- (void)testUrlPassedBackOnError {
    // when
    [_communicator connection:nil didFailWithError:nil];
    
    // then
    XCTAssertEqualObjects(_delegateUrl, _communicator.url, @"Delegate knows which URL got an error");
}

#pragma mark - GravatarCommunicatorDelegate
- (void)communicatorReceivedData:(NSData *)data forUrl:(NSURL *)url {
    _delegateUrl = url;
    _delegateData = data;
}

- (void)communicatorGotErrorForURL:(NSURL *)url {
    _delegateUrl = url;
}

@end
