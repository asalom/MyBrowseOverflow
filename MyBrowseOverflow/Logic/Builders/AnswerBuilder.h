//
//  AnswerBuilder.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

extern NSString * const AnswerBuilderErrorDomain;

enum {
    AnswerBuilderInvalidJsonError,
    AnswerBuilderDataError
};


@interface AnswerBuilder : NSObject

- (BOOL)addAnswersToQuestion:(Question *)question fromJson:(NSString *)objectNotation error:(NSError **)error;

@end
