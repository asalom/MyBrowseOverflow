//
//  Topic.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

static NSUInteger const MAXIMUM_NUMBER_OF_QUESTIONS = 20;

@implementation Topic {
    NSArray *_questions;
}


- (instancetype)initWithName:(NSString *)newName tag:(NSString *)newTag;
{
    self = [super init];
    if (self) {
        _name = [newName copy];
        _tag = [newTag copy];
        _questions = [[NSArray alloc] init];
    }
    return self;
}

- (void)addQuestion:(Question *)question {
    NSArray *newQuestions = [_questions arrayByAddingObject:question];
    if (newQuestions.count > MAXIMUM_NUMBER_OF_QUESTIONS) {
        newQuestions = [self sortQuestionsLatestFirst:newQuestions];
        newQuestions = [newQuestions subarrayWithRange:NSMakeRange(0, MAXIMUM_NUMBER_OF_QUESTIONS)];
    }
    
    _questions = newQuestions;
}

- (NSArray *)recentQuestions {
    return [self sortQuestionsLatestFirst:_questions];
}

- (NSArray *)sortQuestionsLatestFirst:(NSArray *)questionList {
    return [questionList sortedArrayUsingComparator:^(Question *question1, Question *question2) {
        return [question2.date compare:question1.date];
    }];
}

@end
