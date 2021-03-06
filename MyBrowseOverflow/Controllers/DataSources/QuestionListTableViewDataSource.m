//
//  QuestionListTableViewDataSource.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "QuestionListTableViewDataSource.h"
#import "Topic.h"
#import "QuestionSummaryTableViewCell.h"
#import "Question.h"
#import "Person.h"
#import "AvatarStore.h"

NSString * const QuestionListDidSelectQuestionNotification = @"QuestionListDidSelectQuestionNotification";

@interface QuestionListTableViewDataSource ()


- (void)avatarStoreDidUpdateContent:(NSNotification *)notification;
@end


@implementation QuestionListTableViewDataSource

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self) {
        self.notificationCenter = notificationCenter;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topic.recentQuestions.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    
    UITableViewCell *cell = nil;
    if (self.topic.recentQuestions.count) {
        static NSString *reuseIdentifier = @"QuestionCellReuseIdentifier";
        self.questionCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!self.questionCell) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"QuestionSummaryTableViewCell"
                                                           owner:self
                                                         options:nil];
        }
        
        Question *question = self.topic.recentQuestions[indexPath.row];
        self.questionCell.nameLabel.text = question.owner.name;
        self.questionCell.titleLabel.text = question.title;
        self.questionCell.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)question.score];
        NSData *avatarData = [self.avatarStore dataForUrl:question.owner.avatarUrl];
        if (avatarData) {
            self.questionCell.avatarView.image = [UIImage imageWithData:avatarData];
        }
        
        cell = self.questionCell;
        self.questionCell = nil;
    }
    
    else {
        static NSString *reuseIdentifier = @"PlaceholderCellReuseIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        cell.textLabel.text = @"There was a problem connecting to the network.";
    }
 
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.topic.recentQuestions.count > 0) {
        NSNotification *notification = [NSNotification notificationWithName:QuestionListDidSelectQuestionNotification
                                                                     object:self.topic.recentQuestions[indexPath.row]];
        [self.notificationCenter postNotification: notification];
    }
}

- (void)registerForUpdatesToAvatarStore:(AvatarStore *)avatarStore {
    [self.notificationCenter addObserver:self selector:@selector(avatarStoreDidUpdateContent:) name:AvatarStoreDidUpdateContentNotification object:avatarStore];
}

- (void)removeObservationOfUpdatesToAvatarStore:(AvatarStore *)avatarStore {
    [self.notificationCenter removeObserver:self name:AvatarStoreDidUpdateContentNotification object:avatarStore];
}

- (void)avatarStoreDidUpdateContent:(NSNotification *)notification {
    [self.tableView reloadData];
}

@end
