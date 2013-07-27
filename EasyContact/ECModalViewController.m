//
//  BCContactModalViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RNBlurModalView.h"
#import "RMPhoneFormat.h"

#import "ECModalViewController.h"

#import "ECNumberCell.h"
#import "ECContactJoiner.h"
#import "ECContact.h"


@interface ECModalViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) ECContactJoiner * joiner;

@end


@implementation ECModalViewController

#pragma - mark Init
-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _joiner = [[ECContactJoiner alloc] init];
    }
    return self;
}


#pragma - mark UIViewController Delegate
-(void)viewDidLoad {
    UIColor *color = [UIColor colorWithRed:0.816 green:0.788 blue:0.788 alpha:1.000];
    [[self view] setAlpha:1.0f];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[[self view] layer] setBorderColor:[color CGColor]];
    [[[self view] layer] setBorderWidth:2.0f];
    [[[self view] layer] setCornerRadius:10.0f];
    
    [[_borderView layer] setBorderColor:[[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f] CGColor]];

    [_contactPicture setImage:[_contact picture]];
    [_typeImageView setImage:[ECKindHandler iconForKind:_kind andWhite:NO]];

}


#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOf:_kind];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    ECNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    [cell setTag:index];
    
    if (![cell viewController])
        [cell setViewController:self];
    
    NSDictionary * dic = [[_contact addessesOf:_kind] objectAtIndex:index];
    
    BOOL isFavorite = [(NSNumber *)[dic objectForKey:@"favorite"] boolValue];
    [cell isFavorite:isFavorite];

    NSString *label = [dic objectForKey:@"label"];
    UIImage *icon = [self getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * value = [dic objectForKey:@"value"];
    [cell setValue:value];

    RMPhoneFormat * fmt = [[RMPhoneFormat alloc] init];
    NSString * displayedValue = [fmt format:value];
    [[cell label] setText:displayedValue];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ECNumberCell * cell = (ECNumberCell *)[tableView cellForRowAtIndexPath:indexPath];
    [_joiner joinContactWithKind:_kind address:[cell value] andViewController:self];
}


- (void) setFavoriteWithCell:(ECNumberCell *)cell {
    NSInteger index = [cell tag];
    NSMutableDictionary * number = [[_contact addessesOf:_kind] objectAtIndex:index];
    NSNumber * isFavorite = [number objectForKey:@"favorite"];
    [number setObject:[NSNumber numberWithBool:![isFavorite boolValue]] forKey:@"favorite"];
    [cell isFavorite:![isFavorite boolValue]];
    
    [[ECFavoritesHandler sharedInstance] toogleContact:_contact number:[[cell label] text] ofKind:_kind];
    [[ECFavoritesHandler sharedInstance] saveModifications];
}


#pragma - mark Misc function
-(UIImage *)getImageFromLabel:(NSString *)label {
    NSDictionary * dic = @{@"home": @"label-home.png",
                           @"mobile": @"label-mobile.png",
                           @"iPhone": @"label-mobile.png",
                           @"work": @"label-work.png"};
    if (![dic objectForKey:label])
        return [ECKindHandler iconForKind:_kind andWhite:NO];
    return [UIImage imageNamed:[dic objectForKey:label]];
}

-(void)hidePopup {
    UIView * view = [[self view] superview];
    if ([view isKindOfClass:[RNBlurModalView class]])
        [(RNBlurModalView *)view hideWithDuration:0 delay:0 options:0 completion:nil];
}

@end