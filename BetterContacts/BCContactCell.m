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
static UIImage * phoneImg = nil;
static UIImage * mailImg = nil;
static UIImage * textImg = nil;

@implementation BCContactCell

@synthesize viewController = _viewController;
@synthesize contactPicture = _contactPicture;
@synthesize contactNameLabel = _contactNameLabel;
@synthesize contactSmallNameLabel = _contactSmallNameLabel;
@synthesize phoneImage = _phoneImage;
@synthesize mailImage = _mailImage;
@synthesize textImage = _textImage;
@synthesize favoriteSelectorImage = _favoriteSelectorImage;

#pragma mark - Init
+(void)initialize {
    favoriteImg[NO] = [UIImage imageNamed:@"nofav.png"];
    favoriteImg[YES] = [UIImage imageNamed:@"fav.png"];
    phoneImg = [UIImage imageNamed:@"telephone.png"];
    mailImg = [UIImage imageNamed:@"email.png"];
    textImg = [UIImage imageNamed:@"sms.png"];
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
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfPhoneNumbers] imageToReplace:_phoneImage selectorToCall:@selector(tappedOnPhone:) image:phoneImg andTag:4242];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfMailAddresses] imageToReplace:_mailImage selectorToCall:@selector(tappedOnMail:) image:mailImg andTag:4243];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfTextAddresses] imageToReplace:_textImage selectorToCall:@selector(tappedOnText:) image:textImg andTag:4244];
}

- (void)setRightViewInformationsWithContact:(BCContact *)contact {
    [_favoriteSelectorImage setImage:favoriteImg[[contact favorite]]];
    if (![[_favoriteSelectorImage gestureRecognizers] count]) {
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:@selector(tappedOnFavorite:)];
        [_favoriteSelectorImage addGestureRecognizer:gr];
    }
}

- (void)updateFavoriteInformationWithContact:(BCContact *)contact {
    UIImage * img = favoriteImg[[contact favorite]];
    [_favoriteImage setImage:img];
    [_favoriteSelectorImage setImage:img];
}


#pragma mark - Misc private functions
- (void)setLeftViewContactInformationsWithNumberOfContacts:(NSInteger)numberOfContacts
                                            imageToReplace:(UIImageView *)imageToReplace
                                            selectorToCall:(SEL)selector
                                                     image:(UIImage *)image
                                                    andTag:(NSInteger)tag {
    [imageToReplace setImage:image];
    
    if (!numberOfContacts) {
        UIImageView * noIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-icon.png"]];
        CGRect theFrame = [imageToReplace frame];
        theFrame.origin.x = -3;
        theFrame.origin.y = -3;
        theFrame.size.height += 6;
        theFrame.size.width += 6;
        [noIconView setFrame:theFrame];
        [noIconView setTag:tag];
        [imageToReplace addSubview:noIconView];
    } else {
        if ([imageToReplace viewWithTag:tag])
            [[imageToReplace viewWithTag:tag] removeFromSuperview];
    }
    
    if (numberOfContacts && ![[imageToReplace gestureRecognizers] count]) { // contacts, but no gesture recognizer
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:selector];
        [imageToReplace addGestureRecognizer:gr];
    } else if (!numberOfContacts && [[imageToReplace gestureRecognizers] count]) { // no contacts, and a gesture recognizer
        [imageToReplace removeGestureRecognizer:[[imageToReplace gestureRecognizers] objectAtIndex:0]];
    }
}

@end
