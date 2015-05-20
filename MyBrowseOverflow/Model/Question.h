//
//  Question.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Answer;
@class Person;

@interface Question : NSObject
- (id)initWithTitle:(NSString *)title date:(NSDate *)date score:(NSInteger)score;
- (void)addAnswer:(Answer *)answer;

@property NSInteger questionId;
@property (copy) NSString *title;
@property (copy) NSDate *date;
@property NSInteger score;
@property (nonatomic, strong) NSArray *answers;
@property (strong) Person *owner;
@property (copy) NSString *body;
@end
