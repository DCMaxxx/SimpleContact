//
//  BCTwoLabelsCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECModalTableViewController.h"


@interface ECContactModalCell : UITableViewCell

@property (weak, nonatomic) UITableViewController <ECModalTableViewController> * viewController;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) NSString * originalNumber;

- (void)isFavorite:(BOOL)favorite;

@end
