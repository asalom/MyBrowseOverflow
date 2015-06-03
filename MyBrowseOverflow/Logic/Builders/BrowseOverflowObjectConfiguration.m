//
//  BrowseOverflowObjectConfiguration.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 3/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowObjectConfiguration.h"
#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"

@implementation BrowseOverflowObjectConfiguration

- (StackOverflowManager *)stackOverflowManager {
    StackOverflowManager *manager = [StackOverflowManager new];
    manager.communicator = [StackOverflowCommunicator new];
    manager.communicator.delegate = manager;
    return manager;
}

@end
