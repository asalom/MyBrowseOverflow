//
//  PersonBuilder.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 20/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "PersonBuilder.h"
#import "Person.h"

@implementation PersonBuilder

+ (Person *)personFromDictionary:(NSDictionary *)personDictionary {
    NSString *name = [personDictionary objectForKey: @"display_name"];
    NSString *avatarString = [personDictionary objectForKey:@"profile_image"];
    Person *person = [[Person alloc] initWithName: name avatarString:avatarString];
    return person;
}

@end
