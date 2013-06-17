//
//  BCContactsTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"

#import "ECContactsTableViewController.h"

#import "ECFavoritesViewViewController.h"
#import "ECContactModalViewController.h"
#import "ECPhoneTableViewController.h"
#import "ECTextTableViewController.h"
#import "ECMailTableViewController.h"
#import "ECContactCell.h"
#import "ECContactList.h"


enum eModalType { kMTPhone, kMTMail, kMTText };


static UIImage * modalTypeImages[3] = { nil, nil, nil };


@interface ECContactsTableViewController ()

@property (weak, nonatomic) ECContactCell * swipedCell;
@property (strong, nonatomic) ECContactList * contacts;
@property (strong, nonatomic) ECContactModalViewController * modalContactViewController;

@end


@implementation ECContactsTableViewController

#pragma - mark Init
+(void)initialize {
    modalTypeImages[kMTPhone] = [UIImage imageNamed:@"phone-black.png"];
    modalTypeImages[kMTMail] = [UIImage imageNamed:@"mail-black.png"];
    modalTypeImages[kMTText] = [UIImage imageNamed:@"text-black.png"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[ECContactList alloc] init];
        _swipedCell = nil;
    }
    return self;
}


#pragma - mark View controller delegate
-(void)viewDidLoad {
    [super viewDidLoad];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"navigationbar-background.png"] forBarMetrics:UIBarMetricsDefault];
}


#pragma - mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_contacts numberOfInitials];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contacts numberOfContactsForInitialAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_contacts initialAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"●", @"C", @"●", @"E", @"●", @"G", @"●", @"I", @"●", @"K", @"●", @"M", @"●",
             @"●", @"P", @"●", @"R", @"●", @"T", @"●", @"V", @"●", @"X", @"●", @"Z", @"#"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"contactCell";
    ECContactCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger indexOfSection = [indexPath indexAtPosition:0];
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    NSArray * contactsOfSection = [_contacts contactsForInitialAtIndex:indexOfSection];
    ECContact * contact = [contactsOfSection objectAtIndex:indexOfContact];
    
    if (![cell viewController])
        [cell setViewController:self];
    
    if (![[cell gestureRecognizers] count]) {
        UISwipeGestureRecognizer * swipeRightOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRightOnContact:)];
        [swipeRightOnContact setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRightOnContact];
    }
    
    [cell setMainViewInformationsWithContact:contact];
    
    return cell;
}


#pragma - mark Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self unselectCell:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self unselectCell:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:[self tableView] numberOfRowsInSection:section] ? 22.0f : 0.0f;
}


#pragma - mark Gesture recognition
-(void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        ECContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell  && [[cell mainView] frame].origin.x > 0)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
        [cell setLeftViewInformationsWithContact:contact];
        
        CGRect newContactFrame = [[cell mainView] frame];
        newContactFrame.origin.x += [[cell leftView] frame].size.width - 1;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

-(void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    ECPhoneTableViewController * controller = [[ECPhoneTableViewController alloc] init];
    [self showModalViewWithImageType:modalTypeImages[kMTPhone] contact:contact andViewController:controller];
}

-(void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    ECMailTableViewController * controller = [[ECMailTableViewController alloc] init];
    [self showModalViewWithImageType:modalTypeImages[kMTMail] contact:contact andViewController:controller];
}

-(void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    ECTextTableViewController * controller = [[ECTextTableViewController alloc] init];
    [self showModalViewWithImageType:modalTypeImages[kMTText] contact:contact andViewController:controller];
}


#pragma - mark Passing arguments to other VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"displayFavorites"]) {
        ECFavoritesViewViewController * nv = [segue destinationViewController];
        [nv setFavoriteContacts:[_contacts getFavoriteContacts]];
    }
}


#pragma - mark Misc private functions
-(ECContact *)getContactFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * indexPath = [[self tableView] indexPathForRowAtPoint:location];
    NSUInteger indexOfSection = [indexPath indexAtPosition:0];
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    NSArray * contactsOfSection = [_contacts contactsForInitialAtIndex:indexOfSection];
    ECContact * contact = [contactsOfSection objectAtIndex:indexOfContact];
    return contact;
}

-(ECContactCell *)getCellFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * path = [[self tableView] indexPathForRowAtPoint:location];
    return (ECContactCell *)[[self tableView] cellForRowAtIndexPath:path];
}

-(void)showModalViewWithImageType:(UIImage *)image
                          contact:(ECContact *)contact
                andViewController:(UITableViewController <ECModalTableViewController> *) controller {
    
    [self unselectCell:nil];

    [controller setContact:contact];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    _modalContactViewController = [sb instantiateViewControllerWithIdentifier:@"BCContactModalViewController"];
    [_modalContactViewController setContact:contact];
    [_modalContactViewController setTypeImage:image];
    [_modalContactViewController setTableViewController:controller];
    
    RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalContactViewController view]];
    [modal show];
}

-(void)unselectCell:(UITableViewCell *)cell {
    if (_swipedCell) {
        [_swipedCell setSelected:NO animated:NO];
        
        CGRect newContactFrame = [[_swipedCell mainView] frame];
        newContactFrame.origin.x = -[[_swipedCell leftView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[_swipedCell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
        _swipedCell = nil;
    }
    if (cell)
        [cell setSelected:NO animated:NO];
}

@end