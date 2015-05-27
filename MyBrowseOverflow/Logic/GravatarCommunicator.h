//
//  GravatarCommunicator.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicatorDelegate.h"

@interface GravatarCommunicator : NSObject <NSURLConnectionDataDelegate>

@property (strong) NSURL *url;
@property (strong) NSMutableData *receivedData;
@property id <GravatarCommunicatorDelegate> delegate;
@property NSURLConnection *connection;

- (void)fetchDataForUrl:(NSURL *)location;

@end
