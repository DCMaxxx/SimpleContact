//
//  BCContactself.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BCContactCell.h"
#import "BCContact.h"

static UIImage * favoriteImg[2] = {nil,nil};
static UIImage * phoneImg[2] = {nil, nil};
static UIImage * mailImg[2] = {nil, nil};
static UIImage * textImg[2] = {nil, nil};

@implementation BCContactCell

@synthesize viewController = _viewController;
@synthesize contactPicture = _contactPicture;
@synthesize contactNameLabel = _contactNameLabel;
@synthesize contactSmallNameLabel = _contactSmallNameLabel;
@synthesize phoneImage = _phoneImage;
@synthesize mailImage = _mailImage;
@synthesize textImage = _textImage;
@synthesize deleteImage = _deleteImage;
@synthesize favoriteSelectorImage = _favoriteSelectorImage;


#pragma mark - Init
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if (!favoriteImg[0]) {
            favoriteImg[NO] = [UIImage imageNamed:@"nofav.png"];
            favoriteImg[YES] = [UIImage imageNamed:@"fav.png"];
            phoneImg[NO] = [UIImage imageNamed:@"no-phone.png"];
            phoneImg[YES] = [UIImage imageNamed:@"telephone.png"];
            mailImg[NO] = [UIImage imageNamed:@"no-mail.png"];
            mailImg[YES] = [UIImage imageNamed:@"email.png"];
            textImg[NO] = [UIImage imageNamed:@"no-sms.png"];
            textImg[YES] = [UIImage imageNamed:@"sms.png"];
        }
    }
    return self;
}


#pragma mark - Setting views informations
- (void)setMainViewInformationsWithContact:(BCContact *)contact {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [_contactNameLabel setText:[contact firstName]];
    [_contactSmallNameLabel setText:[contact lastName]];
    
    [_contactPicture setImage:[contact picture]];

    [_favoriteImage setImage:favoriteImg[[contact favorite]]];
}

- (void)setLeftViewInformationsWithContact:(BCContact *)contact {
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfPhoneNumbers] imageToReplace:_phoneImage selectorToCall:@selector(tappedOnPhone:) andImages:phoneImg];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfMailAddresses] imageToReplace:_mailImage selectorToCall:@selector(tappedOnMail:) andImages:mailImg];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfTextAddresses] imageToReplace:_textImage selectorToCall:@selector(tappedOnText:) andImages:textImg];
}

- (void)setRightViewInformationsWithContact:(BCContact *)contact {
    [_favoriteSelectorImage setImage:favoriteImg[[contact favorite]]];
    if (![[_favoriteSelectorImage gestureRecognizers] count]) {
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:@selector(tappedOnFavorite:)];
        [_favoriteSelectorImage addGestureRecognizer:gr];
    }

    if (![[_deleteImage gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnDelete = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:@selector(tappedOnDelete:)];
        [_deleteImage addGestureRecognizer:tapOnDelete];
    }
}


#pragma mark - Misc private functions
- (void)setLeftViewContactInformationsWithNumberOfContacts:(NSInteger)numberOfContacts
                                            imageToReplace:(UIImageView *)imageToReplace
                                            selectorToCall:(SEL)selector
                                                 andImages:(UIImage * __strong [2])images {
    [imageToReplace setImage:images[numberOfContacts > 0]];
    if (numberOfContacts && ![[imageToReplace gestureRecognizers] count]) { // contacts, but no gesture recognizer
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:selector];
        [imageToReplace addGestureRecognizer:gr];
    } else if (!numberOfContacts && [[imageToReplace gestureRecognizers] count]) { // no contacts, and a gesture recognizer
        [imageToReplace removeGestureRecognizer:[[imageToReplace gestureRecognizers] objectAtIndex:0]];
    }
}

@end
