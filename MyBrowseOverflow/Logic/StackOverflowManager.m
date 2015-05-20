//
//  StackOverflowManager.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"
#import "Topic.h"
#import "QuestionBuilder.h"
#import "Question.h"

static NSString * const StackOverflowManagerError = @"StackOverflowManagerError";

@implementation StackOverflowManager

@synthesize delegate    = _delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _questionBuilder = [[QuestionBuilder alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<StackOverflowManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate object does not conform to the delegate protocol"
                               userInfo:nil] raise];
    }
    
    _delegate = newDelegate;
}

- (void)fetchQuestionsOnTopic:(Topic *)topic {
    [self.communicator searchForQuestionsWithTag:topic.tag];
}

- (void)fetchBodyForQuestion:(Question *)question {
    [self.communicator downloadInformationForQuestionWithId:question.questionId];
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error {
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)receivedQuestionsJson:(NSString *)objectNotation {
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJson:objectNotation error:&error];
    
    if (!questions) {
        [self tellDelegateAboutQuestionSearchError:error];
    }
    
    else {
        [self.delegate didReceiveQuestions:questions];
    }
}

#pragma mark Class Continuation
- (void)tellDelegateAboutQuestionSearchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code: StackOverflowManagerErrorQuestionSearchCode userInfo: errorInfo];
    [self.delegate fetchingQuestionsFailedWithError:reportableError];
}

@end
