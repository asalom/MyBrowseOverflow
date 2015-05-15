//
//  Topic.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Question;

@interface Topic : NSObject
- (id)initWithName:(NSString *)newName tag:(NSString *)newTag;
- (void)addQuestion:(Question *)question;

@property (readonly) NSString *name;
@property (readonly) NSString *tag;
@property (readonly) NSArray *recentQuestions;
@end
