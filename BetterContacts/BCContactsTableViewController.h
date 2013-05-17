//
//  BCContactsTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCContactCell;
@class BCContactList;

@interface BCContactsTableViewController : UITableViewController

- (void)tappedOnPhone:(BCContactCell *)cell;
- (void)tappedOnMail:(BCContactCell *)cell;
- (void)tappedOnText:(BCContactCell *)cell;

- (void)tappedOnFavorite:(BCContactCell *)cell;
- (void)tappedOnDelete:(BCContactCell *)cell;

@end
