//
//  GravatarCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "GravatarCommunicator.h"

@implementation GravatarCommunicator

- (void)fetchDataForUrl:(NSURL *)location {
    self.url = location;
    NSURLRequest *request = [NSURLRequest requestWithURL: location];
    self.connection = [NSURLConnection connectionWithRequest: request delegate: self];
}

#pragma mark NSURLConnection Delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate communicatorReceivedData:[self.receivedData copy] forUrl:self.url];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate communicatorGotErrorForURL:self.url];
}


@end
