//
//  BCPhoneTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCModalTableViewController.h"

@class BCContact;

@interface BCPhoneTableViewController : UITableViewController < BCModalTableViewController >

@property (weak, nonatomic) BCContact * contact;
@property (weak, nonatomic) BCContactModalViewController * modalViewController;

@end
