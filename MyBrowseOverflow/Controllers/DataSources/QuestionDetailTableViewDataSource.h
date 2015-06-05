//
//  QuestionDetailTableViewDataSource.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 5/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionDetailTableViewCell;
@class Question;
@class AvatarStore;
@class AnswerTableViewCell;

@interface QuestionDetailTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong) Question *question;
@property (strong) AvatarStore *avatarStore;
@property (weak) IBOutlet QuestionDetailTableViewCell *detailCell;
@property (weak) IBOutlet AnswerTableViewCell *answerCell;
@end
