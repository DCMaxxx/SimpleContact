//
//  BCTTextTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 02/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>

#import "ECModalTableViewController.h"

@class ECContact;
@class ECContactModalViewController;

@interface ECTextTableViewController : UITableViewController < ECModalTableViewController, MFMessageComposeViewControllerDelegate >

@property (weak, nonatomic) ECContact * contact;
@property (weak, nonatomic) ECContactModalViewController * modalViewController;

@end
