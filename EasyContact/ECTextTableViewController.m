//
//  BCTTextTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 02/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"

#import "ECTextTableViewController.h"

#import "ECContactModalViewController.h"
#import "ECContactModalCell.h"
#import "ECFavoritesHandler.h"
#import "ECContact.h"


@interface ECTextTableViewController ()

@property (strong, nonatomic) MFMessageComposeViewController * messageViewController;

@end


@implementation ECTextTableViewController

@synthesize modalViewController = _modalViewController;

#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfTextAddresses];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    ECContactModalCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    [cell setTag:index];
    
    if (![cell viewController])
        [cell setViewController:self];
    
    NSDictionary * textDic = [[_contact textAddresses] objectAtIndex:index];
    
    NSString * label = [textDic objectForKey:@"label"];
    UIImage * image = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:image];
    
    NSString * textAddress = [textDic objectForKey:@"value"];
    [[cell label] setText:textAddress];
    
    BOOL isFavorite = [(NSNumber *)[textDic objectForKey:@"favorite"] boolValue];
    [cell isFavorite:isFavorite];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![MFMessageComposeViewController canSendText]) {
        // Oh, on peut pas envoyer de texto :'-(
    } else { // Bug dans le simulateur sur 10.8.2, connu mais pas de solution. Marche nickel sur un vrai device
        [[[[_modalViewController view] superview] viewWithTag:kRNBlurCloseViewTag] removeFromSuperview]; // removing close button from RNBlurModalView

        ECContactModalCell * cell = (ECContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        _messageViewController = [[MFMessageComposeViewController alloc] init];
        [_messageViewController setMessageComposeDelegate:self];
        
        NSArray *toRecipients = [NSArray arrayWithObject:[[cell label] text]];
        [_messageViewController setRecipients:toRecipients];
        
        [_modalViewController presentViewController:_messageViewController animated:YES completion:nil];
    }
}

#pragma mark - MFMailCompose View Controller Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [_modalViewController dismissViewControllerAnimated:NO
                                             completion:^{
                                                 [_modalViewController hidePopup];
                                             }];
}


#pragma - mark BCModalTableViewController protocol
- (void) setFavoriteForCell:(ECContactModalCell *)cell {
    NSInteger index = [cell tag];
    NSMutableDictionary * number = [[_contact textAddresses] objectAtIndex:index];
    NSNumber * isFavorite = [number objectForKey:@"favorite"];
    [number setObject:[NSNumber numberWithBool:![isFavorite boolValue]] forKey:@"favorite"];
    [cell isFavorite:![isFavorite boolValue]];

    [ECFavoritesHandler toogleContact:_contact number:[[cell label] text] ofKind:eCNKText];
}

@end