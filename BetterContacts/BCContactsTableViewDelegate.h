//
//  BCContactsTableViewDelegate.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 31/01/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCContact;
@class BCContactCell;
@class BCContactList;
@class BCViewController;

@interface BCContactsTableViewDelegate : NSObject < UITableViewDataSource,
UITableViewDelegate> {
    BCContactCell * _swipedCell;
    BCContactList * _contacts;
}

@property (strong, nonatomic) UITableView * view;
@property (strong, nonatomic) BCViewController * viewController;

- (void)displayContactButtonsOfCell:(BCContactCell *)cell;
- (void)displayOtherButtonsOfCell:(BCContactCell *)cell;
- (void)unselectCell:(BCContactCell *)cell;

- (BCContact *) getContactFromContactCell: (BCContactCell *)cell;

@end
