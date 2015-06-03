//
//  StackOverflowCommunicatorDelegate.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StackOverflowCommunicatorDelegate <NSObject>

- (void)searchingForQuestionsDidFailWithError:(NSError *)error;
- (void)fetchingQuestionBodyDidFailWithError:(NSError *)error;
- (void)fetchingAnswersDidFailWithError:(NSError *)error;

- (void)didReceiveQuestionsJson:(NSString *)objectNotation;
- (void)didReceiveAnswerArrayJson:(NSString *)objectNotation;
- (void)didReceiveQuestionBodyJson:(NSString *)objectNotation;

@end
