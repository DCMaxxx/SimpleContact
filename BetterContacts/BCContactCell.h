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

// default view
@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSmallNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageDefault;
@property (weak, nonatomic) IBOutlet UIView *boxView;

// swiping view
@property (weak, nonatomic) IBOutlet UIView *swipingView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *mailImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;

// right swiping view
@property (weak, nonatomic) IBOutlet UIView *rightSwipingView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;

- (void)imgs;

- (void)setPictureAndNameInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;
- (void)setPhoneInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;
- (void)setMailInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;
- (void)setTextInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;
- (void)setFavoriteInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;
- (void)setDeleteInfosWithContact:(BCContact *)contact andReceiver:(id)receiver;

@end
