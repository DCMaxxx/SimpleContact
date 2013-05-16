//
//  BCViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 31/01/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "BCViewController.h"

#import "BCContactsTableViewDelegate.h"
#import "BCModalListViewController.h"
#import "BCModalTableViewDelegate.h"
#import "BCModalListView.h"
#import "BCContactCell.h"
#import "BCContact.h"

#import "RNBlurModalView.h"


@interface BCViewController ()
@end

@implementation BCViewController

@synthesize contactListView = _contactListView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Accessing contacts
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) { });
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) ;
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address Book"
                                                       message:@"You refused access to your address book. If you don't fix this in Settings/Confidentiality, the app will be a bit less useful."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }

    // Modifying top bar
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"top_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Creating the contact list delegate
    _contactListViewDelegate = [[BCContactsTableViewDelegate alloc] init];
    [_contactListViewDelegate setView:_contactListView];
    [_contactListViewDelegate setViewController:self];
    [_contactListView setDataSource:_contactListViewDelegate];
    [_contactListView setDelegate:_contactListViewDelegate];

//    // Search view
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [labelView setText:@"   ---> coucou <---"];
//    [headerView addSubview:labelView];
//    self.contactListView.tableHeaderView = headerView;
//    [self.contactListView setContentOffset:CGPointMake(0,60)];
}

- (void)swipedLeftOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        [_contactListViewDelegate displayContactButtonsOfCell:cell];
    }
}

- (void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        [_contactListViewDelegate displayOtherButtonsOfCell:cell];
    }
}

- (void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        [_contactListViewDelegate unselectCell:cell];

        
        BCContact * contact = [_contactListViewDelegate getContactFromContactCell:cell];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        _modalViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        [_modalViewController myInitWithType:MTVPhone andContact:contact];
        
        RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalViewController view]];
        [modal show];
    }
}

- (void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        [_contactListViewDelegate unselectCell:cell];
        
        
        BCContact * contact = [_contactListViewDelegate getContactFromContactCell:cell];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        _modalViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        [_modalViewController myInitWithType:MTVMail andContact:contact];
        
        RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalViewController view]];
        [modal show];
    }
}

- (void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    }
}

- (void)tappedOnDelete:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    }
}

- (void)tappedOnFavorite:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    }
}

- (void)tappedOnContact:(BCContactCell *)cell {
    [_contactListViewDelegate unselectCell:cell];
}

- (BCContactCell *) getCellFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:_contactListView];
    NSIndexPath * path = [_contactListView indexPathForRowAtPoint:location];
    return (BCContactCell *)[_contactListView cellForRowAtIndexPath:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
