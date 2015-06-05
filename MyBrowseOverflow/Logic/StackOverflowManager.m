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
#import "AnswerBuilder.h"
#import "Question.h"

NSString * const StackOverflowManagerError = @"StackOverflowManagerError";

@implementation StackOverflowManager

@synthesize delegate    = _delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _questionBuilder = [[QuestionBuilder alloc] init];
        _answerBuilder = [[AnswerBuilder alloc] init];
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
    self.questionNeedingBody = question;
    [self.bodyCommunicator downloadInformationForQuestionWithId:question.questionId];
}

- (void)searchingForQuestionsDidFailWithError:(NSError *)error {
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)didReceiveQuestionsJson:(NSString *)objectNotation {
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJson:objectNotation error:&error];
    
    if (!questions) {
        [self tellDelegateAboutQuestionSearchError:error];
    }
    
    else {
        [self.delegate didReceiveQuestions:questions];
    }
}

- (void)didReceiveQuestionBodyJson:(NSString *)objectNotation {
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJson: objectNotation];
    [self.delegate didReceiveBodyForQuestion:self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

- (void)fetchingQuestionBodyDidFailWithError:(NSError *)error {
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code: StackOverflowManagerErrorQuestionBodyFetchCode userInfo:errorInfo];
    [self.delegate fetchingQuestionBodyFailedWithError:reportableError];
    self.questionNeedingBody = nil;
}

- (void)fetchingAnswersDidFailWithError:(NSError *)error {
    NSAssert(NO, @"Answers unimplemented: fetchingAnswersDidFailWithError:");
}

- (void)didReceiveAnswerArrayJson:(NSString *)objectNotation {
    NSAssert(NO, @"Answers unimplemented: didReceiveAnswerArrayJson:");
}

#pragma mark Class Continuation
- (void)tellDelegateAboutQuestionSearchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError code:StackOverflowManagerErrorQuestionSearchCode userInfo: errorInfo];
    if ([self.delegate respondsToSelector:@selector(fetchingQuestionsFailedWithError:)]) {
        [self.delegate fetchingQuestionsFailedWithError:reportableError];
    }
}

@end
