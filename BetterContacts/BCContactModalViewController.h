//
//  BCContactModalViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCModalTableViewController.h"

@class BCContact;

@interface BCContactModalViewController : UIViewController

@property (weak, nonatomic) BCContact * contact;
@property (strong, nonatomic) UITableViewController < BCModalTableViewController > * tableViewController;
@property (strong, nonatomic) UIImage * typeImage;

-(UIImage *)getImageFromLabel:(NSString *)label;
-(void)hidePopup;

@end
