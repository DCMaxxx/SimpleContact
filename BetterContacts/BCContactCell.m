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

-(void)imgs {
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

- (void)setPictureAndNameInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    CALayer * boxLayer = [[self boxView] layer];
    if (![boxLayer borderWidth]) {
        [boxLayer setBorderWidth:1.0f];
        [boxLayer setBorderColor:[[UIColor blackColor] CGColor]];
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [[self contactNameLabel] setText:[contact getFirstName]];
    [[self contactSmallNameLabel] setText:[contact getLastName]];
    
    UIImageView * contactPicture = [self contactPicture];
    [contactPicture setImage:[contact getPicture]];
    [[self favoriteImageDefault] setImage:favoriteImg[[contact favorite]]];

}

- (void)setPhoneInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    [[self phoneImage] setImage:phoneImg[[contact getNumberOfPhoneNumbers] > 0]];
    if ([contact getNumberOfPhoneNumbers] && ![[[self phoneImage] gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnPhone = [[UITapGestureRecognizer alloc] initWithTarget:receiver action:@selector(tappedOnPhone:)];
        [[self phoneImage] addGestureRecognizer:tapOnPhone];
    } else if (![contact getNumberOfPhoneNumbers]) {
        if ([[[self phoneImage] gestureRecognizers] count])
            [[self phoneImage] removeGestureRecognizer:[[[self phoneImage] gestureRecognizers] objectAtIndex:0]];
    }
}

- (void)setMailInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    [[self mailImage] setImage:mailImg[[contact getNumberOfMailAddresses] > 0]];
    if ([contact getNumberOfMailAddresses] && ![[[self mailImage] gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnMail = [[UITapGestureRecognizer alloc] initWithTarget:receiver action:@selector(tappedOnMail:)];
        [[self mailImage] addGestureRecognizer:tapOnMail];
    } else if (![contact getNumberOfMailAddresses]) {
        if ([[[self mailImage] gestureRecognizers] count])
            [[self mailImage] removeGestureRecognizer:[[[self mailImage] gestureRecognizers] objectAtIndex:0]];
    }
}

- (void)setTextInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    [[self textImage] setImage:textImg[[contact getNumberOfMessageAddresses] > 0]];
    if ([contact getNumberOfMessageAddresses] && ![[[self textImage] gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnText = [[UITapGestureRecognizer alloc] initWithTarget:receiver action:@selector(tappedOnText:)];
        [[self textImage] addGestureRecognizer:tapOnText];
    } else if (![contact getNumberOfMessageAddresses]) {
        if ([[[self textImage] gestureRecognizers] count])
            [[self textImage] removeGestureRecognizer:[[[self textImage] gestureRecognizers] objectAtIndex:0]];
    }
    
}

- (void)setFavoriteInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    if (![[[self favoriteImage] gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnFav = [[UITapGestureRecognizer alloc] initWithTarget:receiver action:@selector(tappedOnFavorite:)];
        [[self favoriteImage] addGestureRecognizer:tapOnFav];
    }
    [[self favoriteImage] setImage:favoriteImg[[contact favorite]]];
}

- (void)setDeleteInfosWithContact:(BCContact *)contact andReceiver:(id)receiver {
    [self imgs];
    if (![[[self deleteImage] gestureRecognizers] count]) {
        UITapGestureRecognizer * tapOnDelete = [[UITapGestureRecognizer alloc] initWithTarget:receiver action:@selector(tappedOnDelete:)];
        [[self deleteImage] addGestureRecognizer:tapOnDelete];
    }  
}

@end
