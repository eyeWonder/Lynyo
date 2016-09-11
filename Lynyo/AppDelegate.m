//
//  AppDelegate.m
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <NMAKit/NMAKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize dm;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NMAApplicationContext setAppId:HERE_ID
                            appCode:HERE_CODE
                         licenseKey:HERE_LICENSEKEY];
    
    [CoreDataManager setStoreName:@"lynyo"];
    dm = [CoreDataManager sharedManager];
    
    if (![[NMAPositioningManager sharedPositioningManager] isActive])
    {
        [[NMAPositioningManager sharedPositioningManager] startPositioning];
    }


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveManagedObjectContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveManagedObjectContext];
}

-(void)saveManagedObjectContext
{
    [dm saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
        if (error) {
            NSLog(@"Unable to save changes.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }];
}


@end
