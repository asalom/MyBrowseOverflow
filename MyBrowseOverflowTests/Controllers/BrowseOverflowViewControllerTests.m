//
//  BrowseOverflowViewControllerTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"
#import <objc/runtime.h>


static const char  *NotificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";

@implementation BrowseOverflowViewController (TestNotificationDelivery)

- (void)browseOverflowControllerTests_userDidSelectTopic:(NSNotification *)notification {
    objc_setAssociatedObject(self, NotificationKey, notification, OBJC_ASSOCIATION_RETAIN);
}

@end

static const char *ViewDidAppearKey = "BrowseOverflowViewControllerTestsViewDidAppearKey";
static const char *ViewWillDisappearKey = "BrowseOverflowViewControllerTestsViewWillDisappearKey";

@implementation UIViewController (TestSuperclassCalled)
- (void)browseOverflowControllerTests_viewDidAppear:(BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, ViewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowControllerTests_viewWillDisappear:(BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, ViewWillDisappearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}
@end

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@end

@interface BrowseOverflowViewControllerTests : XCTestCase

@end



@implementation BrowseOverflowViewControllerTests {
    BrowseOverflowViewController *_viewController;
    UITableView *_tableView;
    id<UITableViewDataSource, UITableViewDelegate> _dataSource;
    SEL _realUserDidSelectTopic, _testUserDidSelectTopic;
    SEL _realViewDidAppear, _testViewDidAppear;
    SEL _realViewWillDisappear, _testViewWillDisappear;
}

- (void)setUp {
    [super setUp];
    _viewController = [BrowseOverflowViewController alloc];
    _tableView = [[UITableView alloc] init];
    _viewController.tableView = _tableView;
    _dataSource = [[TopicTableViewDataSource alloc] init];
    _viewController.dataSource = _dataSource;
    objc_removeAssociatedObjects(_viewController);
    
    _realUserDidSelectTopic = @selector(userDidSelectTopic:);
    _testUserDidSelectTopic = @selector(browseOverflowControllerTests_userDidSelectTopic:);
    
    _realViewDidAppear = @selector(viewDidAppear:);
    _testViewDidAppear = @selector(browseOverflowControllerTests_viewDidAppear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:_realViewDidAppear selector:_testViewDidAppear];
    
    _realViewWillDisappear = @selector(viewWillDisappear:);
    _testViewWillDisappear = @selector(browseOverflowControllerTests_viewWillDisappear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:_realViewWillDisappear selector:_testViewWillDisappear];
}

- (void)tearDown {
    objc_removeAssociatedObjects(_viewController);
    _viewController = nil;
    _dataSource = nil;
    _tableView = nil;
    
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:_realViewDidAppear selector:_testViewDidAppear];
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:_realViewWillDisappear selector:_testViewWillDisappear];
    [super tearDown];
}

+ (void)swapInstanceMethodsForClass:(Class)class selector:(SEL)selector1 selector:(SEL)selector2 {
    Method method1 = class_getInstanceMethod(class, selector1);
    Method method2 = class_getInstanceMethod(class, selector2);
    method_exchangeImplementations(method1, method2);
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
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:_realUserDidSelectTopic selector:_testUserDidSelectTopic];
    
    // when
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil];
    
    // then
    XCTAssertNil(objc_getAssociatedObject(_viewController, NotificationKey), @"Notification should not be received before viewDidAppear:");
    
    // clean up
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:_realUserDidSelectTopic selector:_testUserDidSelectTopic];
}

- (void)testViewControllerReceivesTopicSelectionNotificationAfterViewDidAppear {
    // given
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:_realUserDidSelectTopic selector:_testUserDidSelectTopic];
    
    // when
    [_viewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil];
    
    // then
    XCTAssertNotNil(objc_getAssociatedObject(_viewController, NotificationKey), @"After -viewDidAppear: the view controller should handle selection notifications");
    
    // clean up
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:_realUserDidSelectTopic selector:_testUserDidSelectTopic];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear {
    // when
    [_viewController viewDidAppear:NO];
    [_viewController viewWillDisappear:NO];
    
    // then
    XCTAssertNil(objc_getAssociatedObject(_viewController, NotificationKey), @"After -viewWillDisappear: is called, the view controller should no longer respond to topic selection notifications");
}

- (void)testViewControllerCallsSuperViewDidAppear {
    // when
    [_viewController viewDidAppear:NO];
    
    // then
    XCTAssertNotNil(objc_getAssociatedObject(_viewController, ViewDidAppearKey), @"-viewDidAppear: should call through to superclass implementation");
}

- (void)testViewControllerCallsSuperViewWillDisappear {
    // when
    [_viewController viewWillDisappear:NO];
    
    // then
    XCTAssertNotNil(objc_getAssociatedObject(_viewController, ViewWillDisappearKey), @"-viewWillDisappear: should call through to superclass implementation");
}

@end

