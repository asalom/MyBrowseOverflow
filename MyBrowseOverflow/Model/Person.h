//
//  Person.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
- (id)initWithName:(NSString *)name avatarUrlString:(NSString *)avatarUrlString;

@property (readonly) NSString *name;
@property (readonly) NSURL *avatarUrl;
@end
