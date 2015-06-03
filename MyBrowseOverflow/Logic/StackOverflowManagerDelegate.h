//
//  StackOverflowManagerDelegate.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

@class Question;

@protocol StackOverflowManagerDelegate <NSObject>

// Questions
- (void)didReceiveQuestions:(NSArray *)questions;

// Questions body
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)didReceiveBodyForQuestion:(Question *)question;

@optional
- (void)fetchingQuestionsFailedWithError:(NSError *)error;

@end