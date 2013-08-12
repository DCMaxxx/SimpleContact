//
//  BCContactsTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCConstantStrings.h"
#import "RNBlurModalView.h"

#import "SCMainTableViewController.h"

#import "SCFavoritesViewController.h"
#import "SCTutorialViewController.h"
#import "SCModalViewController.h"
#import "SCSettingsHandler.h"
#import "SCNavigationBar.h"
#import "SCKindHandler.h"
#import "SCContactCell.h"
#import "SCContactList.h"

@interface SCMainTableViewController ()

@property (strong, nonatomic) SCContactList * contacts;
@property (strong, nonatomic) NSArray * filteredContacts;
@property (strong, nonatomic) SCModalViewController * modalContactViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) SCContactCell * swipedCell;
@property (nonatomic) BOOL shouldBeginEditingResearch;
@property (nonatomic) BOOL mustReloadLeftView;
@property (nonatomic) float currentOffset;
@property (nonatomic) BOOL fromFavorites;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCMainTableViewController

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[SCContactList alloc] init];
        _shouldBeginEditingResearch = YES;
        _currentOffset = -1.0f;
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UIViewController
/*----------------------------------------------------------------------------*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] setSectionIndexColor:[UIColor colorWithRed:0 green:0.46 blue:1.0 alpha:1.0]];
    [[self tableView] setSectionIndexTrackingBackgroundColor:[UIColor colorWithWhite:0.93f alpha:0.65f]];
    [_searchBar setBackgroundImage:[UIImage imageNamed:ImgNavBarBg]];
    [[self tableView] setTableHeaderView:_searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_currentOffset != -1.0f) {
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (sysVer >= 7.0 && _fromFavorites) {
            _currentOffset += CGRectGetHeight([[[self navigationController] navigationBar] frame]) +
                              CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        }
        [[self tableView] setContentOffset:CGPointMake(0, _currentOffset)];
        _currentOffset = -1.0f;
        _fromFavorites = NO;
    }
}

/*----------------------------------------------------------------------------*/
#pragma mark - UITableViewDataSource
/*----------------------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _filteredContacts ? 1 : [_contacts numberOfInitials];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredContacts ? [_filteredContacts count] : [_contacts numberOfContactsForInitialAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _filteredContacts ? nil : [_contacts initialAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _filteredContacts ? nil : @[@"", @"A", @"●", @"C", @"●", @"E", @"●", @"G", @"●", @"I", @"●", @"K", @"●", @"M", @"●",
             @"●", @"P", @"●", @"R", @"●", @"T", @"●", @"V", @"●", @"X", @"●", @"Z", @"#"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[SCSettingsHandler sharedInstance] getOption:eSOShowImages ofCategory:eSCDefault] ? 63.0f : 33.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const ReuIdContactCell = @"ContactCell";
    static NSString * const ReuIdNoPicContactCell = @"noPictureCell";
    NSString * cellType = [[SCSettingsHandler sharedInstance] getOption:eSOShowImages ofCategory:eSCDefault] ? ReuIdContactCell : ReuIdNoPicContactCell;
    SCContactCell * cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    NSUInteger indexOfSection = [indexPath indexAtPosition:0];
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    NSArray * contactsOfSection;
    if (_filteredContacts)
        contactsOfSection = _filteredContacts;
    else
        contactsOfSection = [_contacts contactsForInitialAtIndex:indexOfSection];
    SCContact * contact = [contactsOfSection objectAtIndex:indexOfContact];

    if (![cell viewController])
        [cell setViewController:self];

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

/*----------------------------------------------------------------------------*/
#pragma mark - UITableViewDelegate
/*----------------------------------------------------------------------------*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self unselectCell:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self unselectCell:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:[self tableView] numberOfRowsInSection:section] ? 22.0f : 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_filteredContacts || ![self tableView:[self tableView]numberOfRowsInSection:section])
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

/*----------------------------------------------------------------------------*/
#pragma mark - UIGestureRecognizerDelegate
/*----------------------------------------------------------------------------*/

