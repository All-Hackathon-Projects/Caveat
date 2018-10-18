//
//  AppDelegate.m
//  CodeDay2
//
//  Created by Rahman on 5/19/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import "AppDelegate.h"
#import "SwiftySideMenuViewController.h"
#import "UIViewController+SwiftySideMenu.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //AWS Stuffs
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                    identityPoolId:@"us-east-1:d35c5618-871f-41ab-a8e9-5e814da7b6da"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    
    UIViewController *vc = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    SwiftySideMenuViewController *menuVC = (SwiftySideMenuViewController *)self.window.rootViewController;
    menuVC.centerViewController = vc;
   // [menuVC setEnableLeftSwipeGesture:NO];
    [menuVC setEnableRightSwipeGesture:NO];
    [menuVC setEnableLeftSwipeGesture:YES];
    
    
    
    UIViewController *vc2 = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"analyticsVC"];
    [menuVC setCenterEndScale:0.0];
    menuVC.leftViewController = vc2;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
