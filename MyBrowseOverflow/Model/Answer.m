//
//  Answer.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Answer.h"

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

@end
