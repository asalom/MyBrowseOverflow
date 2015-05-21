//
//  NoNetworkedStackOverflowCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "NoNetworkedStackOverflowCommunicator.h"

@implementation NoNetworkedStackOverflowCommunicator

- (void)setReceivedData:(NSData *)data {
    _receivedData = [data mutableCopy];
}

- (NSData *)receivedData {
    return [_receivedData copy];
}

@end
