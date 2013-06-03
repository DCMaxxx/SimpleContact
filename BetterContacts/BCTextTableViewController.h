//
//  BCTTextTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 02/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "BCModalTableViewController.h"

@class BCContact;
@class BCContactModalViewController;

@interface BCTextTableViewController : UITableViewController < BCModalTableViewController, MFMessageComposeViewControllerDelegate >

@property (weak, nonatomic) BCContact * contact;
@property (weak, nonatomic) BCContactModalViewController * modalViewController;

@end
