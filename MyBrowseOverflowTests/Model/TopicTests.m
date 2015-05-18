//
//  TopicTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Topic.h"
#import "Question.h"

@interface TopicTests : XCTestCase

@end

@implementation TopicTests {
    Topic *_topic;
}

- (void)setUp {
    [super setUp];
    _topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void)tearDown {
    _topic = nil;
    [super tearDown];
}

- (void)testThatTopicExists {
    XCTAssertNotNil(_topic, @"Should be able to create a Topic instance");
}

- (void)testThatTopicCanBeNamed {
    XCTAssertEqualObjects(_topic.name, @"iPhone", @"Topics need to have names");
}

- (void)testThatTopicHasATag {
    XCTAssertEqualObjects(_topic.tag, @"iphone", @"Topics need to have tags");
}

- (void)testForAListOfQuestions {
    XCTAssertTrue([_topic.recentQuestions isKindOfClass:[NSArray class]], @"Topics should provide a list of recentQuestions");
}

- (void)testForInitiallyEmptyQuestionList {
    XCTAssertEqual(_topic.recentQuestions.count, 0, @"The question list should be empty initially");
}

- (void)testAddingAQuestionToTheList {
    Question *question = [[Question alloc] init];
    [_topic addQuestion:question];
    XCTAssertEqual(_topic.recentQuestions.count, 1, @"Add a question, and the count of questions should go up");
}

- (void)testQuestionsAreListedChronologically {
    Question *q1 = [[Question alloc] initWithTitle:nil date:[NSDate distantPast] score:0];
    Question *q2 = [[Question alloc] initWithTitle:nil date:[NSDate distantFuture] score:0];
    [_topic addQuestion:q2];
    [_topic addQuestion:q1];
    
    NSArray *questions = _topic.recentQuestions;
    Question *listedFirst = questions[0];
    Question *listedSecond = questions[1];
    XCTAssertEqualObjects([listedFirst.date laterDate:listedSecond.date], listedFirst.date, @"The later question should appear first in the list");
}

- (void)testLimitOfTwentyQuestions {
    Question *q1 = [[Question alloc] init];
    for (NSInteger i = 0; i < 25; i++) {
        [_topic addQuestion:q1];
    }
    XCTAssertTrue(_topic.recentQuestions.count <= 20, @"There should never be more than twenty questions");
}

@end
