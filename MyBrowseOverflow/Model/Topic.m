//
//  Topic.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@implementation Topic {
    NSArray *questions;
}


- (instancetype)initWithName:(NSString *)newName tag:(NSString *)newTag;
{
    self = [super init];
    if (self) {
        _name = [newName copy];
        _tag = [newTag copy];
        questions = [[NSArray alloc] init];
    }
    return self;
}

- (void)addQuestion:(Question *)question {
    questions = [questions arrayByAddingObject:question];
}

- (NSArray *)recentQuestions {
    return questions;
}

@end
