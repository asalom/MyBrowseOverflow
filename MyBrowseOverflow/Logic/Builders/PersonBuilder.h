//
//  PersonBuilder.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 20/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface PersonBuilder : NSObject
+ (Person *)personFromDictionary:(NSDictionary *)personDictionary;
@end
