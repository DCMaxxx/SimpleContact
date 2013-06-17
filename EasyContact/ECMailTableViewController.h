//
//  BCMailTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 18/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>

#import "ECModalTableViewController.h"

@class ECContact;
@class ECContactModalViewController;


@interface ECMailTableViewController : UITableViewController < ECModalTableViewController, MFMailComposeViewControllerDelegate >

@property (weak, nonatomic) ECContact * contact;
@property (weak, nonatomic) ECContactModalViewController * modalViewController;

@end
