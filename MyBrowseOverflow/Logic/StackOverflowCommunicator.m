//
//  StackOverflowCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "StackOverflowCommunicator.h"

static NSString * const QuestionsWithTagURL = @"http://api.stackexchange.com/2.2/questions?tagged=%@&pagesize=20&site=stackoverflow";
static NSString * const BodyFromQuestionIdURL = @"http://api.stackexchange.com/2.2/questions/%@?filter=withbody&site=stackoverflow";
static NSString * const AnswersToQuestionIdURL = @"http://api.stackexchange.com/2.2/questions/%@/answers?filter=!-*f(6t*ZdXeu&site=stackoverflow";

@implementation StackOverflowCommunicator

- (void)searchForQuestionsWithTag:(NSString *)tag {
    NSURL *url = [self urlFromBaseString:QuestionsWithTagURL, tag];
    [self fetchContentAtUrl:url];
}

- (void)downloadInformationForQuestionWithId:(NSInteger)questionId {
    NSURL *url = [self urlFromBaseString:BodyFromQuestionIdURL, @(questionId)];
    [self fetchContentAtUrl:url];
}

- (void)downloadAnswersToQuestionWithId:(NSInteger)questionId {
    NSURL *url = [self urlFromBaseString:AnswersToQuestionIdURL, @(questionId)];
    [self fetchContentAtUrl:url];
}

- (void)fetchBodyForQuestionWithId:(NSInteger)questionId {
    
}

- (void)fetchContentAtUrl:(NSURL *)url {
    _fetchingUrl = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:_fetchingUrl];
    [_fetchingConnection cancel];
    _fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSURL *)questionsURLWithTag:(NSString *)tag {
    NSString *urlString = [NSString stringWithFormat:QuestionsWithTagURL, tag];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)urlFromBaseString:(NSString *)baseString, ... {
    va_list args;
    va_start(args, baseString);
    NSString *urlString = [[NSString alloc] initWithFormat:baseString arguments:args];
    va_end(args);
    
    return [NSURL URLWithString:urlString];
}

- (void)cancelAndDiscardUrlConnection {
    [_fetchingConnection cancel];
    _fetchingConnection = nil;
}


@end
