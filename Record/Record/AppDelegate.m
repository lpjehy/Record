//
//  AppDelegate.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

#import "LaunchView.h"


#import "ReminderManager.h"
#import "NotifyManager.h"
#import "RefillManager.h"
#import "RecordData.h"

#import "AudioManager.h"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate



- (void)createLayout {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    
    
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.window.rootViewController = mainNavigationController;
    
    [self.window makeKeyAndVisible];
    
    [LaunchView show];
    
}


#pragma mark - UIApplicationDelegate

- (void)dealLaunchOptions:(NSDictionary *)launchOptions
{
    NSLog(@"dealLaunchOptions");
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self dealLocalNotification:notification];
    }
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AppManager Initialize];
    
    
    
    
    [self createLayout];
    
    
    [self dealLaunchOptions:launchOptions];
    
    //[ReminderManager checkNotifications];
    
    /*
    for (NSString *name in [UIFont familyNames]) {
        NSLog(@"name ：%@", name);
        for (NSString *subname in [UIFont fontNamesForFamilyName:name]) {
            NSLog(@"subname ：%@", subname);
        }
        
    }
     */
    
    return YES;
}

/*
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([shortcutItem.type isEqualToString:@"takepill"]) {
        [RecordManager record:[NSDate date]];
 
    } else {
        [RecordManager deleteRecord:[NSDate date]];
    }
    
    [ReminderManager resetNotify];
}

 */


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
    
    
    
    [AppManager Update];
    
    [RefillManager showRemindRefill];
    
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark Notification

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings %@", notificationSettings.description);
    
    [NotifyManager setDidRegisterUserNotificationSettings];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DidRegisterUserNotificationSettingsNotification
                                                        object:nil];
    
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
    NSLog(@"didReceiveLocalNotification %@", notification.alertBody);
    
    application.applicationIconBadgeNumber = 0;
    
    [self dealLocalNotification:notification];
}


- (void)dealLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"dealLocalNotification");
    
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        NSString *type = [notification.userInfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if ([type isEqualToString:LocalNotificationTypeTakePill]
            || [type isEqualToString:LocalNotificationTypeTakePillSpecial]
            || [type isEqualToString:LocalNotificationTypeSnooze]) {
            
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                NSString *record = [RecordData selectRecord:[NSDate date]];
                if (record == nil) {
                    
                    NSString *soundName = [ReminderManager notifySound];
                    [[AudioManager getInstance] playWithFilename:soundName];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:notification.alertBody
                                                                   delegate:self
                                                          cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                          otherButtonTitles:LocalizedString(@"button_title_take"), nil];
                    [alert show];
                }
                
                
            } else {
                
            }
            
            
        } else if ([type isEqualToString:LocalNotificationTypeRefill]) {
            
            [RefillManager showRemindRefill];
        }
        
    } else {
        if (![AppManager hasFirstOpenedByReminder]) {
            [AppManager setFirstOpeningByReminder:YES];
            [AppManager setFirstOpenedByReminder];
        }
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:LocalizedString(@"button_title_take")]) {
        [RecordData record:[NSDate date]];
        
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CheckSnoozeNotification object:nil];
    }
    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "aaa.Record" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Record" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Record.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
