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

static NSString * const QuestionJsonString = @"{\"items\":[{\"tags\":[\"ios\",\"iphone\",\"mobile\",\"itunesconnect\"],\"owner\":{\"reputation\":3846,\"user_id\":980344,\"user_type\":\"registered\",\"accept_rate\":53,\"profile_image\":\"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209\",\"display_name\":\"Alex Salom\",\"link\":\"http://stackoverflow.com/users/980344/velthune\"},\"is_answered\":false,\"view_count\":11,\"answer_count\":1,\"score\":2,\"last_activity_date\":1432119740,\"creation_date\":1432119146,\"last_edit_date\":1432119740,\"question_id\":30347541,\"link\":\"http://stackoverflow.com/questions/30347541/submit-test-version-on-itunesconnect\",\"title\":\"Submit test version on iTunesConnect\"}],\"has_more\":true,\"quota_max\":10000,\"quota_remaining\":9994}";
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
    XCTAssertEqual(_question.questionId, 30347541, @"The question ID should match the data we sent");
    XCTAssertEqual(_question.date.timeIntervalSince1970, (NSTimeInterval)1432119146, @"The date of the question should match the data");
    XCTAssertEqualObjects(_question.title, @"Submit test version on iTunesConnect", @"Title should match provided data");
    XCTAssertEqual(_question.score, 2, @"Score should match the data"); // changed so is not zero
    
    Person *owner = _question.owner;
    XCTAssertEqualObjects(owner.name, @"Alex Salom", @"Looks like I should have asked this question"); // changed to my name
    
    XCTAssertEqualObjects(owner.avatarUrl.absoluteString, @"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209", @"The avatar URL should match the provided data"); // changed to my avater
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

@end
