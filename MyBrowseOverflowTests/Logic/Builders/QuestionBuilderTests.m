//
//  QuestionBuilderTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 20/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "QuestionBuilder.h"

@interface QuestionBuilderTests : XCTestCase

@end

@implementation QuestionBuilderTests {
    QuestionBuilder *_questionBuilder;
}

- (void)setUp {
    [super setUp];
    _questionBuilder = [[QuestionBuilder alloc] init];
}

- (void)tearDown {
    _questionBuilder = nil;
    [super tearDown];
}

- (void)testThatNilIsNotAcceptableParameter {
    XCTAssertThrows([_questionBuilder questionsFromJson:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJson {
    XCTAssertNil([_questionBuilder questionsFromJson:@"Not JSON" error:NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenStringIsNotJson {
    // given
    NSError *error = nil;
    
    // when
    [_questionBuilder questionsFromJson:@"Not JSON" error:&error];
    
    // then
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash {
    XCTAssertNoThrow([_questionBuilder questionsFromJson:@"Not JSON" error:NULL], @"Using a NULL error parameter should not be a problem");
}

@end
