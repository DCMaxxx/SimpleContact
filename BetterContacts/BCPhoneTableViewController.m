//
//  BCPhoneTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCPhoneTableViewController.h"

#import "BCFavoritesHandler.h"

#import "BCContactModalViewController.h"
#import "BCContactModalCell.h"
#import "BCContact.h"

@interface BCPhoneTableViewController ()

@end

@implementation BCPhoneTableViewController

@synthesize contact = _contact;
@synthesize modalViewController = _modalViewController;

#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfPhoneNumbers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    BCContactModalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    [cell setTag:index];

    if (![cell viewController])
        [cell setViewController:self];
    
    NSDictionary * phoneDic = [[_contact phoneNumbers] objectAtIndex:index];
    
    NSString *label = [phoneDic objectForKey:@"label"];
    UIImage *icon = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * phoneNumber = [phoneDic objectForKey:@"value"];
    [[cell label] setText:phoneNumber];
    
    BOOL isFavorite = [(NSNumber *)[phoneDic objectForKey:@"favorite"] boolValue];
    if (isFavorite)
        [[cell favorite] setImage:[UIImage imageNamed:@"fav.png"]];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCContactModalCell * cell = (BCContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString * phoneNumber = [[[cell label] text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"tel://" stringByAppendingString:phoneNumber];
    
    [_modalViewController hidePopup];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];
}


#pragma - mark BCModalTableViewController protocol
- (void) setFavoriteForCell:(BCContactModalCell *)cell {
    NSInteger index = [cell tag];
    NSMutableDictionary * number = [[_contact phoneNumbers] objectAtIndex:index];
    NSNumber * isFavorite = [number objectForKey:@"favorite"];
    isFavorite = [NSNumber numberWithBool:![isFavorite boolValue]];
    [number setObject:isFavorite forKey:@"favorite"];
    [cell isFavorite:[isFavorite boolValue]];
    
    [BCFavoritesHandler toogleContact:_contact number:[[cell label] text] ofKind:eCNKPhone];
}


@end
