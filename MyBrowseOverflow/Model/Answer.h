//
//  Answer.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface Answer : NSObject
@property (copy) NSString *text;
@property (strong) Person *person;
@property NSInteger score;
@property (getter=isAccepted) BOOL accepted;

- (id)initWithText:(NSString *)text person:(Person *)person score:(NSInteger)score;
- (NSComparisonResult)compare:(Answer *)otherAnswer;
@end
