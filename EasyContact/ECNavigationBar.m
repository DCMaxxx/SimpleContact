//
//  ECNavigationBar.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 12/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECNavigationBar.h"

#import "ECSettingsTableViewController.h"

@implementation ECNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"navigationbar-background.png"] forBarMetrics:UIBarMetricsDefault];
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage * img = [UIImage imageNamed:@"navigationbar-background.png"];
    [img drawInRect:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
}

- (void)displaySettingsOnNavigationController:(UINavigationController *)controller {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ECSettingsTableViewController * tvc = [sb instantiateViewControllerWithIdentifier:@"ECSettingsViewController"];;
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [controller presentViewController:nc animated:YES completion:nil];
}

@end
