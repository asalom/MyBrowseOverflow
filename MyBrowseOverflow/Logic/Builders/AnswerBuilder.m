//
//  AnswerBuilder.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "AnswerBuilder.h"
#import "Question.h"
#import "Answer.h"
#import "PersonBuilder.h"

NSString * const AnswerBuilderErrorDomain = @"AnswerBuilderErrorDomain";

@implementation AnswerBuilder

- (BOOL)addAnswersToQuestion:(Question *)question fromJson:(NSString *)objectNotation error:(NSError **)error {
    NSParameterAssert(objectNotation != nil);
    NSParameterAssert(question != nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    NSDictionary *answerData = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0  error: &localError];
    if (answerData == nil) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain code: AnswerBuilderInvalidJsonError userInfo: userInfo];
        }
        return NO;
    }
    
    NSArray *answers = [answerData objectForKey: @"items"];
    if (answers == nil) {
        if (error) {
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain code:AnswerBuilderDataError userInfo: nil];
        }
        return NO;
    }
    
    for (NSDictionary *answerData in answers) {
        Answer *answer = [[Answer alloc] init];
        answer.body = [answerData objectForKey: @"body"];
        answer.accepted = [[answerData objectForKey: @"is_accepted"] boolValue];
        answer.score = [[answerData objectForKey: @"score"] integerValue];
        NSDictionary *ownerData = [answerData objectForKey: @"owner"];
        answer.person = [PersonBuilder personFromDictionary: ownerData];
        [question addAnswer:answer];
    }
    return YES;
}

@end
