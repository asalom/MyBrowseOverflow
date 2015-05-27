//
//  GravatarCommunicatorDelegate.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GravatarCommunicatorDelegate <NSObject>

- (void)communicatorReceivedData:(NSData *)data forUrl:(NSURL *)url;
- (void)communicatorGotErrorForURL:(NSURL *)url;

@end