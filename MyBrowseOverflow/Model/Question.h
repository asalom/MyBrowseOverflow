//
//  Question.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
- (id)initWithTitle:(NSString *)title date:(NSDate *)date score:(NSInteger)score;

@property (readonly) NSString *title;
@property (readonly) NSDate *date;
@property (readonly) NSInteger score;
@end
