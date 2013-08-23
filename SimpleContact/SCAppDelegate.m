//
//  BCAppDelegate.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 31/01/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

#import "SCAppDelegate.h"

#import "SCMainTableViewController.h"
#import "SCFavoritesHandler.h"
#import "SCSettingsHandler.h"
#import "SCKindHandler.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                UINavigationController * mainController = (UINavigationController *)[[self window] rootViewController];
                if ([[[mainController viewControllers] objectAtIndex:0] isKindOfClass:[SCMainTableViewController class]])
                    [(SCMainTableViewController*)[[mainController viewControllers] objectAtIndex:0] updateContacts];
            }
        });
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) ;
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Carnet d'addresse"
                                                         message:@"Vous avez refusé l'accès à votre carnet d'addresse.\
                                                         Merci de corriger le problème dans l'application Réglages, puis confidentialité."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }

    
    static NSString * const DicKeyTutorialDisplayed = @"TutorialDisplayed";
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DicKeyTutorialDisplayed]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DicKeyTutorialDisplayed];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController * mainController = (UINavigationController *)[[self window] rootViewController];
        if ([[mainController visibleViewController] isKindOfClass:[SCMainTableViewController class]])
            [mainController.visibleViewController performSelector:@selector(displayTutorial) withObject:nil afterDelay:0.0f];
    }
    
    [SCSettingsHandler loadSettings];
    
    [SCKindHandler setPossibleKinds];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[SCFavoritesHandler sharedInstance] saveModifications];
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
    [[SCFavoritesHandler sharedInstance] saveModifications];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
