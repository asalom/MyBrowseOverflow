//
//  Person.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "Person.h"

@implementation Person
- (instancetype)initWithName:(NSString *)name avatarString:(NSString *)avatarString
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _avatarUrl = [NSURL URLWithString:avatarString];
    }
    return self;
}
@end
