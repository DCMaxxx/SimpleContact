//
//  BCMailTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 18/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"

#import "ECMailTableViewController.h"

#import "ECContact.h"
#import "ECContactModalCell.h"
#import "ECContactModalViewController.h"
#import "ECFavoritesHandler.h"


@interface ECMailTableViewController ()

@property (strong, nonatomic) MFMailComposeViewController *mailViewController;

@end


@implementation ECMailTableViewController

@synthesize modalViewController = _modalViewController;

#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfMailAddresses];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    ECContactModalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    [cell setTag:index];
    
    if (![cell viewController])
        [cell setViewController:self];

    NSDictionary * mailDic = [[_contact mailAddresses] objectAtIndex:index];
    
    NSString *label = [mailDic objectForKey:@"label"];
    UIImage *icon = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * mailAddress = [mailDic objectForKey:@"value"];
    [[cell label] setText:mailAddress];
    
    BOOL isFavorite = [(NSNumber *)[mailDic objectForKey:@"favorite"] boolValue];
    [cell isFavorite:isFavorite];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![MFMailComposeViewController canSendMail]) {
        // On peut pas envoyer de mail ! Zut alors !
    } else {
        [[[[_modalViewController view] superview] viewWithTag:kRNBlurCloseViewTag] removeFromSuperview]; // removing close button from RNBlurModalView

        ECContactModalCell * cell = (ECContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];

        _mailViewController = [[MFMailComposeViewController alloc] init];
        [_mailViewController setMailComposeDelegate:self];
        
        NSArray *toRecipients = [NSArray arrayWithObject:[[cell label] text]];
        [_mailViewController setToRecipients:toRecipients];
        
        [_modalViewController presentViewController:_mailViewController animated:YES completion:nil];
    }
}


#pragma mark - MFMailCompose View Controller Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [_modalViewController dismissViewControllerAnimated:NO
                                             completion:^{
                                                 [_modalViewController hidePopup];
                                             }];
}


#pragma - mark BCModalTableViewController protocol
- (void) setFavoriteForCell:(ECContactModalCell *)cell {
    NSInteger index = [cell tag];
    NSMutableDictionary * number = [[_contact mailAddresses] objectAtIndex:index];
    NSNumber * isFavorite = [number objectForKey:@"favorite"];
    [number setObject:[NSNumber numberWithBool:![isFavorite boolValue]] forKey:@"favorite"];
    [cell isFavorite:![isFavorite boolValue]];
    
    [ECFavoritesHandler toogleContact:_contact number:[[cell label] text] ofKind:eCNKMail];
}

@end