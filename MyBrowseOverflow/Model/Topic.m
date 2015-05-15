//
//  Topic.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@implementation Topic

@synthesize recentQuestions = _recentQuestions;

- (instancetype)initWithName:(NSString *)newName tag:(NSString *)newTag;
{
    self = [super init];
    if (self) {
        _name = [newName copy];
        _tag = [newTag copy];
        _recentQuestions = [[NSArray alloc] init];
    }
    return self;
}

- (void)addQuestion:(Question *)question {
    _recentQuestions = [_recentQuestions arrayByAddingObject:question];
}


@end
