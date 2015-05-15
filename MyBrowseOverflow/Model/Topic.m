//
//  Topic.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (instancetype)initWithName:(NSString *)newName tag:(NSString *)newTag;
{
    self = [super init];
    if (self) {
        _name = [newName copy];
        _tag = [newTag copy];
    }
    return self;
}

- (NSArray *)recentQuestions {
    return [NSArray array];
}

@end
