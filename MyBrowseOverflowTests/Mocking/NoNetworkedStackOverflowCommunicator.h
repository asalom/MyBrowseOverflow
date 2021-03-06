//
//  NoNetworkedStackOverflowCommunicator.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 21/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"

@interface NoNetworkedStackOverflowCommunicator : StackOverflowCommunicator

@property (copy) NSData *receivedData;

@end
