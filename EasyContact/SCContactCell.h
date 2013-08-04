//
//  BCContactCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCContact;


@interface SCContactCell : UITableViewCell

@property (weak, nonatomic) UITableViewController * viewController;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIView *leftView;

- (void)setMainViewInformationsWithContact:(SCContact *)contact;
- (void)setLeftViewInformationsWithContact:(SCContact *)contact;

@end
