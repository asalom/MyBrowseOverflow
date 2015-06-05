//
//  QuestionListTableViewDataSourceTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "QuestionListTableViewDataSource.h"
#import "Topic.h"
#import "Question.h"
#import "Person.h"
#import "QuestionSummaryTableViewCell.h"
#import "AvatarStore.h"

@interface AvatarStore (TestingExtensions)

@property (nonatomic, strong) NSMutableDictionary *dataCache;
@property (nonatomic, strong) NSMutableDictionary *communicators;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

- (void)setData:(NSData *)data forLocation:(NSString *)location;
- (NSUInteger)dataCacheSize;
- (NSDictionary *)communicators;
- (NSNotificationCenter *)notificationCenter;

@end

// Silence warnings
@interface QuestionListTableViewDataSource (PrivateApi)
- (void)avatarStoreDidUpdateContent:(NSNotification *)notification;
@end

@implementation AvatarStore (TestingExtensions)

@dynamic dataCache;
@dynamic communicators;
@dynamic notificationCenter;

- (void)setData:(NSData *)data forLocation:(NSString *)location {
    [self.dataCache setObject:data forKey:location];
}

- (NSUInteger)dataCacheSize {
    return [[self.dataCache allKeys] count];
}

- (NSDictionary *)communicators {
    return self.communicators;
}

@end

@interface QuestionListTableViewDataSourceTests : XCTestCase

@end

@implementation QuestionListTableViewDataSourceTests {
    QuestionListTableViewDataSource *_dataSource;
    Topic *_iPhoneTopic;
    NSIndexPath *_firstCell;
    Question *_question1, *_question2;
    Person *_owner;
    AvatarStore *_avatarStore;
    NSNotification *_receivedNotification;
}

- (void)didReceiveNotification:(NSNotification *)notification {
    _receivedNotification = notification;
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
    _avatarStore = [[AvatarStore alloc] init];
}

- (void)tearDown {
    _dataSource = nil;
    _iPhoneTopic = nil;
    _firstCell = nil;
    _question1 = nil;
    _question2 = nil;
    _owner = nil;
    _avatarStore = nil;
    _receivedNotification = nil;
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
    // given & when
    [_iPhoneTopic addQuestion:_question1];
    UITableViewCell *placeholderCell = [_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertNotEqualObjects(placeholderCell.textLabel.text, @"There was a problem connecting to the network.", @"The placeholder cell ought to display a placeholder message");
}

- (void)testCellPropertiesAreTheSameAsTheQuestion {
    // given
    [_iPhoneTopic addQuestion:_question1];
    
    // when
    QuestionSummaryTableViewCell *cell = (QuestionSummaryTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question One", @"Question cells display the question's title");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"2", @"Question cells display the question's score");
    XCTAssertEqualObjects(cell.nameLabel.text, @"Alex Salom", @"Question cells display owner's name");
}

- (void)testCellGetsImageFromAvatarStore {
    // given
    id avatarStoreMock = OCMClassMock([AvatarStore class]);
    NSURL *imageUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"Alex_Salom" withExtension:@"png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    OCMStub([avatarStoreMock dataForUrl:_question1.owner.avatarUrl]).andReturn(imageData);
    _dataSource.avatarStore = avatarStoreMock;
    [_iPhoneTopic addQuestion:_question1];
    
    // when
    QuestionSummaryTableViewCell *cell = (QuestionSummaryTableViewCell *)[_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertNotNil(cell.avatarView.image, @"The avatar store should supply the avatar images");
}

- (void)testQuestionListRegistersForAvatarNotifications {
    //given
    id mockNotificationCenter = OCMClassMock([NSNotificationCenter class]);
    _dataSource.notificationCenter = mockNotificationCenter;
    
    // when
    [_dataSource registerForUpdatesToAvatarStore:_avatarStore];
    
    // then
    OCMVerify([mockNotificationCenter addObserver:_dataSource selector:@selector(avatarStoreDidUpdateContent:) name:AvatarStoreDidUpdateContentNotification object:_avatarStore]);
}

- (void)testQuestionListStopsRegisteringForAvatarNotifications {
    //given
    id mockNotificationCenter = OCMClassMock([NSNotificationCenter class]);
    _dataSource.notificationCenter = mockNotificationCenter;
    
    // when
    [_dataSource registerForUpdatesToAvatarStore:_avatarStore];
    [_dataSource removeObservationOfUpdatesToAvatarStore:_avatarStore];
    
    // then
    OCMVerify([mockNotificationCenter removeObserver:_dataSource name:AvatarStoreDidUpdateContentNotification object:_avatarStore]);
}

- (void)testQuestionListCausesTableReloadOnAvatarNotification {
    // given
    id mockTableView = OCMClassMock([UITableView class]);
    _dataSource.tableView = mockTableView;
    
    // when
    [_dataSource avatarStoreDidUpdateContent:nil];
    
    // then
    OCMVerify([mockTableView reloadData]);
}

- (void)testHeightOfAQuestionIsAtLeastTheSameAsTheHeightOfTheCell {
    // given
    [_iPhoneTopic addQuestion:_question1];
    
    // when
    UITableViewCell *cell = [_dataSource tableView:nil cellForRowAtIndexPath:_firstCell];
    NSInteger height = [_dataSource tableView:nil heightForRowAtIndexPath:_firstCell];
    
    // then
    XCTAssertTrue(height >= cell.frame.size.height, @"Give table enough space to draw the view.");
}

@end
