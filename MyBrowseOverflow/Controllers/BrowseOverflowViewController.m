//
//  BrowseOverflowViewController.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "TopicTableViewDataSource.h"
#import "Topic.h"
#import "QuestionListTableViewDataSource.h"
#import "StackOverflowManager.h"
#import "BrowseOverflowObjectConfiguration.h"
#import "QuestionDetailTableViewDataSource.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, strong) StackOverflowManager *manager;
@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([self.dataSource class], "tableView");
    if (tableViewProperty) {
        [self.dataSource setValue:self.tableView forKey:@"tableView"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectTopicNotification:)
                                                 name:TopicTableDidSelectTopicNotification
                                               object:nil];
    if ([self.dataSource isKindOfClass:[QuestionListTableViewDataSource class]]) {
        ((QuestionListTableViewDataSource *)self.dataSource).notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectQuestionNotification:)
                                                 name:QuestionListDidSelectQuestionNotification
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.manager = [self.objectConfiguration stackOverflowManager];
    self.manager.delegate = self;
    if ([self.dataSource isKindOfClass:[QuestionListTableViewDataSource class]]) {
        Topic *selectedTopic = [(QuestionListTableViewDataSource *)self.dataSource topic];
        [self.manager fetchQuestionsOnTopic:selectedTopic];
        ((QuestionListTableViewDataSource *)self.dataSource).avatarStore = [self.objectConfiguration avatarStore];
    }
}

#pragma mark - Notification methods

- (void)userDidSelectTopicNotification:(NSNotification *)notification {
    BrowseOverflowViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseOverflowViewController"];
    QuestionListTableViewDataSource *dataSource = [[QuestionListTableViewDataSource alloc] init];
    dataSource.tableView = self.tableView;
    dataSource.topic = notification.object;
    dataSource.notificationCenter = [NSNotificationCenter defaultCenter];
    [dataSource registerForUpdatesToAvatarStore:self.objectConfiguration.avatarStore];
    newController.dataSource = dataSource;
    newController.objectConfiguration = self.objectConfiguration;
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)userDidSelectQuestionNotification: (NSNotification *)notification {
    Question *selectedQuestion = (Question *)[notification object];
    BrowseOverflowViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseOverflowViewController"];
    QuestionDetailTableViewDataSource *detailDataSource = [[QuestionDetailTableViewDataSource alloc] init];
    detailDataSource.question = selectedQuestion;
    nextViewController.dataSource = detailDataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    [[self navigationController] pushViewController:nextViewController animated: YES];
}

#pragma mark - StackOverflowManagerDelegate
// Questions
- (void)didReceiveQuestions:(NSArray *)questions {
    Topic *topic = ((QuestionListTableViewDataSource *)self.dataSource).topic;
    for (Question *question in questions) {
        [topic addQuestion:question];
    }
    [self.tableView reloadData];
}

// Questions body
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    NSAssert(NO, @"not implemented yet");
}

- (void)didReceiveBodyForQuestion:(Question *)question {
    [self.tableView reloadData];
}

@end
