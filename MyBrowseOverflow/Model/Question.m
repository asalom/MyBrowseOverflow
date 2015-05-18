//
//  Question.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question

@synthesize answers     = _answers;

- (id)initWithTitle:(NSString *)title date:(NSDate *)date score:(NSInteger)score
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _date = [date copy];
        _score = score;
        _answers = [NSArray array];
    }
    return self;
}

- (void)addAnswer:(Answer *)answer {
    _answers = [_answers arrayByAddingObject:answer];
}

- (NSArray *)answers {
    return [_answers sortedArrayUsingSelector:@selector(compare:)];
}

@end
