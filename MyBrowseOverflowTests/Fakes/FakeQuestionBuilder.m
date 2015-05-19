//
//  FakeQuestionBuilder.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 19/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "FakeQuestionBuilder.h"

@implementation FakeQuestionBuilder

- (NSArray *)questionsFromJson:(NSString *)objectNotation error:(NSError **)error {
    self.json = objectNotation;
    return self.arrayToReturn;
}

@end
