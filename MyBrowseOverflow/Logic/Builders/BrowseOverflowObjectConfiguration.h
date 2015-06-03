//
//  BrowseOverflowObjectConfiguration.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 3/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StackOverflowManager;
@class AvatarStore;

@interface BrowseOverflowObjectConfiguration : NSObject

- (StackOverflowManager *)stackOverflowManager;
- (AvatarStore *)avatarStore;

@end
