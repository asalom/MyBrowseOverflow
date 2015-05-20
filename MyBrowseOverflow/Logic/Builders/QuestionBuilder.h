//
//  QuestionBuilder.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

static NSString * const QuestionBuilderErrorDomain;

enum {
    QuestionBuilderInvalidJsonError,
    QuestionBuilderDataError
};

@interface QuestionBuilder : NSObject

- (NSArray *)questionsFromJson:(NSString *)objectNotation error:(NSError **)error;
- (void)fillInDetailsForQuestion:(Question *)question fromJson:(NSString *)objectNotation;
@end
