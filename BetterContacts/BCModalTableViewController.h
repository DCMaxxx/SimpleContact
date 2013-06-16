//
//  BCModalTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCContactModalViewController;
@class BCContactModalCell;
@class BCContact;

@protocol BCModalTableViewController <NSObject>

@property (weak, nonatomic) BCContactModalViewController * modalViewController;
@property (weak, nonatomic) BCContact * contact;

- (void) setFavoriteForCell:(BCContactModalCell *)cell;

@end
