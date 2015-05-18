//
//  Answer.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Answer.h"
#import "Person.h"

@implementation Answer

- (instancetype)initWithText:(NSString *)text person:(Person *)person score:(NSInteger)score
{
    self = [super init];
    if (self) {
        _text = [text copy];
        _person = person;
        _score = score;
    }
    return self;
}

- (NSComparisonResult)compare:(Answer *)otherAnswer {
    if (self.accepted && !(otherAnswer.accepted)) {
        return NSOrderedAscending;
    } else if (!self.accepted && otherAnswer.accepted){
        return NSOrderedDescending;
    }
    if (self.score > otherAnswer.score) {
        return NSOrderedAscending;
    } else if (self.score < otherAnswer.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end
