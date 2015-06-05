//
//  QuestionDetailTableViewDataSource.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 5/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "QuestionDetailTableViewDataSource.h"
#import "QuestionDetailTableViewCell.h"
#import "Question.h"
#import "Person.h"
#import "Answer.h"
#import "AvatarStore.h"
#import "AnswerTableViewCell.h"

NS_ENUM(NSInteger, Section) {
    SectionQuestion = 0,
    SectionAnswer = 1,
    SectionCount
};

@implementation QuestionDetailTableViewDataSource

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionQuestion) {
        return 340.0f;
    }
    return 301.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.question.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == SectionQuestion) {
        [[NSBundle bundleForClass: [self class]] loadNibNamed:@"QuestionDetailTableViewCell" owner:self options:nil];
        [self.detailCell.bodyWebView loadHTMLString:[self htmlStringForSnippet:self.question.body] baseURL:nil];
        self.detailCell.titleLabel.text = self.question.title;
        self.detailCell.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.question.score];
        self.detailCell.personNameLabel.text = self.question.owner.name;
        self.detailCell.avatarImageView.image = [UIImage imageWithData:[self.avatarStore dataForUrl: self.question.owner.avatarUrl]];
        cell = self.detailCell;
        self.detailCell = nil;
    }
    else if (indexPath.section == SectionAnswer) {
        Answer *thisAnswer = [self.question.answers objectAtIndex: indexPath.row];
        [[NSBundle bundleForClass: [self class]] loadNibNamed:@"AnswerTableViewCell" owner:self options:nil];
        self.answerCell.scoreLabel.text = [NSString stringWithFormat: @"%ld", (long)thisAnswer.score];
        self.answerCell.acceptedIndicator.hidden = !thisAnswer.accepted;
        Person *answerer = thisAnswer.person;
        self.answerCell.personName.text = answerer.name;
        self.answerCell.personAvatar.image = [UIImage imageWithData:[self.avatarStore dataForUrl: answerer.avatarUrl]];
        [self.answerCell.bodyWebView loadHTMLString:[self htmlStringForSnippet:thisAnswer.body] baseURL:nil];
        cell = self.answerCell;
        self.answerCell = nil;
    }
    else {
        NSParameterAssert(indexPath.section < SectionCount);
    }
    return cell;
}

#pragma mark - Private
- (NSString *)htmlStringForSnippet:(NSString *)snippet {
    return [NSString stringWithFormat: @"<html><head></head><body>%@</body></html>", snippet];
}

@end
