//
//  BrowseOverflowViewControllerTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"
#import "Topic.h"
#import "Question.h"
#import "StackOverflowManager.h"
#import "QuestionListTableViewDataSource.h"
#import "BrowseOverflowObjectConfiguration.h"
#import "StackOverflowManagerDelegate.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) StackOverflowManager *manager;
@end

@interface BrowseOverflowViewControllerTests : XCTestCase

@end



@implementation BrowseOverflowViewControllerTests {
    BrowseOverflowViewController *_viewController;
    BrowseOverflowObjectConfiguration *_objectConfiguration;
    UITableView *_tableView;
    id<UITableViewDataSource, UITableViewDelegate> _dataSource;
    NSException *_testException;
    UINavigationController *_navigationController;
}

- (void)setUp {
    [super setUp];
    _viewController = [BrowseOverflowViewController alloc];
    _tableView = [[UITableView alloc] init];
    _viewController.tableView = _tableView;
    _dataSource = [[TopicTableViewDataSource alloc] init];
    _viewController.dataSource = _dataSource;
    _testException = [NSException exceptionWithName:@"Test exception" reason:@"Test reason" userInfo:nil];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    _objectConfiguration = [BrowseOverflowObjectConfiguration new];
    _viewController.objectConfiguration = _objectConfiguration;
}

- (void)tearDown {
    _viewController = nil;
    _dataSource = nil;
    _tableView = nil;
    _testException = nil;
    _navigationController = nil;

    [super tearDown];
}


