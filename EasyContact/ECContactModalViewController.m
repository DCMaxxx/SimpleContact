//
//  BCContactModalViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RNBlurModalView.h"

#import "ECContactModalViewController.h"

#import "ECContactModalCell.h"
#import "ECContact.h"


@interface ECContactModalViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@end


@implementation ECContactModalViewController

#pragma - mark UIViewController Delegate
-(void)viewDidLoad {
    UIColor *color = [UIColor colorWithRed:0.816 green:0.788 blue:0.788 alpha:1.000];
    [[self view] setAlpha:1.0f];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[[self view] layer] setBorderColor:[color CGColor]];
    [[[self view] layer] setBorderWidth:2.0f];
    [[[self view] layer] setCornerRadius:10.0f];
    
    [_contactPicture setImage:[_contact picture]];
    [_typeImageView setImage:_typeImage];
    
    [_tableViewController setModalViewController:self];
    
    [_tableView setDelegate:_tableViewController];
    [_tableView setDataSource:_tableViewController];
}

#pragma - mark Misc function
-(UIImage *)getImageFromLabel:(NSString *)label {
    static NSMutableDictionary * dic = nil;
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[UIImage imageNamed:@"label-home.png"] forKey:@"home"];
        [dic setObject:[UIImage imageNamed:@"label-mobile.png"] forKey:@"mobile"];
        [dic setObject:[UIImage imageNamed:@"label-mobile.png"] forKey:@"iPhone"];
        [dic setObject:[UIImage imageNamed:@"label-work.png"] forKey:@"work"];
        [dic setObject:[UIImage imageNamed:@"unknown-user.png"] forKey:@"other"];
    }
    if (![dic objectForKey:label])
        return [dic objectForKey:@"other"];
    return [dic objectForKey:label];
}

-(void)hidePopup {
    UIView * view = [[self view] superview];
    if ([view isKindOfClass:[RNBlurModalView class]])
        [(RNBlurModalView *)view hideWithDuration:0 delay:0 options:0 completion:nil];
}

@end