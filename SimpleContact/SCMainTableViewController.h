//
//  BCContactsTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCSettingsDelegate.h"

@class SCContactCell;
@class SCContactList;


@interface SCMainTableViewController : UITableViewController
<
UISearchBarDelegate,
SCSettingsDelegate
>

- (void)updateContacts;
- (void)displayTutorial;
- (IBAction)displaySettings:(id)sender;

@end
