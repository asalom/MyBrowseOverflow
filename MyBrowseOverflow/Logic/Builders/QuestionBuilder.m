//
//  QuestionBuilder.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "QuestionBuilder.h"
#import "PersonBuilder.h"
#import "Question.h"

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
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:questions.count];
    for (NSDictionary *parsedQuestion in questions) {
        Question *question = [[Question alloc] init];
        question.questionId = [[parsedQuestion objectForKey: @"question_id"] integerValue];
        question.date = [NSDate dateWithTimeIntervalSince1970: [[parsedQuestion objectForKey: @"creation_date"] doubleValue]];
        question.title = [parsedQuestion objectForKey: @"title"];
        question.score = [[parsedQuestion objectForKey: @"score"] integerValue];
        NSDictionary *ownerValues = [parsedQuestion objectForKey: @"owner"];
        question.owner = [PersonBuilder personFromDictionary:ownerValues];
        [results addObject: question];
    }
    return [results copy];
}

- (void)fillInDetailsForQuestion:(Question *)question fromJson:(NSString *)objectNotation {
    NSParameterAssert(question != nil);
    NSParameterAssert(objectNotation != nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: NULL];
    if (![parsedObject isKindOfClass: [NSDictionary class]]) {
        return;
    }
    NSString *questionBody = [[[parsedObject objectForKey: @"items"] lastObject] objectForKey: @"body"];
    if (questionBody) {
        question.body = questionBody;
    }
}

@end
