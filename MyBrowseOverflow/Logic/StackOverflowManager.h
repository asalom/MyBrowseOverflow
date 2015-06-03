//
//  StackOverflowManager.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicatorDelegate.h"
@class StackOverflowCommunicator;
@class Topic;
@class QuestionBuilder;
@class AnswerBuilder;
@class Question;

extern NSString * const StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode,
    StackOverflowManagerErrorQuestionBodyFetchCode
};

@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>
@property (assign, nonatomic) id<StackOverflowManagerDelegate> delegate;
@property (strong) StackOverflowCommunicator *communicator;
@property (strong) QuestionBuilder *questionBuilder;
@property (strong) AnswerBuilder *answerBuilder;
@property (strong) Question *questionNeedingBody;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)fetchBodyForQuestion:(Question *)question;

@end
