//
//  BCContactself.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ECContactCell.h"

#import "ECSettingsHandler.h"
#import "ECContact.h"

@interface ECContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSmallNameLabel;
@property (weak, nonatomic) IBOutlet UIView *boxView;

@end

static NSUInteger const kTagLowestValue = 4241;


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECContactCell

/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)setMainViewInformationsWithContact:(ECContact *)contact {
    [_contactNameLabel setText:[contact importantName]];
    [_contactSmallNameLabel setText:[contact secondaryName]];

    if (_boxView && _contactPicture) {
        CGColorRef borderColor = [[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor];
        if (!CGColorEqualToColor([[_boxView layer] borderColor], borderColor))
            [[_boxView layer] setBorderColor:borderColor];
        [_contactPicture setImage:[contact picture]];
    }
}

- (void)setLeftViewInformationsWithContact:(ECContact *)contact {
    NSArray * availableKinds = [ECKindHandler enabledKinds];
    NSUInteger numberOfKinds = [availableKinds count];
    
    if (!_leftView) {
        CGFloat const imageSize = _boxView ? 28 : 18;
        CGFloat const spacing = 15;
        CGFloat frameWidth = (imageSize + spacing) * numberOfKinds + spacing;
        
        CGRect frame;
        frame.size.width = frameWidth;
        frame.origin.x = 320 - frameWidth;
        frame.origin.y = 0;
        frame.size.height = CGRectGetHeight(_mainView.frame);
        _leftView = [[UIView alloc] initWithFrame:frame];
        [_leftView setBackgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]];
        [_leftView setUserInteractionEnabled:YES];

        CGFloat totalSpace = 0.0f;
        CGFloat topSpacing = ([_leftView frame].size.height - imageSize) / 2;
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
        [_mainView addSubview:_leftView];
    }

    for (NSUInteger i = 0; i < numberOfKinds; ++i) {
        eContactNumberKind kind = [ECKindHandler kindFromString:[availableKinds objectAtIndex:i]];
        UIImageView * imageView = (UIImageView *)[_leftView viewWithTag:(kTagLowestValue - kind - 1)];
        [self setLeftViewInformationsWithContact:contact kind:kind andImageView:imageView];
    }

    
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc private methods
/*----------------------------------------------------------------------------*/
- (void)setLeftViewInformationsWithContact:(ECContact *)contact kind:(eContactNumberKind)kind andImageView:(UIImageView *)imageView {
    NSString * const ImgUnavalaibleOverlay = @"unavailable-overlay.png";
    SEL selector = [ECKindHandler selectorForKind:kind prefix:@"tappedOn" andSuffix:@":"];

    NSUInteger nbOfContacts = [contact numberOf:kind];
    if (!nbOfContacts) {
        UIImageView * noIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ImgUnavalaibleOverlay]];
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
