//
//  StackOverflowCommunicator.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowCommunicator : NSObject <NSURLConnectionDelegate> {
    @protected
    NSURL *_fetchingUrl;
    NSURLConnection *_fetchingConnection;
}

- (void)searchForQuestionsWithTag:(NSString *)tag;
- (void)downloadInformationForQuestionWithId:(NSInteger)questionId;
- (void)downloadAnswersToQuestionWithId:(NSInteger)questionId;
- (void)fetchBodyForQuestionWithId:(NSInteger)questionId;
- (void)cancelAndDiscardUrlConnection;

@end
