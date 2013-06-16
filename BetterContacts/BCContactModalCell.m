//
//  BCTwoLabelsCell.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCContactModalCell.h"

static UIImage * favoriteImage;

@implementation BCContactModalCell

+ (void)initialize {
    favoriteImage = [UIImage imageNamed:@"fav.png"];
}

@synthesize viewController = _viewController;

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILongPressGestureRecognizer * gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapOnNumber:)];
        [self addGestureRecognizer:gr];
    }
    return self;
}

- (void) longTapOnNumber :(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [[self viewController] setFavoriteForCell:self];
    }
}

- (void)isFavorite:(BOOL)favorite {
    if (favorite)
        [_favorite setImage:favoriteImage];
    else
        [_favorite setImage:nil];
}


@end
