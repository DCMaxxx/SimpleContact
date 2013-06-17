//
//  BCFavoriteCell.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ECFavoriteCell.h"


@implementation ECFavoriteCell

#pragma - mark Init
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIView * border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [[border layer] setBorderWidth:1.0f];
        [[border layer] setBorderColor:[[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor]];
        [[self contentView] addSubview:border];
        
        _contactPicture = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 60, 60)];
        [[self contentView] addSubview:_contactPicture];

        _contactName = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 64, 20)];
        [_contactName setTextAlignment:NSTextAlignmentCenter];
        [_contactName setFont:[[_contactName font] fontWithSize:12.0f]];
        [[self contentView] addSubview:_contactName];
    }
    return self;
}

@end
