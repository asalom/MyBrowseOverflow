//
//  FakeUrlResponse.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeUrlResponse : NSObject
@property NSInteger statusCode;
- (id)initWithStatusCode:(NSInteger)statusCode;
@end
