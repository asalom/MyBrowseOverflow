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
#import "Question.h"
#import "Person.h"

static NSString * const QuestionJsonString = @"{\"items\":[{\"tags\":[\"objective-c\",\"properties\",\"protected\"],\"owner\":{\"reputation\":647,\"user_id\":1266056,\"user_type\":\"registered\",\"accept_rate\":100,\"profile_image\":\"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209\",\"display_name\":\"Alex Salom\",\"link\":\"http://stackoverflow.com/users/1266056/alex-salom\"},\"is_answered\":true,\"view_count\":7051,\"accepted_answer_id\":11047650,\"answer_count\":3,\"score\":28,\"last_activity_date\":1401541337,\"creation_date\":1339749908,\"last_edit_date\":1401541337,\"question_id\":11047351,\"link\":\"http://stackoverflow.com/questions/11047351/workaround-to-accomplish-protected-properties-in-objective-c\",\"title\":\"Workaround to accomplish protected properties in Objective-C\",\"body\":\"<p>I've been trying to find a workaround to declare @protected properties in Objective-C so only subclasses in the hierarchy can access them (read only, not write).</p>\"}],\"has_more\":false,\"quota_max\":10000,\"quota_remaining\":9994}";
static NSString * const StringIsNotJson = @"Not JSON";
static NSString * const NoQuestionsJsonString = @"{\"items=\":[]}";
static NSString * const EmptyQuestionsJsonString = @"{\"items\":[ { } ]}";

@interface QuestionBuilderTests : XCTestCase

@end

@implementation QuestionBuilderTests {
    QuestionBuilder *_questionBuilder;
    Question *_question;
}

- (void)setUp {
    [super setUp];
    _questionBuilder = [[QuestionBuilder alloc] init];
    _question = [_questionBuilder questionsFromJson:QuestionJsonString error:NULL][0];
}

- (void)tearDown {
    _questionBuilder = nil;
    _question = 0;
    [super tearDown];
}

- (void)testThatNilIsNotAcceptableParameter {
    XCTAssertThrows([_questionBuilder questionsFromJson:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJson {
    XCTAssertNil([_questionBuilder questionsFromJson:StringIsNotJson error:NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenStringIsNotJson {
    // given
    NSError *error = nil;
    
    // when
    [_questionBuilder questionsFromJson:StringIsNotJson error:&error];
    
    // then
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash {
    XCTAssertNoThrow([_questionBuilder questionsFromJson:StringIsNotJson error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJsonWithoutQuestionsArrayIsError {
    // then
    XCTAssertNil([_questionBuilder questionsFromJson:NoQuestionsJsonString error:NULL], @"No questions to parse in this JSON");
}

- (void)testRealJsonWithoutQuestionsReturnsMissingDataError {
    // given
    NSError *error = nil;
    
    // when
    [_questionBuilder questionsFromJson:NoQuestionsJsonString error:&error];
    
    // then
    XCTAssertEqual(error.code, QuestionBuilderDataError);
}

- (void)testJsonWithOneQuestionReturnsOneQuestionObject {
    // given
    NSError *error = nil;
    
    // when
    NSArray *questions = [_questionBuilder questionsFromJson:QuestionJsonString error:&error];
    
    // then
    XCTAssertEqual(questions.count, 1);
}

- (void)testQuestionCreatedFromJsonHasPropertiesPresentInJson {
    XCTAssertEqual(_question.questionId, 11047351, @"The question ID should match the data we sent");
    XCTAssertEqual(_question.date.timeIntervalSince1970, (NSTimeInterval)1339749908, @"The date of the question should match the data");
    XCTAssertEqualObjects(_question.title, @"Workaround to accomplish protected properties in Objective-C", @"Title should match provided data");
    XCTAssertEqual(_question.score, 28, @"Score should match the data");
    
    Person *owner = _question.owner;
    XCTAssertEqualObjects(owner.name, @"Alex Salom", @"Looks like I should have asked this question");
    
    XCTAssertEqualObjects(owner.avatarUrl.absoluteString, @"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209", @"The avatar URL should match the provided data");
}

- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject {
    // when
    NSArray *questions = [_questionBuilder questionsFromJson:EmptyQuestionsJsonString error:NULL];
    
    // then
    XCTAssertEqual(questions.count, 1, @"QuestionBuilder must handle partial input");
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried {
    XCTAssertThrows([_questionBuilder fillInDetailsForQuestion:_question fromJson:nil], @"Not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried {
    XCTAssertThrows([_questionBuilder fillInDetailsForQuestion:nil fromJson:QuestionJsonString], @"No reason to expect that a nil question is passed");
}

- (void)testNonJsonDataDoesNotCauseABodyToBeAddedToAQuestion {
    // when
    [_questionBuilder fillInDetailsForQuestion:_question fromJson:StringIsNotJson];
    
    // then
    XCTAssertNil(_question.body, @"Body should not have been added");
}

- (void)testJsonWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded {
    // when
    [_questionBuilder fillInDetailsForQuestion:_question fromJson:NoQuestionsJsonString];
    
    // then
    XCTAssertNil(_question.body, @"There was no body to add");
}

- (void)testBodyContainedInJsonIsAddedToQuestion {
    // when
    [_questionBuilder fillInDetailsForQuestion:_question fromJson:QuestionJsonString];
    
    // then
    XCTAssertEqualObjects(_question.body, @"<p>I've been trying to find a workaround to declare @protected properties in Objective-C so only subclasses in the hierarchy can access them (read only, not write).</p>", @"The correct question body is added");
}

- (void)testEmptyQuestionsArrayDoesNotCrash {
    XCTAssertNoThrow([_questionBuilder fillInDetailsForQuestion:_question fromJson:EmptyQuestionsJsonString], @"Don't throw if no questions are found");
}

@end
