//
//  BCPhoneTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECModalTableViewController.h"

@class ECContact;


@interface ECPhoneTableViewController : UITableViewController < ECModalTableViewController >

@property (weak, nonatomic) ECContact * contact;
@property (weak, nonatomic) ECContactModalViewController * modalViewController;

@end
