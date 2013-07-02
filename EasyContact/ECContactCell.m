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

static NSUInteger kTagLowestValue = 4241;

@implementation ECContactCell

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
    NSArray * availableKinds = [ECKindHandler availableKinds];
    NSUInteger numberOfKinds = [availableKinds count];
    
    if ([_leftView tag] != kTagLowestValue) {
        [_leftView setTag:kTagLowestValue];

        CGFloat frameWidth = [_leftView frame].size.width;
        CGFloat imageSize = 28;
        CGFloat topSpacing = ([_leftView frame].size.height - imageSize) / 2;
        CGFloat spacing = (frameWidth - (numberOfKinds * imageSize)) / (numberOfKinds + 1);
        CGFloat totalSpace = 0.0f;

        for (NSUInteger i = 0; i < numberOfKinds; ++i) {
            totalSpace += spacing;
            CGRect frame = CGRectMake(totalSpace, topSpacing, imageSize, imageSize);
            totalSpace += imageSize;
            
            eContactNumberKind kind = [ECKindHandler kindFromString:[availableKinds objectAtIndex:i]];

            UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView setTag:(kTagLowestValue - kind - 1)];
            [imageView setImage:[ECKindHandler iconForKind:kind andWhite:NO]];
            [imageView setUserInteractionEnabled:YES];
            [_leftView addSubview:imageView];
        }
    }

    for (NSUInteger i = 0; i < numberOfKinds; ++i) {
        eContactNumberKind kind = [ECKindHandler kindFromString:[availableKinds objectAtIndex:i]];
        UIImageView * imageView = (UIImageView *)[_leftView viewWithTag:(kTagLowestValue - kind - 1)];
        [self setLeftViewInformationsWithContact:contact kind:kind andImageView:imageView];
    }

    
}

- (void)setLeftViewInformationsWithContact:(ECContact *)contact kind:(eContactNumberKind)kind andImageView:(UIImageView *)imageView {
    SEL selector = [ECKindHandler selectorForKind:kind prefix:@"tappedOn" andSuffix:@":"];
    

    NSUInteger nbOfContacts = [contact numberOf:kind];
    if (!nbOfContacts) {
        UIImageView * noIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unavailable-overlay.png"]];
        CGRect theFrame = [imageView frame];
        theFrame.origin.x = -3;
        theFrame.origin.y = -3;
        theFrame.size.height += 6;
        theFrame.size.width += 6;
        [noIconView setFrame:theFrame];
        [noIconView setTag:(kTagLowestValue + kind + 1)];
        [imageView addSubview:noIconView];
        if ([[imageView gestureRecognizers] count])
            [imageView removeGestureRecognizer:[[imageView gestureRecognizers] objectAtIndex:0]];
    } else {
        if ([imageView viewWithTag:(kTagLowestValue + kind + 1)])
            [[imageView viewWithTag:(kTagLowestValue + kind + 1)] removeFromSuperview];
        if (![[imageView gestureRecognizers] count]) {
            UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:_viewController action:selector];
            [imageView addGestureRecognizer:gr];
        }
    }
    
}

@end
