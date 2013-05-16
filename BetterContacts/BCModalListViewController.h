//
//  BCModalListViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCModalListView.h"

@class BCContact;
@class BCImageLabelCell;

@interface BCModalListViewController : UIViewController {
    id<UITableViewDataSource,UITableViewDelegate> _delegate;
}

@property (strong, nonatomic) IBOutlet BCModalListView *view;

- (void)myInitWithType:(eModalTypeView)type andContact:(BCContact *)contact;

- (void)selectedANumber:(BCImageLabelCell *)cell;

- (UIImage *) getImageFromLabel:(NSString *)label;

@end
