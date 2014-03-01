//
//  AppDelegate.m
//  Bin of Parts
//
//  Created by Developer on 2/17/14.
//  Copyright (c) 2014 Bin of Parts, inc. All rights reserved.
//

#import "AppDelegate.h"
#import "PDKeychainBindings.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.122 green:0.761 blue:0 alpha:1.0]];
    [[UIApplication sharedApplication] delegate].window.tintColor = [UIColor colorWithRed:0.122 green:0.761 blue:0 alpha:1.0];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *email = [bindings objectForKey:@"email"];
    NSString *token = [bindings objectForKey:@"token"];
    NSLog(@"User Email: %@",email);
    NSLog(@"User Token: %@",token);
    if ([email length] != 0 || [token length] != 0) {
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoggedIn"];
        self.window.rootViewController = rootViewController;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
