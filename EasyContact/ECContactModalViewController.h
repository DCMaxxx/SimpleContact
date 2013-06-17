//
//  BCContactModalViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECModalTableViewController.h"

@class ECContact;


@interface ECContactModalViewController : UIViewController

@property (weak, nonatomic) ECContact * contact;
@property (strong, nonatomic) UITableViewController < ECModalTableViewController > * tableViewController;
@property (strong, nonatomic) UIImage * typeImage;

-(UIImage *)getImageFromLabel:(NSString *)label;
-(void)hidePopup;

@end
