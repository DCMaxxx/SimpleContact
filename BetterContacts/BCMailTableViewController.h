//
//  BCMailTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 18/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>

#import "BCModalTableViewController.h"

@class BCContact;
@class BCContactModalViewController;

@interface BCMailTableViewController : UITableViewController < BCModalTableViewController, MFMailComposeViewControllerDelegate >

@property (weak, nonatomic) BCContact * contact;
@property (weak, nonatomic) BCContactModalViewController * modalViewController;

@end
