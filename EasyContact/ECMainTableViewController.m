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
#import "ECSettingsHandler.h"
#import "ECNavigationBar.h"
#import "ECKindHandler.h"
#import "ECContactCell.h"
#import "ECContactList.h"


@interface ECMainTableViewController ()

@property (weak, nonatomic) ECContactCell * swipedCell;
@property (strong, nonatomic) ECContactList * contacts;
@property (strong, nonatomic) NSArray * searchedContacts;
@property (strong, nonatomic) ECModalViewController * modalContactViewController;
@property (nonatomic) BOOL mustReloadLeftView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchBarPlaceHolder;
@property (nonatomic) float currentOffset;

@property (strong, nonatomic) UIGestureRecognizer* cancelGesture;
@property (nonatomic) BOOL shouldBeginEditing;

@end


@implementation ECMainTableViewController

#pragma - mark Init
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[ECContactList alloc] init];
        _mustReloadLeftView = NO;
        _shouldBeginEditing = YES;
        _currentOffset = -1.0f;
    }
    return self;
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if (![searchBar isFirstResponder]) {
        _searchedContacts = nil;
        _shouldBeginEditing = NO;
    }
    NSLog(@"BOU BABY");
    
    if (![text length])
        _searchedContacts = nil;
    else
        _searchedContacts = [_contacts filterWithText:text];
    [[self tableView] reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [_searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    [self unselectCell:nil];
    BOOL retVal = _shouldBeginEditing;
    _shouldBeginEditing = YES;
    return retVal;
}


#pragma - mark View controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] setSectionIndexColor:[UIColor colorWithRed:0 green:0.46 blue:1.0 alpha:1.0]];
    [[self tableView] setSectionIndexTrackingBackgroundColor:[UIColor colorWithWhite:0.93f alpha:0.65f]];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"navigationbar-background.png"]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_currentOffset != -1.0f) {
        [[self tableView] setContentOffset:CGPointMake(0, _currentOffset)];
        _currentOffset = -1.0f;
    } else
        [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.0f];

}
- (void)hideSearchBar {
    if (!_searchedContacts)
        [[self tableView] setContentOffset:CGPointMake(0, [_searchBar frame].size.height)];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentOffset = [[self tableView] contentOffset].y;
    CGFloat height = [_searchBar frame].size.height;
    if (contentOffset > height || _searchedContacts)
        return ;
    else if (contentOffset <= height / 2.0f)
        [[self tableView] setContentOffset:CGPointMake(0, height) animated:YES];
    else
        [[self tableView] setContentOffset:CGPointZero animated:YES];
}

- (void) backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}


#pragma - mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _searchedContacts ? 1 : [_contacts numberOfInitials];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchedContacts ? [_searchedContacts count] : [_contacts numberOfContactsForInitialAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _searchedContacts ? nil : [_contacts initialAtIndex:(section ? section - 1 : section)];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _searchedContacts ? nil : @[@"", @"A", @"●", @"C", @"●", @"E", @"●", @"G", @"●", @"I", @"●", @"K", @"●", @"M", @"●",
             @"●", @"P", @"●", @"R", @"●", @"T", @"●", @"V", @"●", @"X", @"●", @"Z", @"#"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[ECSettingsHandler sharedInstance] getOption:eSOShowImages ofCategory:eSCDefault] ? 63.0f : 33.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ContactCell";
    static NSString *NoPicCell = @"noPictureCell";
    NSString * cellType = [[ECSettingsHandler sharedInstance] getOption:eSOShowImages ofCategory:eSCDefault] ? CellIdentifier : NoPicCell;
    ECContactCell * cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    NSUInteger indexOfSection = [indexPath indexAtPosition:0];
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    NSArray * contactsOfSection;
    if (_searchedContacts)
        contactsOfSection = _searchedContacts;
    else
        contactsOfSection = [_contacts contactsForInitialAtIndex:indexOfSection];
    ECContact * contact = [contactsOfSection objectAtIndex:indexOfContact];

    if (![cell viewController])
        [cell setViewController:self];

    if (![[cell gestureRecognizers] count]) {
        UISwipeGestureRecognizer * swipeRightOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRightOnContact:)];
        [swipeRightOnContact setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRightOnContact];
    }
    
    [cell setMainViewInformationsWithContact:contact];
    if (_mustReloadLeftView) {
        if (indexOfSection == [tableView numberOfSections]
            && indexOfContact == [tableView numberOfRowsInSection:indexOfSection]) {
            _mustReloadLeftView = NO;
        }
        [cell setLeftView:nil];
    }
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
    if (_searchedContacts || ![self tableView:[self tableView]numberOfRowsInSection:section])
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = _searchBar.frame;
    rect.origin.y = MIN(0, scrollView.contentOffset.y);
    _searchBar.frame = rect;
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
    _currentOffset = [[self tableView] contentOffset].y;
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
    ECContact * contact;
    if (_searchedContacts)
        contact = [_searchedContacts objectAtIndex:indexOfContact];
    else
        contact = [contactsOfSection objectAtIndex:indexOfContact];
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
    [_searchBar resignFirstResponder];
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
    _currentOffset = [[self tableView] contentOffset].y;
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
    _mustReloadLeftView = YES;
    [[self tableView] reloadData];
}



@end