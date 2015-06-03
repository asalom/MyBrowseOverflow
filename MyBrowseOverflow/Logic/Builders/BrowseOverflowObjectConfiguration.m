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
#import "AvatarStore.h"

@implementation BrowseOverflowObjectConfiguration

- (StackOverflowManager *)stackOverflowManager {
    StackOverflowManager *manager = [StackOverflowManager new];
    manager.communicator = [StackOverflowCommunicator new];
    manager.communicator.delegate = manager;
    return manager;
}

- (AvatarStore *)avatarStore {
    static AvatarStore *avatarStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avatarStore = [[AvatarStore alloc] init];
        avatarStore.notificationCenter = [NSNotificationCenter defaultCenter];
    });
    return avatarStore;
}

@end
