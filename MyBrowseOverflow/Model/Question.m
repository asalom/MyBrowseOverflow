//
//  Question.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question {
    NSMutableSet *_answerSet;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _answerSet = [NSMutableSet set];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title date:(NSDate *)date score:(NSInteger)score
{
    self = [self init];
    if (self) {
        _title = [title copy];
        _date = [date copy];
        _score = score;
    }
    return self;
}

- (void)addAnswer:(Answer *)answer {
    [_answerSet addObject:answer];
}

- (NSArray *)answers {
    return [_answerSet.allObjects sortedArrayUsingSelector:@selector(compare:)];
}

@end
