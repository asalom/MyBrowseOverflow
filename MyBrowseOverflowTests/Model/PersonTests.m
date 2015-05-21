//
//  PersonTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTests : XCTestCase

@end

@implementation PersonTests {
    Person *_person;
}

- (void)setUp {
    [super setUp];
    _person = [[Person alloc] initWithName:@"Alex Salom" avatarUrlString:@"http://example.com/avatar.png"];
}

- (void)tearDown {
    _person = nil;
    [super tearDown];
}

- (void)testThatPersonHasTheRightName {
    XCTAssertEqualObjects(_person.name, @"Alex Salom", @"Expecting a person to provide its name");
}

- (void)testThatPersonHasAnAvatarURL {
    NSURL *url = _person.avatarUrl;
    XCTAssertEqualObjects(url.absoluteString, @"http://example.com/avatar.png", @"The person's avatar should be represented by a URL");
}

@end
