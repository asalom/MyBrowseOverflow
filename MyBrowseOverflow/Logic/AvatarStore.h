//
//  AvatarStore.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 2/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicator.h"

extern NSString * const AvatarStoreDidUpdateContentNotification;

@interface AvatarStore : NSObject <GravatarCommunicatorDelegate>

- (NSData *)dataForUrl:(NSURL *)url;
- (void)didReceiveMemoryWarning:(NSNotification *)notification;
- (void)startUsingNotificationCenter:(NSNotificationCenter *)notificationCenter;
- (void)stopUsingNotificationCenter:(NSNotificationCenter *)notificationCenter;

@end
