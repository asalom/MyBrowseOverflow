//
//  FakeQuestionBuilder.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionBuilder.h"

@interface FakeQuestionBuilder : QuestionBuilder
@property (copy) NSString *json;
@property (copy) NSArray *arrayToReturn;
@property (copy) NSError *errorToSet;
@end
