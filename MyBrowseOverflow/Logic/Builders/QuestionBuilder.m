//
//  QuestionBuilder.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "QuestionBuilder.h"

static NSString * const QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";

@implementation QuestionBuilder

- (NSArray *)questionsFromJson:(NSString *)objectNotation error:(NSError **)error {
    NSParameterAssert(objectNotation);
    
    //NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (error != NULL) {
        *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                     code:QuestionBuilderInvalidJsonError
                                 userInfo:nil];
    }
    return nil;
}

@end
