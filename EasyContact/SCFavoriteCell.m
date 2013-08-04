//
//  BCFavoriteCell.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RMPhoneFormat.h"

#import "SCFavoriteCell.h"

#import "SCKindHandler.h"
#import "SCFavorite.h"
#import "SCContact.h"

@interface SCFavoriteCell ()

@property (strong, nonatomic) UIImageView * contactPicture;
@property (strong, nonatomic) UILabel * contactName;
@property (strong, nonatomic) UILabel * contactNumber;
@property (strong, nonatomic) UIImageView * kind;

@end

/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCFavoriteCell

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIView * border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [[border layer] setBorderWidth:1.0f];
        [[border layer] setBorderColor:[[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor]];
        [[self contentView] addSubview:border];
        
        _contactPicture = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 60, 60)];
        [[self contentView] addSubview:_contactPicture];
        [_contactPicture setClipsToBounds:YES];
        [_contactPicture setContentMode:UIViewContentModeScaleAspectFill];
        
        CGRect tmpFrame = [_contactPicture frame];
        tmpFrame.origin.x = 0;
        tmpFrame.origin.y = CGRectGetHeight(tmpFrame) - 10;
        tmpFrame.size.height = 10;
        UIView * bottomView = [[UIView alloc] initWithFrame:tmpFrame];
        [bottomView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
        [_contactPicture addSubview:bottomView];
        
        tmpFrame.origin.y = 1;
        tmpFrame.size.width -= 10;
        _contactNumber = [[UILabel alloc] initWithFrame:tmpFrame];
        [_contactNumber setFont:[UIFont fontWithName:@"Avenir-Light" size:10.0f]];
        [bottomView addSubview:_contactNumber];

        tmpFrame.origin.y = 0;
        tmpFrame.origin.x = CGRectGetWidth([_contactNumber frame]);
        tmpFrame.size.height = tmpFrame.size.width = 10;
        _kind = [[UIImageView alloc] initWithFrame:tmpFrame];
        [bottomView addSubview:_kind];

        _contactName = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 64, 20)];
        [_contactName setTextAlignment:NSTextAlignmentCenter];
        [_contactName setFont:[UIFont fontWithName:@"Avenir-Light" size:12.0f]];
        [[self contentView] addSubview:_contactName];
    }
    return self;
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)setInformationsWithNumber:(SCFavorite *)number {
    _number = number;
    
    SCContact * contact = [number contact];
    [_contactName setText:[contact favoriteName]];
    [_contactPicture setImage:[contact picture]];

    eContactNumberKind kind = [number kind];
    [_kind setImage:[SCKindHandler iconForKind:kind andWhite:NO]];

    RMPhoneFormat * fmt = [[RMPhoneFormat alloc] init];
    NSString * newNember = [fmt format:[number contactNumber]];
    [_contactNumber setText:newNember];
}

@end
