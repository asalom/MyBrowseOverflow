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
    
    NSData *data = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parsingError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&parsingError];
    if (parsedObject == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderInvalidJsonError
                                     userInfo:nil];
        }
        return nil;
    }
    
    NSArray *questions = [parsedObject objectForKey:@"items"];
    if (questions == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderDataError
                                     userInfo:nil];
        }
        return nil;
    }
    
    return nil;
}

@end
