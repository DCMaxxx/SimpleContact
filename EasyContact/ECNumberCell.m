//
//  BCTwoLabelsCell.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECNumberCell.h"

#import "ECModalViewController.h"

static NSInteger const kFavoriteImageTag = 4242;


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECNumberCell

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILongPressGestureRecognizer * gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapOnNumber:)];
        [self addGestureRecognizer:gr];
    }
    return self;
}

/*----------------------------------------------------------------------------*/
#pragma mark - UIGestureRecognizerDelegate
/*----------------------------------------------------------------------------*/
- (void)longTapOnNumber:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [_viewController setFavoriteWithCell:self];
    }
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)isFavorite:(BOOL)favorite {
    NSString * const ImgFavoriteFlag = @"favorite-flag.png";

    if (favorite) {
        CGRect favoriteFrame = CGRectMake([_icon frame].size.width, 2, 10, 10);
        UIImageView * view = (UIImageView *)[[self contentView] viewWithTag:kFavoriteImageTag];
        if (!view) {
            view = [[UIImageView alloc] initWithFrame:favoriteFrame];
            [view setTag:kFavoriteImageTag];
            [[self contentView] addSubview:view];
        }
        [view setImage:[UIImage imageNamed:ImgFavoriteFlag]];
    }
    else if ([[self contentView] viewWithTag:kFavoriteImageTag])
        [(UIImageView *)[[self contentView] viewWithTag:kFavoriteImageTag] setImage:nil];
}

@end