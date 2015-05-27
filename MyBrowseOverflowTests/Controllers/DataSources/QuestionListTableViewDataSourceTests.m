//
//  QuestionListTableViewDataSourceTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "QuestionListTableViewDataSource.h"
#import "Topic.h"
#import "Question.h"
#import "Person.h"
#import "QuestionSummaryTableViewCell.h"

@interface QuestionListTableViewDataSourceTests : XCTestCase

@end

@implementation QuestionListTableViewDataSourceTests {
    QuestionListTableViewDataSource *_dataSource;
    Topic *_iPhoneTopic;
    NSIndexPath *_firstCell;
    Question *_question1, *_question2;
    Person *_owner;
}

- (void)setUp {
    [super setUp];
    _dataSource = [[QuestionListTableViewDataSource alloc] init];
    _iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    _dataSource.topic = _iPhoneTopic;
    _firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    _question1 = [[Question alloc] initWithTitle:@"Question One" date:nil score:2];
    _question2 = [[Question alloc] initWithTitle:@"Question Two" date:nil score:0];
    _owner = [[Person alloc] initWithName:@"Alex Salom" avatarUrlString:@"https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209"];
    _question1.owner = _owner;
}

- (void)tearDown {
    _dataSource = nil;
    _iPhoneTopic = nil;
    _firstCell = nil;
    _question1 = nil;
    _question2 = nil;
    _owner = nil;
    [super tearDown];
}

- (void)testTopicWithNoQuestionsLeadsToOneRowInTheTable {
    // then
    XCTAssertEqual([_dataSource tableView:nil numberOfRowsInSection:0], 1, @"The table view needs a 'no data yet' placeholder cell");
}

- (void)testTopicWithQuestionsResultsInOneRowPerQuestionInTheTable {
    // given
    [_iPhoneTopic addQuestion:_question1];
    [_iPhoneTopic addQuestion:_question2];
    
    // when & then
    XCTAssertEqual([_dataSource tableView:nil numberOfRowsInSection:0], 2, @"Two questions in the topic means two rows in the table");
}

- (void)testContentOfPlaceHolderCell {
    // given & when
    UITableViewCell *placeholderCell = [_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertEqualObjects(placeholderCell.textLabel.text, @"There was a problem connecting to the network.", @"The placeholder cell ought to display a placeholder message");
}

- (void)testPlaceholderCellNotReturnedWhenQuestionsExist {
    // given
    [_iPhoneTopic addQuestion:_question1];
    
    
    // when
    QuestionSummaryTableViewCell *cell = (QuestionSummaryTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question One", @"Question cells display the question's title");
    XCTAssertEqualObjects(cell.nameLabel.text, @"Alex Salom", @"Question cells display owner's name");
}

@end
