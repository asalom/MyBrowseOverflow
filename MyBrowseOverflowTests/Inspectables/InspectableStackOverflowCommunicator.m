//
//  InspectableStackOverflowCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"


@interface InspectableStackOverflowCommunicator ()


@end

@implementation InspectableStackOverflowCommunicator

- (NSURL *)URLToFetch {
    return _fetchingUrl;
}

@end
