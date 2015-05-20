//
//  StackOverflowCommunicator.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowCommunicator : NSObject
- (void)searchForQuestionsWithTag:(NSString *)tag;
- (void)downloadInformationForQuestionWithId:(NSInteger)questionId;


@end
