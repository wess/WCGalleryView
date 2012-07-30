//
//  WCAppDelegate.m
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "WCAppDelegate.h"
#import "WCGalleryView.h"

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController *controller    = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    
    NSArray *kittens = @[
        [UIImage imageNamed:@"200.jpeg"],
        [UIImage imageNamed:@"200.jpeg"],
        [UIImage imageNamed:@"200.jpeg"],
        [UIImage imageNamed:@"200.jpeg"],
        [UIImage imageNamed:@"200.jpeg"]];
    
    WCGalleryView *galleryView      = [[WCGalleryView alloc] initWithImages:kittens frame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    galleryView.backgroundColor     = [UIColor blueColor];
    galleryView.center              = controller.view.center;
    galleryView.borderColor         = [UIColor whiteColor];
    galleryView.borderWidth         = 3.0f;
    galleryView.shadowColor         = [UIColor blackColor];
    galleryView.shadowOffset        = CGSizeMake(1.0f, 2.0f);
    galleryView.shadowOpacity       = 0.5f;
    galleryView.shadowRadius        = 2.0f;
    galleryView.stackRadiusOffset   = 9.0f;
    galleryView.animationDuration   = 0.3f;
    galleryView.stackRadiusDirection = WCGalleryStackRadiusRandom;
    galleryView.animationType        = WCGalleryAnimationCurl;
    
    [controller.view addSubview:galleryView];

    galleryView.animationDuration = 0.5f;
    
//    [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//    [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//    [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(3);
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"Adding additional Image");
//            galleryView.animationDuration = 0.5f;
//            
//            [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//            [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//            [galleryView addImage:[UIImage imageNamed:@"200.jpeg"] animated:YES];
//        });
//    });
    
    
    self.window.rootViewController  = controller;
    self.window.backgroundColor     = [UIColor darkGrayColor];
    [self.window makeKeyAndVisible];
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
