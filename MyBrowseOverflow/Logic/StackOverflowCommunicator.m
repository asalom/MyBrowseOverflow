//
//  StackOverflowCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface StackOverflowCommunicator ()
@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *receivedData;
@property (strong) NSURL *fetchingUrl;
@property (strong) NSURLConnection *fetchingConnection;
@end

NSString * const StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";

static NSString * const QuestionsWithTagURL = @"http://api.stackexchange.com/2.2/questions?tagged=%@&pagesize=20&site=stackoverflow";
static NSString * const BodyFromQuestionIdURL = @"http://api.stackexchange.com/2.2/questions/%@?filter=withbody&site=stackoverflow";
static NSString * const AnswersToQuestionIdURL = @"http://api.stackexchange.com/2.2/questions/%@/answers?filter=!-*f(6t*ZdXeu&site=stackoverflow";

@implementation StackOverflowCommunicator

@synthesize receivedData = _receivedData;
@synthesize fetchingUrl = _fetchingUrl;
@synthesize fetchingConnection = _fetchingConnection;

- (void)searchForQuestionsWithTag:(NSString *)tag {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:QuestionsWithTagURL, tag]];
    [self fetchContentAtURL:url
               errorHandler:^(NSError *error) {
                   [self.delegate searchingForQuestionsDidFailWithError:error];
               }successHandler:^(NSString *objectNotiation) {
                   [self.delegate didReceiveQuestionsJson:objectNotiation];
               }];
}

- (void)downloadInformationForQuestionWithId:(NSInteger)questionId {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BodyFromQuestionIdURL, @(questionId)]];
    [self fetchContentAtURL:url
               errorHandler:^(NSError *error) {
                   [self.delegate fetchingQuestionBodyDidWithError:error];
               }successHandler:^(NSString *objectNotiation) {
                   [self.delegate didReceiveQuestionBodyJson:objectNotiation];
               }];
}

- (void)downloadAnswersToQuestionWithId:(NSInteger)questionId {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AnswersToQuestionIdURL, @(questionId)]];
    [self fetchContentAtURL:url
               errorHandler:^(NSError *error) {
                   [self.delegate fetchingAnswersDidFailWithError:error];
               }successHandler:^(NSString *objectNotiation) {
                   [self.delegate didReceiveAnswerArrayJson:objectNotiation];
               }];
}

- (NSURL *)questionsURLWithTag:(NSString *)tag {
    NSString *urlString = [NSString stringWithFormat:QuestionsWithTagURL, tag];
    return [NSURL URLWithString:urlString];
}

- (void)fetchContentAtURL:(NSURL *)url errorHandler:(void (^)(NSError *))errorBlock successHandler:(void (^)(NSString *))successBlock {
    _fetchingUrl = url;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:_fetchingUrl];
    
    [self launchConnectionForRequest:request];
}

- (void)launchConnectionForRequest:(NSURLRequest *)request {
    [self cancelAndDiscardUrlConnection];
    _fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)cancelAndDiscardUrlConnection {
    [_fetchingConnection cancel];
    _fetchingConnection = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain code:[httpResponse statusCode] userInfo:nil];
        errorHandler(error);
        [self cancelAndDiscardUrlConnection];
    }
    else {
        _receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _receivedData = nil;
    _fetchingConnection = nil;
    _fetchingUrl = nil;
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _fetchingConnection = nil;
    _fetchingUrl = nil;
    NSString *receivedText = [[NSString alloc] initWithData:_receivedData
                                                   encoding:NSUTF8StringEncoding];
    _receivedData = nil;
    successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

@end
