//
//  AvatarStoreTests.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 3/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AvatarStore.h"

@interface AvatarStoreTests : XCTestCase

@end

@implementation AvatarStoreTests {
    AvatarStore *_store;
}

- (void)setUp {
    [super setUp];
    _store = [AvatarStore new];
}

- (void)tearDown {
    _store = nil;
    [super tearDown];
}

- (void)testNilDataReturnedWhenNilUrlPassed {
    XCTAssertNil([_store dataForUrl:nil], @"Don't return data when passed a nil URL");
}

@end
