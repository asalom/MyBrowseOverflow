//
//  AnswerTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Answer.h"
#import "Person.h"

@interface AnswerTests : XCTestCase

@end

@implementation AnswerTests {
    Answer *_answer;
    Answer *_otherAnswer;
}

- (void)setUp {
    [super setUp];
    Person *person = [[Person alloc] initWithName:@"Alex Salom" avatarUrlString:@"http://exammple.com/avatar.png"];
    _answer = [[Answer alloc] initWithText:@"The answer is 42" person:person score:42];
    _otherAnswer = [[Answer alloc] initWithText:@"I have the answer you need" person:person score:42];
}

- (void)tearDown {
    _answer = nil;
    [super tearDown];
}

- (void)testAnswerHasSomeTest {
    XCTAssertEqualObjects(_answer.body, @"The answer is 42", @"Answer contains some text");
}

- (void)testSomeoneProvidedTheAnswer {
    XCTAssertTrue([_answer.person isKindOfClass:[Person class]], @"A person gave this answer");
}

- (void)testAnswerNotAcceptedByDefault {
    XCTAssertFalse(_answer.accepted, @"Answer not accepted by default");
}

- (void)testAnswerCanBeAccepted {
    XCTAssertNoThrow(_answer.accepted = YES, @"It is possible to accept the answer");
}

- (void)testAnswerHasAScore {
    XCTAssertTrue(_answer.score == 42, @"Answer's score can be retrieved");
}

- (void)testAcceptedAnswerComesBeforeUnaccepted {
    _otherAnswer.accepted = YES;
    _otherAnswer.score = _answer.score + 10;
    XCTAssertEqual([_answer compare:_otherAnswer], NSOrderedDescending, @"Accepted answer should come first");
    XCTAssertEqual([_otherAnswer compare:_answer], NSOrderedAscending, @"Accepted answer should come first");
}

- (void)testAnswersWithEqualScoresCompareEqually {
    XCTAssertEqual([_answer compare:_otherAnswer], NSOrderedSame, @"Both answers of equal rank");
    XCTAssertEqual([_otherAnswer compare:_answer], NSOrderedSame, @"Both answers of equal rank");
}

- (void)testLowerScoringAnswerComesAfterHigher {
    _otherAnswer.score = _answer.score + 10;
    XCTAssertEqual([_answer compare:_otherAnswer], NSOrderedDescending, @"Higher score comes first");
    XCTAssertEqual([_otherAnswer compare:_answer], NSOrderedAscending, @"Lower score comes last");
}

@end
