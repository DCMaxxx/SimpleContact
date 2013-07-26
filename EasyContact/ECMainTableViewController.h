//
//  BCContactsTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECContactCell;
@class ECContactList;


@interface ECMainTableViewController : UITableViewController

- (IBAction)displaySettings:(id)sender;
- (void)updateContacts;

@end
