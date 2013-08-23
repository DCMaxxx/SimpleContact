//
//  ECNavigationBar.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 12/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCNavigationBar.h"

#import "SCSettingsTableViewController.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCNavigationBar


/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)displaySettingsOnNavigationController:(UINavigationController *)controller andDelegate:(id<SCSettingsDelegate>)delegate {
    static NSString * const VCIdSettings = @"ECSettingsViewController";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SCSettingsTableViewController * tvc = [sb instantiateViewControllerWithIdentifier:VCIdSettings];
    [tvc setDelegate:delegate];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [controller presentViewController:nc animated:YES completion:nil];
}

@end
