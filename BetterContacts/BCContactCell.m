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
@synthesize boxView = _boxView;
@synthesize contactNameLabel = _contactNameLabel;
@synthesize contactSmallNameLabel = _contactSmallNameLabel;
@synthesize phoneImage = _phoneImage;
@synthesize mailImage = _mailImage;
@synthesize textImage = _textImage;

#pragma - mark Init
+(void)initialize {
    favoriteImg[NO] = [UIImage imageNamed:@"nofav.png"];
    favoriteImg[YES] = [UIImage imageNamed:@"fav.png"];
    phoneImg = [UIImage imageNamed:@"telephone.png"];
    mailImg = [UIImage imageNamed:@"email.png"];
    textImg = [UIImage imageNamed:@"sms.png"];
}

#pragma - mark Setting views informations
- (void)setMainViewInformationsWithContact:(BCContact *)contact {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGColorRef borderColor = [[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor];
    if (!CGColorEqualToColor([[_boxView layer] borderColor], borderColor))
        [[_boxView layer] setBorderColor:borderColor];
    
    [_contactNameLabel setText:[contact firstName]];
    [_contactSmallNameLabel setText:[contact lastName]];
    
    [_contactPicture setImage:[contact picture]];
}

- (void)setLeftViewInformationsWithContact:(BCContact *)contact {
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfPhoneNumbers] imageToReplace:_phoneImage selectorToCall:@selector(tappedOnPhone:) image:phoneImg andTag:4242];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfMailAddresses] imageToReplace:_mailImage selectorToCall:@selector(tappedOnMail:) image:mailImg andTag:4243];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfTextAddresses] imageToReplace:_textImage selectorToCall:@selector(tappedOnText:) image:textImg andTag:4244];
}


#pragma - mark Misc private functions
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
        if ([[imageToReplace gestureRecognizers] count])
            [imageToReplace removeGestureRecognizer:[[imageToReplace gestureRecognizers] objectAtIndex:0]];
    } else {
        if ([imageToReplace viewWithTag:tag])
            [[imageToReplace viewWithTag:tag] removeFromSuperview];
        if (![[imageToReplace gestureRecognizers] count]) {
            UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:selector];
            [imageToReplace addGestureRecognizer:gr];
        }
    }
}

@end
