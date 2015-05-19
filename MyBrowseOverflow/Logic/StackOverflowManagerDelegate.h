//
//  StackOverflowManagerDelegate.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

@protocol StackOverflowManagerDelegate <NSObject>

- (void)didReceiveQuestions:(NSArray *)questions;
- (void)fetchingQuestionsFailedWithError:(NSError *)error;

@end