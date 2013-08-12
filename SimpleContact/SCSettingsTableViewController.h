//
//  ECSettingsTableViewController.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 05/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCSettingsDelegate.h"
#import "SCSettingsHandler.h"


@interface SCSettingsTableViewController : UITableViewController

@property eSettingsCategory currentCategory;
@property (weak, nonatomic) id<SCSettingsDelegate> delegate;

@end
