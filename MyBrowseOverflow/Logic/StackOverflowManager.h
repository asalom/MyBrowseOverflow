//
//  StackOverflowManager.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"
@class StackOverflowCommunicator;
@class Topic;

static NSString * const StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode
};

@interface StackOverflowManager : NSObject
@property (assign, nonatomic) id<StackOverflowManagerDelegate> delegate;
@property (strong) StackOverflowCommunicator *communicator;

- (void)fetchQuestionsOnTopic:(Topic *)topic;
- (void)searchingForQuestionsFailedWithError:(NSError *)error;
@end
