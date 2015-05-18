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
#import "Answer.h"

@interface QuestionTests : XCTestCase

@end

@implementation QuestionTests {
    Question *_question;
    Answer *_lowScore;
    Answer *_highScore;
}

- (void)setUp {
    [super setUp];
    _question = [[Question alloc] initWithTitle:@"Do iPhones also dream of electric sheep?" date:[NSDate distantPast] score:42];
    
    _lowScore = [[Answer alloc] init];
    _lowScore.score = 1;
    _lowScore.accepted = NO;
    [_question addAnswer:_lowScore];
    
    _highScore = [[Answer alloc] init];
    _highScore.accepted = YES;
    _highScore.score = 4;
    [_question addAnswer:_highScore];
}

- (void)tearDown {
    _question = nil;
    _lowScore = nil;
    _highScore = nil;
    [super tearDown];
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

- (void)testQuestionCanHaveAnswersAdded {
    Answer *myAnswer = [[Answer alloc] init];
    XCTAssertNoThrow([_question addAnswer:myAnswer], @"Must be able to add answers");
}

- (void)testAcceptedAnswerIsFirst {
    XCTAssertTrue([_question.answers[0] isAccepted], @"Accepted answer comes first");
}

- (void)testHighScoreAnswerBeforeLow {
    NSArray *answers = _question.answers;
    NSInteger highIndex = [answers indexOfObject:_highScore];
    NSInteger lowIndex = [answers indexOfObject:_lowScore];
    XCTAssertTrue(highIndex < lowIndex, @"High-scoring answer comes first");
}

@end
