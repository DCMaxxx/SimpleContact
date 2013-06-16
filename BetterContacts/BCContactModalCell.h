//
//  BCTwoLabelsCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCModalTableViewController.h"


@interface BCContactModalCell : UITableViewCell

@property (weak, nonatomic) UITableViewController <BCModalTableViewController> * viewController;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *favorite;

- (void)isFavorite:(BOOL)favorite;

@end
