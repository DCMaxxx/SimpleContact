//
//  BCPhoneTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RMPhoneFormat.h"

#import "BCPhoneTableViewController.h"

#import "BCContactModalViewController.h"
#import "BCContactModalCell.h"
#import "BCContact.h"

@interface BCPhoneTableViewController ()

@end

@implementation BCPhoneTableViewController

@synthesize contact = _contact;
@synthesize modalViewController = _modalViewController;

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfPhoneNumbers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalCell";
    BCContactModalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath indexAtPosition:1];
    
    NSDictionary * phoneDic = [[_contact phoneNumbers] objectAtIndex:index];
    
    NSString *label = [phoneDic objectForKey:@"label"];
    UIImage *icon = [_modalViewController getImageFromLabel:label];
    [[cell icon] setImage:icon];
    
    NSString * phoneNumber = [phoneDic objectForKey:@"value"];
    RMPhoneFormat * rpt = [[RMPhoneFormat alloc] init];
    phoneNumber = [rpt format:phoneNumber];
    [[cell label] setText:phoneNumber];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCContactModalCell * cell = (BCContactModalCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString * phoneNumber = [[[cell label] text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"tel://" stringByAppendingString:phoneNumber];
    
    [_modalViewController hidePopup];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];
}

@end
