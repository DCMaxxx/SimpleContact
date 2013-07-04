//
//  BCContactCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECContact;


@interface ECContactCell : UITableViewCell

@property (weak, nonatomic) UITableViewController * viewController;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSmallNameLabel;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) UIView *leftView;


- (void)setMainViewInformationsWithContact:(ECContact *)contact;
- (void)setLeftViewInformationsWithContact:(ECContact *)contact;

@end