- (void)testViewControllerHasATableViewProperty {
    // given
    objc_property_t tableViewProperty = class_getProperty([_viewController class], "tableView");
    
    // then
    XCTAssertTrue(tableViewProperty != NULL, @"BrowseOverflowViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty {
    // given
    objc_property_t dataSourceProperty = class_getProperty([_viewController class], "dataSource");
    
    // then
    XCTAssertTrue(dataSourceProperty != NULL, @"BrowseOverflowViewController needs a data source");
}

- (void)testViewControllerConnectsDataSourceInViewDidLoad {
    // given
    [_viewController view];
    
    // then
    XCTAssertEqualObjects(_tableView.dataSource, _dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad {
    // given
    [_viewController view];
    
    // then
    XCTAssertEqualObjects(_tableView.delegate, _dataSource, @"View controller should have set the table view's delegate");
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications {
    // given
    id partialMockViewController = OCMPartialMock(_viewController);
    OCMStub([partialMockViewController userDidSelectTopicNotification:[OCMArg any]]).andThrow(_testException);
    NSNotification *notification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:nil];

    // when & then
    XCTAssertNoThrow([[NSNotificationCenter defaultCenter] postNotification:notification], @"Notification should not be received before -viewDidAppear:");
}

- (void)testViewControllerReceivesTopicSelectionNotificationAfterViewDidAppear {
    // given
    id partialMockViewController = OCMPartialMock(_viewController);
    OCMStub([partialMockViewController userDidSelectTopicNotification:[OCMArg any]]);
    NSNotification *notification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:nil];
    
    // when
    [partialMockViewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // then
    OCMVerify([partialMockViewController userDidSelectTopicNotification:notification]);
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear {
    // given
    id partialMockViewController = OCMPartialMock(_viewController);
    OCMStub([partialMockViewController userDidSelectTopicNotification:[OCMArg any]]).andThrow(_testException);
    NSNotification *notification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:nil];
    
    // when
    [partialMockViewController viewDidAppear:NO];
    [partialMockViewController viewWillDisappear:NO];

    // then
    XCTAssertNoThrow([[NSNotificationCenter defaultCenter] postNotification:notification], @"After -viewWillDisappear: is called, the view controller should no longer respond to topic selection notifications");
}

- (void)testSelectingTopicPushesNewViewController {
    // given
    id mockNavigationController = OCMPartialMock(_navigationController);
    
    // when
    [_viewController userDidSelectTopicNotification:nil];
    
    // then
    OCMVerify([mockNavigationController pushViewController:[OCMArg isNotEqual:_viewController] animated:YES]);
    OCMVerify([mockNavigationController pushViewController:[OCMArg isKindOfClass:[BrowseOverflowViewController class]] animated:YES]);
}

- (void)testNewViewControllerHasAQuestionListDataSourceForTheSelectedTopic {
    // given
    Topic *iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    NSNotification *iPhoneTopicSelectedNotification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:iPhoneTopic];
    id mockNavigationController = OCMPartialMock(_navigationController);
    OCMExpect([mockNavigationController pushViewController:[OCMArg checkWithBlock:^BOOL(BrowseOverflowViewController *obj) {
        return [obj.dataSource isKindOfClass:[QuestionListTableViewDataSource class]] &&
        [[(QuestionListTableViewDataSource *)obj.dataSource topic] isEqual:iPhoneTopic];
    }] animated:YES]);
    
    // when
    [_viewController userDidSelectTopicNotification:iPhoneTopicSelectedNotification];

    // when
    OCMVerifyAll(mockNavigationController); // We should define the verify expectation here but it does not work. The block returns unpredictable objects if we verify directly here but it does work correctly if we set the expectactions beforehand
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad {
    // given
    QuestionListTableViewDataSource *questionDataSource = [QuestionListTableViewDataSource new];
    _viewController.dataSource = questionDataSource;
    
    // when
    [_viewController viewDidLoad];
    
    // then
    XCTAssertEqualObjects(questionDataSource.tableView, _tableView, @"Back-link to table view should be set in data source");
}

- (void)testSelectingTopicNotificationPassesObjectConfigurationToNewViewController {
    // given
    BrowseOverflowObjectConfiguration *objectConfiguration = [BrowseOverflowObjectConfiguration alloc];
    _viewController.objectConfiguration = objectConfiguration;
    
    id mockNavigationController = OCMPartialMock(_navigationController);
    OCMExpect([mockNavigationController pushViewController:[OCMArg checkWithBlock:^BOOL(BrowseOverflowViewController *obj) {
        return obj.objectConfiguration == _viewController.objectConfiguration;
    }] animated:YES]);
    
    // when
    [_viewController userDidSelectTopicNotification:nil];
    
    // then
    OCMVerifyAll(mockNavigationController); // We should define the verify expectation here but it does not work. The block returns unpredictable objects if we verify directly here but it does work correctly if we set the expectactions beforehand
}

- (void)testViewWillAppearOnQuestionListInitiatesALoadingOfQuestions {
    // given
    id mockManager = OCMClassMock([StackOverflowManager class]);
    id mockConfiguration = OCMClassMock([BrowseOverflowObjectConfiguration class]);
    OCMStub([mockConfiguration stackOverflowManager]).andReturn(mockManager);
    
    _viewController.objectConfiguration = mockConfiguration;
    _viewController.dataSource = [[QuestionListTableViewDataSource alloc] init];
    
    // when
    [_viewController viewWillAppear:YES];
    
    // then
    OCMVerify([mockManager fetchQuestionsOnTopic:[OCMArg any]]);
}

- (void)testViewControllerConformsToStackOverflowManagerProtocol {
    // then
    XCTAssertTrue([_viewController conformsToProtocol:@protocol(StackOverflowManagerDelegate)], @"View controllers need to be StackOverflowManagerDelegates");
}

- (void)testViewControllerConfiguredAsStackOverflowManagerDelegateOnManagerCreation {
    // when
    [_viewController viewWillAppear:YES];

    // then
    XCTAssertEqualObjects(_viewController.manager.delegate, _viewController, @"View controller sets itself as the manager's delegate");
}

- (void)testDownloadedQuestionsAreAddedToTopic {
    // given
    QuestionListTableViewDataSource *topicDataSource = [QuestionListTableViewDataSource new];
    _viewController.dataSource = topicDataSource;
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    topicDataSource.topic = topic;
    Question *question1 = [[Question alloc] init];
    
    // when
    [_viewController didReceiveQuestions:@[question1]];
    
    // then
    XCTAssertEqualObjects(topic.recentQuestions.lastObject, question1, @"Question was added to the topic");
}

@end

