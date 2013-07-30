//
//  ECNavigationBar.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 12/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECConstantStrings.h"

#import "ECNavigationBar.h"

#import "ECSettingsTableViewController.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECNavigationBar

/*----------------------------------------------------------------------------*/
#pragma mark - UIView
/*----------------------------------------------------------------------------*/
- (void)drawRect:(CGRect)rect {
    UIImage * img = [UIImage imageNamed:ImgNavBarBg];
    [img drawInRect:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)displaySettingsOnNavigationController:(UINavigationController *)controller andDelegate:(id<ECSettingsDelegate>)delegate {
    static NSString * const VCIdSettings = @"ECSettingsViewController";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:MainStoryBoard bundle:nil];
    ECSettingsTableViewController * tvc = [sb instantiateViewControllerWithIdentifier:VCIdSettings];
    [tvc setDelegate:delegate];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [controller presentViewController:nc animated:YES completion:nil];
}

@end
