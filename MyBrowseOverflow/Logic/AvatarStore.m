//
//  AvatarStore.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 2/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "AvatarStore.h"
#import "GravatarCommunicator.h"
#import <UIKit/UIKit.h>

NSString * const AvatarStoreDidUpdateContentNotification = @"AvatarStoreDidUpdateContentNotification";

@interface AvatarStore ()
@property (nonatomic, strong) NSMutableDictionary *dataCache;
@property (nonatomic, strong) NSMutableDictionary *communicators;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@end

@implementation AvatarStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataCache = [NSMutableDictionary new];
        _communicators = [NSMutableDictionary new];
    }
    return self;
}

- (NSData *)dataForUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    NSData *avatarData = _dataCache[url.absoluteString];
    if (!avatarData) {
        GravatarCommunicator *communicator = [GravatarCommunicator new];
        self.communicators[url.absoluteString] = communicator;
        communicator.delegate = self;
        [communicator fetchDataForUrl:url];
    }
    return avatarData;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [self.dataCache removeAllObjects];
}

- (void)startUsingNotificationCenter:(NSNotificationCenter *)notificationCenter {
    [notificationCenter addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    self.notificationCenter = notificationCenter;
}
- (void)stopUsingNotificationCenter:(NSNotificationCenter *)notificationCenter {
    [notificationCenter removeObserver:self];
    self.notificationCenter = nil;
}

#pragma mark - GravatarCommunicatorDelegate
- (void)communicatorReceivedData:(NSData *)data forUrl:(NSURL *)url {
    self.dataCache[url.absoluteString] = data;
    [self.communicators removeObjectForKey:url.absoluteString];
    NSNotification *notification = [NSNotification notificationWithName:AvatarStoreDidUpdateContentNotification object:self];
    [self.notificationCenter postNotification:notification];
}

- (void)communicatorGotErrorForURL:(NSURL *)url {
    [self.communicators removeObjectForKey:url.absoluteString];
}

@end
