//
//  Question.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)initWithTitle:(NSString *)title date:(NSDate *)date score:(NSInteger)score
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _date = [date copy];
        _score = score;
    }
    return self;
}

@end
