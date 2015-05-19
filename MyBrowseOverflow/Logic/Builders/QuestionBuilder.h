//
//  QuestionBuilder.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBuilder : NSObject
@property (copy) NSString *json;

- (NSArray *)questionsFromJson:(NSString *)objectNotation error:(NSError **)error;
@end
