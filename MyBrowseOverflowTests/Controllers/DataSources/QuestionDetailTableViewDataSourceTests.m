//
//  QuestionDetailTableViewDataSourceTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 5/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "QuestionDetailTableViewDataSource.h"
#import "QuestionDetailTableViewCell.h"
#import "AnswerTableViewCell.h"
#import "Question.h"
#import "Person.h"
#import "Answer.h"
#import "AvatarStore.h"
#import <OCMock/OCMock.h>


@interface QuestionDetailTableViewDataSourceTests : XCTestCase

@end

@implementation QuestionDetailTableViewDataSourceTests {
    QuestionDetailTableViewDataSource *_dataSource;
    Question *_question;
    Answer *_answer1, *_answer2;
    Person *_owner, *_answerer;
    NSIndexPath *_questionPath, *_firstAnswerPath, *_secondAnswerPath;
    AvatarStore *_avatarStore;
    NSData *_imageData;
}

- (void)setUp {
    [super setUp];
    _dataSource = [QuestionDetailTableViewDataSource new];
    _question = [Question new];
    _question.title = @"Is this a dagger which I see before me, the handle toward my hand?";
    _question.score = 2;
    _question.body = @"<p>Come, let me clutch thee. I have thee not, and yet I see thee still. Art thou not, fatal vision, sensible to feeling as to sight?</p>";
    _answer1 = [Answer new];
    _answer1.score = 3;
    _answer1.accepted = YES;
    _answer1.body = @"<p>Yes, it is.</p>";
    _answerer = [[Person alloc] initWithName:@"Banquo" avatarUrlString:@"http://example.com/avatar"];
    _answer1.person = _answerer;
    _answer2 = [Answer new];
    _answer2.score = 4;
    _answer2.accepted = NO;
    [_question addAnswer:_answer1];
    [_question addAnswer:_answer2];
    _owner = [[Person alloc] initWithName:@"Alex Salom" avatarUrlString:@"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209"];
    _question.owner = _owner;
    _dataSource.question = _question;
    _questionPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _firstAnswerPath = [NSIndexPath indexPathForRow:0 inSection:1];
    _secondAnswerPath = [NSIndexPath indexPathForRow:1 inSection:1];
    _avatarStore = [AvatarStore new];
    NSURL *imageUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"Alex_Salom" withExtension:@"png"];
    _imageData = [NSData dataWithContentsOfURL: imageUrl];
}

- (void)tearDown {
    _dataSource = nil;
    _question = nil;
    _owner = nil;
    _answerer = nil;
    _answer1 = nil;
    _answer2 = nil;
    _questionPath = nil;
    _firstAnswerPath = nil;
    _secondAnswerPath = nil;
    _avatarStore = nil;
    _imageData = nil;
    [super tearDown];
}

- (void)testTwoSectionsInTheTableView {
    XCTAssertEqual([_dataSource numberOfSectionsInTableView:nil], 2, @"Always two sections in the table view");
}

- (void)testOneRowInTheFirstSection {
    XCTAssertEqual([_dataSource tableView:nil numberOfRowsInSection:0], 1, @"Always one row in section 0");
}

- (void)testOneRowPerAnswerInTheSecondSection {
    XCTAssertEqual([_dataSource tableView:nil numberOfRowsInSection:1], 2, @"One row per answer in section 1");
}

- (void)testQuestionPropertiesAppearInQuestionCell {
    // given
    QuestionDetailTableViewCell *cell = (QuestionDetailTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_questionPath];

    XCTAssertEqualObjects(cell.titleLabel.text, _question.title, @"Question title used as cell title");
    XCTAssertEqual([cell.scoreLabel.text integerValue], _question.score, @"Question's score should be displayed");
    XCTAssertEqualObjects(cell.personNameLabel.text, _owner.name, @"Person's name should be displayed");
}

- (void)testQuestionCellGetsImageFromAvatarStore {
    // given
    id mockAvatarStore = OCMPartialMock(_avatarStore);
    OCMStub([mockAvatarStore dataForUrl:_question.owner.avatarUrl]).andReturn(_imageData);
    _dataSource.avatarStore = mockAvatarStore;
    
    // when
    QuestionDetailTableViewCell *cell = (QuestionDetailTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_questionPath];
    
    // then
    XCTAssertNotNil(cell.avatarImageView.image, @"The avatar store should suplly the avatar images");
}

- (void)testAnswerPropertiesAppearInAnswerCell {
    AnswerTableViewCell *cell = (AnswerTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_firstAnswerPath];
    XCTAssertEqualObjects(cell.scoreLabel.text, @"3", @"Score from the first answer should appear in the score label");
}

- (void)testAcceptedLabelOnlyShownForAcceptedAnswer {
    AnswerTableViewCell *firstCell = (AnswerTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_firstAnswerPath];
    AnswerTableViewCell *secondCell = (AnswerTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_secondAnswerPath];
    XCTAssertFalse(firstCell.acceptedIndicator.hidden, @"First answer is accepted, should display that");
    XCTAssertTrue(secondCell.acceptedIndicator.hidden, @"Second answer is not accepted, don't display accepted view");
}

- (void)testQuestionRowIsAtLeastAsTallAsItsContent {
    // given
    UITableViewCell *cell = [_dataSource tableView:nil cellForRowAtIndexPath:_questionPath];
    
    // when
    CGFloat height = [_dataSource tableView:nil heightForRowAtIndexPath:_questionPath];
    
    // then
    XCTAssertTrue(height >= cell.frame.size.height, @"The question row should be at least as tall as its content");
}

- (void)testAnswerRowIsAtLeastAsTallAsItsContent {
    // given
    UITableViewCell *cell = [_dataSource tableView:nil cellForRowAtIndexPath:_firstAnswerPath];
    
    // when
    CGFloat height = [_dataSource tableView:nil heightForRowAtIndexPath:_firstAnswerPath];
    
    // then
    XCTAssertTrue(height >= cell.frame.size.height, @"The answer row should be at least as tall as its content");
}

@end
