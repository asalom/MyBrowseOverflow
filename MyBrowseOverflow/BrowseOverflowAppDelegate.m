//
//  AppDelegate.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 15/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "BrowseOverflowAppDelegate.h"
#import "TopicTableViewDataSource.h"
#import "BrowseOverflowViewController.h"
#import "BrowseOverflowObjectConfiguration.h"
#import "Topic.h"

@interface BrowseOverflowAppDelegate ()
@property (readonly) NSArray *topics;
@end

@implementation BrowseOverflowAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    BrowseOverflowViewController *viewController = (BrowseOverflowViewController *)((UINavigationController *)self.window.rootViewController).topViewController;
    TopicTableViewDataSource *dataSource = [TopicTableViewDataSource new];
    dataSource.topics = self.topics;
    viewController.dataSource = dataSource;
    viewController.objectConfiguration = [BrowseOverflowObjectConfiguration new];
    return YES;
}

- (NSArray *)topics {
    return @[
             [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"],
             [[Topic alloc] initWithName:@"Cocoa Touch" tag:@"cocoa-touch"],
             [[Topic alloc] initWithName:@"UIKit" tag:@"uikit"],
             [[Topic alloc] initWithName:@"Objective-C" tag:@"objective-c"],
             [[Topic alloc] initWithName:@"Xcode" tag:@"xcode"]
             ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
