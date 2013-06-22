//
//  BCPhoneTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RMPhoneFormat.h"

#import "ECPhoneTableViewController.h"

#import "ECContactModalViewController.h"
#import "ECFavoritesHandler.h"
#import "ECContactModalCell.h"
#import "ECContact.h"


@implementation ECPhoneTableViewController

@synthesize modalViewController = _modalViewController;

#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfPhoneNumbers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    ECContactModalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    [cell setTag:index];

    if (![cell viewController])
        [cell setViewController:self];
    
    NSDictionary * phoneDic = [[_contact phoneNumbers] objectAtIndex:index];
    
    NSString *label = [phoneDic objectForKey:@"label"];
    UIImage *icon = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * phoneNumber = [phoneDic objectForKey:@"value"];
    RMPhoneFormat * fmt = [[RMPhoneFormat alloc] init];
    [[cell label] setText:[fmt format:phoneNumber]];
    [cell setOriginalNumber:phoneNumber];
    
    BOOL isFavorite = [(NSNumber *)[phoneDic objectForKey:@"favorite"] boolValue];
    [cell isFavorite:isFavorite];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ECContactModalCell * cell = (ECContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString * phoneNumber = [[[cell label] text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"tel://" stringByAppendingString:phoneNumber];
    
    [_modalViewController hidePopup];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];
}


#pragma - mark BCModalTableViewController protocol
- (void) setFavoriteForCell:(ECContactModalCell *)cell {
    NSInteger index = [cell tag];
    NSMutableDictionary * number = [[_contact phoneNumbers] objectAtIndex:index];
    NSNumber * isFavorite = [number objectForKey:@"favorite"];
    [number setObject:[NSNumber numberWithBool:![isFavorite boolValue]] forKey:@"favorite"];
    [cell isFavorite:![isFavorite boolValue]];
    
    [ECFavoritesHandler toogleContact:_contact number:[[cell label] text] ofKind:eCNKPhone];
}

@end