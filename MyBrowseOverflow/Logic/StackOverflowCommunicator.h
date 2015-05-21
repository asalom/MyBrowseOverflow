//
//  StackOverflowCommunicator.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

extern NSString * const StackOverflowCommunicatorErrorDomain;

@interface StackOverflowCommunicator : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSURL *_fetchingUrl;
    NSURLConnection *_fetchingConnection;
    NSMutableData *_receivedData;
    
@private
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSString *);
}

@property (assign) id<StackOverflowCommunicatorDelegate> delegate;

- (void)searchForQuestionsWithTag:(NSString *)tag;
- (void)downloadInformationForQuestionWithId:(NSInteger)questionId;
- (void)downloadAnswersToQuestionWithId:(NSInteger)questionId;
- (void)cancelAndDiscardUrlConnection;

// Factory
- (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request;

@end
