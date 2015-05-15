//
//  QuestionTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Question.h"

@interface QuestionTests : XCTestCase

@end

@implementation QuestionTests {
    Question *_question;
}

- (void)setUp {
    [super setUp];
    _question = [[Question alloc] initWithTitle:@"Do iPhones also dream of electric sheep?" date:[NSDate distantPast] score:42];
}

- (void)testQuestionHasADate {
    XCTAssertEqualObjects(_question.date, [NSDate distantPast], @"Question needs to provide its date");
}

- (void)testQuestionHasATitle {
    XCTAssertEqualObjects(_question.title, @"Do iPhones also dream of electric sheep?", @"Question needs to provide its title");
}

- (void)testQuestionKeepsScore {
    XCTAssertEqual(_question.score, 42, @"Question needs to keep score");
}

@end
