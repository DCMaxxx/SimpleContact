//
//  BCContactsTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"

#import "ECMainTableViewController.h"

#import "ECFavoritesViewController.h"
#import "ECModalViewController.h"
#import "ECNavigationBar.h"
#import "ECKindHandler.h"
#import "ECContactCell.h"
#import "ECContactList.h"


@interface ECMainTableViewController ()

@property (weak, nonatomic) ECContactCell * swipedCell;
@property (strong, nonatomic) ECContactList * contacts;
@property (strong, nonatomic) ECModalViewController * modalContactViewController;

@end


@implementation ECMainTableViewController

#pragma - mark Init
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[ECContactList alloc] init];
        _swipedCell = nil;
    }
    return self;
}


#pragma - mark View controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] setSectionIndexColor:[UIColor colorWithRed:0 green:0.46 blue:1.0 alpha:1.0]];
    [[self tableView] setSectionIndexTrackingBackgroundColor:[UIColor colorWithWhite:0.93f alpha:0.65f]];
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
    static NSString *CellIdentifier = @"ContactCell";
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self tableView:[self tableView]numberOfRowsInSection:section])
        return nil;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];
    [view setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:0.75f]];
    NSString * str = [self tableView:[self tableView] titleForHeaderInSection:section];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2.5f, 15, 15)];
    [label setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:str];
    [view addSubview:label];
    return view;
}


#pragma - mark Gesture recognition
-(void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        ECContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
        [cell setLeftViewInformationsWithContact:contact];
        
        CGRect newContactFrame = [[cell mainView] frame];
        newContactFrame.origin.x += [[cell leftView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

-(void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKPhone contact:contact];
}

-(void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKMail contact:contact];
}

-(void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKText contact:contact];
}

-(void)tappedOnFaceTime:(UIGestureRecognizer *)gestureRecognizer {
    ECContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKFaceTime contact:contact];
}

#pragma - mark Passing arguments to other VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self unselectCell:nil];
    if ([[segue identifier] isEqualToString:@"displayFavorites"]) {
        ECFavoritesViewController * nv = [segue destinationViewController];
        NSArray * favorites = [[ECFavoritesHandler sharedInstance] getAllFavoritesWithContactList:_contacts];
        [nv setFavoriteContacts:favorites];
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

-(void)showModalViewWithKind:(eContactNumberKind)kind
                          contact:(ECContact *)contact {
    
    [self unselectCell:nil];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    _modalContactViewController = [sb instantiateViewControllerWithIdentifier:@"ECModalViewController"];
    [_modalContactViewController setContact:contact];
    [_modalContactViewController setKind:kind];
    
    RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalContactViewController view]];
    [modal show];
}

-(void)unselectCell:(UITableViewCell *)cell {
    if (_swipedCell) {
        [_swipedCell setSelected:NO animated:NO];
        
        CGRect newContactFrame = [[_swipedCell mainView] frame];
        newContactFrame.origin.x -= [[_swipedCell leftView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[_swipedCell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
        _swipedCell = nil;
    }
    if (cell)
        [cell setSelected:NO animated:NO];
}

- (IBAction)displaySettings:(id)sender {
    [self unselectCell:nil];
    ECNavigationBar * nv = (ECNavigationBar *)[[self navigationController] navigationBar];
    [nv displaySettingsOnNavigationController:self.navigationController andDelegate:self];
}

- (void)updateContacts {
    _contacts = [[ECContactList alloc] init];
    [[self tableView] reloadData];
}

-(void)updatedSettings {
    [_contacts sortArrayAccordingToSettings];
    [[self tableView] reloadData];
}



@end