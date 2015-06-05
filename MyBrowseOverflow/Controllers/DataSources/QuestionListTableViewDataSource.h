//
//  QuestionListTableViewDataSource.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;
@class QuestionSummaryTableViewCell;
@class AvatarStore;

extern NSString * const QuestionListDidSelectQuestionNotification;

@interface QuestionListTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong) Topic *topic;
@property IBOutlet QuestionSummaryTableViewCell *questionCell;
@property (strong) AvatarStore *avatarStore;
@property UITableView *tableView;
@property (strong) NSNotificationCenter *notificationCenter;

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter;
- (void)registerForUpdatesToAvatarStore:(AvatarStore *)avatarStore;
- (void)removeObservationOfUpdatesToAvatarStore:(AvatarStore *)avatarStore;

@end
