//
//  BCMailTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 18/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCMailTableViewController.h"

#import "BCContact.h"
#import "BCContactModalCell.h"
#import "BCContactModalViewController.h"

#import "RNBlurModalView.h"

@interface BCMailTableViewController ()

@property (strong, nonatomic) MFMailComposeViewController *mailViewController;

@end

@implementation BCMailTableViewController

@synthesize contact = _contact;
@synthesize modalViewController = _modalViewController;
@synthesize mailViewController = _mailViewController;

#pragma - mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfMailAddresses];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    BCContactModalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    NSDictionary * mailDic = [[_contact mailAddresses] objectAtIndex:index];
    
    NSString *label = [mailDic objectForKey:@"label"];
    UIImage *icon = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * mailAddress = [mailDic objectForKey:@"value"];
    [[cell label] setText:mailAddress];
    
    return cell;
}


#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![MFMailComposeViewController canSendMail]) {
        // On peut pas envoyer de mail ! Zut alors !
    } else {
        [[[[_modalViewController view] superview] viewWithTag:4242] removeFromSuperview]; // removing close button from RNBlurModalView

        BCContactModalCell * cell = (BCContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];

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


@end
