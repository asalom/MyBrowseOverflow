//
//  AnswerBuilderTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AnswerBuilder.h"
#import "Question.h"
#import "Answer.h"
#import "Person.h"

@interface AnswerBuilderTests : XCTestCase

@end

static NSString * const AnswerJsonString = @"{\"items\":[{\"owner\":{\"reputation\":97060,\"user_id\":116862,\"user_type\":\"registered\",\"accept_rate\":90,\"profile_image\":\"https://www.gravatar.com/avatar/d0efc09d023fa0569a2479c9dcfd4620\",\"display_name\":\"Ole Begemann\",\"link\":\"http://stackoverflow.com/users/116862/ole-begemann\"},\"is_accepted\":true,\"score\":16,\"last_activity_date\":1339751159,\"creation_date\":1339751159,\"answer_id\":11047650,\"question_id\":11047351,\"title\":\"Workaround to accomplish protected properties in Objective-C\",\"body\":\"<p>Sure, that works fine. Apple uses the same approach for example in the <code>UIGestureRecognizer</code> class. Subclasses have to import the additional <code>UIGestureRecognizerSubclass.h</code> file and override the methods that are declared in that file.</p>\\n\"}],\"has_more\":false,\"quota_max\":300,\"quota_remaining\":256}";
static NSString * const StringIsNotJson = @"Not JSON";
static NSString * const NoAnswersJsonString = @"{\"items=\":[]}";

@implementation AnswerBuilderTests {
    AnswerBuilder *_answerBuilder;
    Question *_question;
}

- (void)setUp {
    [super setUp];
    _answerBuilder = [[AnswerBuilder alloc] init];
    _question = [[Question alloc] init];
    _question.questionId = 11047351;
}

- (void)tearDown {
    _answerBuilder = nil;
    _question = nil;
    [super tearDown];
}

- (void)testThatSendingNilJsonIsNotAnOption {
    XCTAssertThrows([_answerBuilder addAnswersToQuestion:_question fromJson:nil error:NULL], @"Not having data should have already been handled");
}

- (void)testThatAddingAnswerToNilQuestionIsNotSupported {
    XCTAssertThrows([_answerBuilder addAnswersToQuestion:nil fromJson:StringIsNotJson error:NULL], @"Makes no sense to have answers without a question");
}

- (void)testSendingNonJsonIsAnError {
    // given
    NSError *error = nil;
    
    // then
    XCTAssertFalse([_answerBuilder addAnswersToQuestion:_question fromJson:StringIsNotJson error:&error], @"Can't successfully create answers without real data");
    XCTAssertEqualObjects(error.domain, AnswerBuilderErrorDomain);
}

- (void)testErrorParameterMayBeNull {
    XCTAssertNoThrow([_answerBuilder addAnswersToQuestion:_question fromJson:StringIsNotJson error:NULL]);
}

- (void)testSendingJsonWithIncorrectKeysIsAnError {
    NSError *error = nil;
    XCTAssertFalse([_answerBuilder addAnswersToQuestion:_question fromJson:NoAnswersJsonString error:&error], @"There must be a collection of answers in the input thata");
}

- (void)testAddingRealAnswerJsonIsNotAnError {
    XCTAssertTrue([_answerBuilder addAnswersToQuestion:_question fromJson:AnswerJsonString error:NULL], @"Should be OK to actually want to add answers");
}

- (void)testNumberOfAnswersAddedMatchNumberInData {
    // when
    [_answerBuilder addAnswersToQuestion:_question fromJson:AnswerJsonString error:NULL];
    
    // then
    XCTAssertEqual(_question.answers.count, 1, @"One answers added to zero should mean one answer");
}

- (void)testAnswerPropertiesMatchDataReceived {
    // when
    [_answerBuilder addAnswersToQuestion:_question fromJson:AnswerJsonString error:NULL];
    Answer *answer = _question.answers[0];
    
    // then
    XCTAssertEqual(answer.score, (NSInteger)16, @"Score property should be set from JSON");
    XCTAssertTrue(answer.accepted, @"Answer should be accepted as in JSON data");
    XCTAssertEqualObjects(answer.body, @"<p>Sure, that works fine. Apple uses the same approach for example in the <code>UIGestureRecognizer</code> class. Subclasses have to import the additional <code>UIGestureRecognizerSubclass.h</code> file and override the methods that are declared in that file.</p>\n", @"Answer body should match fed data");
}

- (void)testAnswerIsProvidedByExpectedPerson {
    // when
    [_answerBuilder addAnswersToQuestion:_question fromJson:AnswerJsonString error:NULL];
    Answer *answer = _question.answers[0];
    Person *answerer = answer.person;
    
    // then
    XCTAssertEqualObjects(answerer.name, @"Ole Begemann", @"The provided person name was used");
    XCTAssertEqualObjects(answerer.avatarUrl.absoluteString, @"https://www.gravatar.com/avatar/d0efc09d023fa0569a2479c9dcfd4620", @"The provided email hash was converted to an avatar URL");
}

@end
