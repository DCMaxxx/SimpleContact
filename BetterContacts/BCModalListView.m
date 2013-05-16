//
//  BCModalListView.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 06/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCModalListView.h"
#import <QuartzCore/QuartzCore.h>

#import "BCContact.h"

@implementation BCModalListView

@synthesize tableView = _tableView;
@synthesize pictureType = _pictureType;
@synthesize boxView = _boxView;
@synthesize pictureContact = _pictureContact;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setStyle {
    UIColor *color = [UIColor colorWithRed:0.816 green:0.788 blue:0.788 alpha:1.000];
    [self setAlpha:1.0f];
    [self setBackgroundColor:[UIColor whiteColor]];
    [[self layer] setBorderColor:[color CGColor]];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setCornerRadius:10.0f];
    [[_boxView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[_boxView layer] setBorderWidth:1.0f];
}

- (void)setType:(eModalTypeView)type {
    if (type == MTVPhone)
        [_pictureType setImage:[UIImage imageNamed:@"telephone-black.png"]];
    else if (type == MTVMail)
        [_pictureType setImage:[UIImage imageNamed:@"email-black.png"]];
    else
        [_pictureType setImage:[UIImage imageNamed:@"sms-black.png"]];
}

- (void)setContactPic:(UIImage *)pic {
    [_pictureContact setImage:pic];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