- (IBAction)swipedRightOnContact:(UISwipeGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        SCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        SCContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
        [cell setLeftViewInformationsWithContact:contact];
        
        CGRect newContactFrame = [[cell mainView] frame];
        newContactFrame.origin.x += CGRectGetWidth([[cell leftView] frame]);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

- (void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer {
    SCContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKPhone contact:contact];
}

- (void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer {
    SCContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKMail contact:contact];
}

- (void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer {
    SCContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKText contact:contact];
}

- (void)tappedOnFaceTime:(UIGestureRecognizer *)gestureRecognizer {
    SCContact * contact = [self getContactFromGestureRecognizer:gestureRecognizer];
    [self showModalViewWithKind:eCNKFaceTime contact:contact];
}

/*----------------------------------------------------------------------------*/
#pragma mark - UISearchBarDelegate
/*----------------------------------------------------------------------------*/
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if (![searchBar isFirstResponder]) {
        _filteredContacts = nil;
        _shouldBeginEditingResearch = NO;
    } else if (![text length])
        _filteredContacts = nil;
    else
        _filteredContacts = [_contacts filterWithText:text];
    [[self tableView] reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    [self unselectCell:nil];
    BOOL retVal = _shouldBeginEditingResearch;
    _shouldBeginEditingResearch = YES;
    return retVal;
}


/*----------------------------------------------------------------------------*/
#pragma mark - ECSettingsDelegate
/*----------------------------------------------------------------------------*/
- (void)updatedSettings {
    [_contacts sortArrayAccordingToSettings];
    _mustReloadLeftView = YES;
    [[self tableView] reloadData];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Changing current ViewController
/*----------------------------------------------------------------------------*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    static NSString * const SegIdFavorites = @"displayFavorites";
    _currentOffset = [[self tableView] contentOffset].y;
    [self unselectCell:nil];
    if ([[segue identifier] isEqualToString:SegIdFavorites]) {
        _fromFavorites = YES;
        SCFavoritesViewController * nv = [segue destinationViewController];
        NSArray * favorites = [[SCFavoritesHandler sharedInstance] getAllFavoritesWithContactList:_contacts];
        [nv setFavoriteContacts:favorites];
    }
}

- (IBAction)displaySettings:(id)sender {
    _currentOffset = [[self tableView] contentOffset].y;
    [self unselectCell:nil];
    SCNavigationBar * nv = (SCNavigationBar *)[[self navigationController] navigationBar];
    [nv displaySettingsOnNavigationController:self.navigationController andDelegate:self];
}

- (void)displayTutorial {
    static NSString * const VCIdTutorial = @"tutorialViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:MainStoryBoard bundle:nil];
    SCTutorialViewController * tutorial = [storyboard instantiateViewControllerWithIdentifier:VCIdTutorial];
    [self.navigationController presentViewController:tutorial animated:NO completion:nil];
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
#pragma - mark Misc functions
- (void)updateContacts {
    _contacts = [[SCContactList alloc] init];
    [[self tableView] reloadData];
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc hidden methods
/*----------------------------------------------------------------------------*/
#pragma - mark Misc private functions
- (SCContact *)getContactFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * indexPath = [[self tableView] indexPathForRowAtPoint:location];
    NSUInteger indexOfSection = [indexPath indexAtPosition:0];
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    NSArray * contactsOfSection = [_contacts contactsForInitialAtIndex:indexOfSection];
    SCContact * contact;
    if (_filteredContacts)
        contact = [_filteredContacts objectAtIndex:indexOfContact];
    else
        contact = [contactsOfSection objectAtIndex:indexOfContact];
    return contact;
}

- (SCContactCell *)getCellFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * path = [[self tableView] indexPathForRowAtPoint:location];
    return (SCContactCell *)[[self tableView] cellForRowAtIndexPath:path];
}

- (void)showModalViewWithKind:(eContactNumberKind)kind
                     contact:(SCContact *)contact {
    static NSString * const VCIdModal = @"ECModalViewController";    
    [self unselectCell:nil];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:MainStoryBoard bundle:nil];
    _modalContactViewController = [sb instantiateViewControllerWithIdentifier:VCIdModal];
    [_modalContactViewController setContact:contact];
    [_modalContactViewController setKind:kind];
    
    RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalContactViewController view]];
    [modal show];
}

- (void)unselectCell:(UITableViewCell *)cell {
    [_searchBar resignFirstResponder];
    if (_swipedCell) {
        [_swipedCell setSelected:NO animated:NO];
        
        CGRect newContactFrame = [[_swipedCell mainView] frame];
        newContactFrame.origin.x -=  CGRectGetWidth([[_swipedCell leftView] frame]);
        
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