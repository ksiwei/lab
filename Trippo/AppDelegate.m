//
//  AppDelegate.m
//  Trippo
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

NSString * APP_SHARE_GROUP = @"group.trippo";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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


- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    NSString *STATIC_FILE_HANDLE = @"file://";
    //If app is opened from share extension, do the following
    /*
     1.) Get path of shared file from NSUserDefaults
     2.) Get data from file and store in some variable
     3.) Create a new accesible unique file path
     4.) Dump data created into this file.
     */
    
    NSString *path=url.path;

    NSLog(@"hiiiit");
    
    NSData *data;
    //Get file path from url shared
    NSString * newFilePathConverted = [STATIC_FILE_HANDLE stringByAppendingString:path];
    url = [ NSURL URLWithString: newFilePathConverted ];

    data = [NSData dataWithContentsOfURL:url];
    //Create a regular access path because this app cant preview a shared app group path
    /*
     NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:APP_SHARE_GROUP];

    NSString *regularAccessPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    //Copy file to a jpg image(ignore extension, will convert from png)
    NSString *uniqueFilePath= [ NSString stringWithFormat: @"/image%@.jpg", uuid];
    regularAccessPath = [regularAccessPath stringByAppendingString:uniqueFilePath];
    NSString * newFilePathConverted1 = [STATIC_FILE_HANDLE stringByAppendingString:regularAccessPath];
    url = [ NSURL URLWithString: newFilePathConverted1 ];
    //Dump existing shared file path data into newly created file.
    [data writeToURL:url atomically:YES];
    //Reset NSUserDefaults to Nil once file is copied.
    [defaults setObject:nil forKey:@"url"];
    */
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController=[storyboard instantiateViewControllerWithIdentifier:@"VIEW_CTLR"];
    [viewController configureWithImage:data];

    [self.window.rootViewController.navigationController pushViewController:viewController animated:YES];
    */
    
    ViewController *root = (ViewController *)self.window.rootViewController;
    [root configureWithImage:data];
    //Do what you want
    
    return YES;
}
@end
