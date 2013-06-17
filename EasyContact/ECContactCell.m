//
//  BCContactself.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ECContactCell.h"

#import "ECContact.h"

enum eImageTypeTag { eITTPhone = 4242, eITTMail, eITTText };

static UIImage * phoneImg = nil;
static UIImage * mailImg = nil;
static UIImage * textImg = nil;
static UIImage * unavailableImg = nil;


@implementation ECContactCell

#pragma - mark Init
+(void)initialize {
    phoneImg = [UIImage imageNamed:@"phone-white.png"];
    mailImg = [UIImage imageNamed:@"mail-white.png"];
    textImg = [UIImage imageNamed:@"text-white.png"];
    unavailableImg = [UIImage imageNamed:@"unavailable-overlay.png"];
}

#pragma - mark Setting views informations
- (void)setMainViewInformationsWithContact:(ECContact *)contact {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGColorRef borderColor = [[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor];
    if (!CGColorEqualToColor([[_boxView layer] borderColor], borderColor))
        [[_boxView layer] setBorderColor:borderColor];
    
    [_contactNameLabel setText:[contact firstName]];
    [_contactSmallNameLabel setText:[contact lastName]];
    
    [_contactPicture setImage:[contact picture]];
}

- (void)setLeftViewInformationsWithContact:(ECContact *)contact {
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfPhoneNumbers] imageToReplace:_phoneImage selectorToCall:@selector(tappedOnPhone:) image:phoneImg andTag:eITTPhone];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfMailAddresses] imageToReplace:_mailImage selectorToCall:@selector(tappedOnMail:) image:mailImg andTag:eITTMail];
    [self setLeftViewContactInformationsWithNumberOfContacts:[contact numberOfTextAddresses] imageToReplace:_textImage selectorToCall:@selector(tappedOnText:) image:textImg andTag:eITTText];
}


#pragma - mark Misc private functions
- (void)setLeftViewContactInformationsWithNumberOfContacts:(NSInteger)numberOfContacts
                                            imageToReplace:(UIImageView *)imageToReplace
                                            selectorToCall:(SEL)selector
                                                     image:(UIImage *)image
                                                    andTag:(NSInteger)tag {
    [imageToReplace setImage:image];
    
    if (!numberOfContacts) {
        UIImageView * noIconView = [[UIImageView alloc] initWithImage:unavailableImg];
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
