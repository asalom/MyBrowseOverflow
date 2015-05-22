//
//  FakeUrlResponse.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FakeUrlResponse.h"

@implementation FakeUrlResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode
{
    self = [super init];
    if (self) {
        _statusCode = statusCode;
    }
    return self;
}

@end
