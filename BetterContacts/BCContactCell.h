//
//  BCContactCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCContact;

@interface BCContactCell : UITableViewCell

@property (weak, nonatomic) UITableViewController * viewController;

// Main view
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSmallNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;

// Left view
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *mailImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;

// Right view
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteSelectorImage;


- (void)setMainViewInformationsWithContact:(BCContact *)contact;
- (void)setLeftViewInformationsWithContact:(BCContact *)contact;
- (void)setRightViewInformationsWithContact:(BCContact *)contact;
- (void)updateFavoriteInformationWithContact:(BCContact *)contact;

@end
