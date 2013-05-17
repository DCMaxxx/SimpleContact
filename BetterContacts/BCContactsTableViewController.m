//
//  BCContactsTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"

#import "BCContactsTableViewController.h"

#import "BCContactModalViewController.h"
#import "BCPhoneTableViewController.h"
#import "BCContactCell.h"
#import "BCContactList.h"

enum eModalType { kMTPhone, kMTMail, kMTText };
static UIImage * modalTypeImages[3] = { nil, nil, nil };

@interface BCContactsTableViewController ()

@property (weak, nonatomic) BCContactCell * swipedCell;
@property (strong, nonatomic) BCContactList * contacts;
@property (strong, nonatomic) BCContactModalViewController * modalContactViewController;

@end

@implementation BCContactsTableViewController

@synthesize swipedCell = _swipedCell;
@synthesize contacts = _contacts;
@synthesize modalContactViewController = _modalContactViewController;

#pragma mark - Init
+(void)initialize {
    modalTypeImages[kMTPhone] = [UIImage imageNamed:@"telephone-black.png"];
    modalTypeImages[kMTMail] = [UIImage imageNamed:@"email-black.png"];
    modalTypeImages[kMTText] = [UIImage imageNamed:@"sms-black.png"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[BCContactList alloc] init];
        _swipedCell = nil;
    }
    return self;
}

#pragma mark - View controller delegate
-(void)viewDidLoad {
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"top_background.png"] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contacts numberOfContacts];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"contactCell";

    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    
    BCContact * contact = [_contacts contactAtIndex:indexOfContact];
    BCContactCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (![cell viewController])
        [cell setViewController:self];
    
    if (![[cell gestureRecognizers] count]) {
        UISwipeGestureRecognizer * swipeRightOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRightOnContact:)];
        [swipeRightOnContact setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRightOnContact];
        
        UISwipeGestureRecognizer * swipeLeftOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeftOnContact:)];
        [swipeLeftOnContact setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [cell addGestureRecognizer:swipeLeftOnContact];
    }
    
    [cell setTag:indexOfContact];
    [cell setMainViewInformationsWithContact:contact];
    
    return cell;
}


#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self unselectCell:(BCContactCell *)[tableView cellForRowAtIndexPath:indexPath]];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self unselectCell:_swipedCell];
}

-(void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell  && [[cell mainView] frame].origin.x > 0)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        BCContact * contact = [_contacts contactAtIndex:[cell tag]];
        [cell setLeftViewInformationsWithContact:contact];
        
        CGRect newContactFrame = [[cell mainView] frame];
        newContactFrame.origin.x += [[cell leftView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

-(void)swipedLeftOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell && [[cell mainView] frame].origin.x < 0)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        BCContact * contact = [_contacts contactAtIndex:[cell tag]];
        [cell setRightViewInformationsWithContact:contact];
        
        CGRect newContactFrame = [[cell mainView] frame];
        newContactFrame.origin.x -= [[cell rightView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

-(void)unselectCell:(BCContactCell *)cell {
    if (_swipedCell) {
        [_swipedCell setSelected:NO animated:NO];
        
        CGRect newContactFrame = [[_swipedCell mainView] frame];
        newContactFrame.origin.x = -[[cell leftView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[_swipedCell mainView] setFrame:newContactFrame];
        [UIView commitAnimations];
        _swipedCell = nil;
    }
    if (cell)
        [cell setSelected:NO animated:NO];
}


#pragma mark - Tapped on left view buttons
-(void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    _modalContactViewController = [sb instantiateViewControllerWithIdentifier:@"BCContactModalViewController"];

    BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
    BCContact * contact = [self getContactFromContactCell:cell];
    [_modalContactViewController setContact:contact];
    NSLog(@"img : %@", modalTypeImages[kMTPhone]);
    [_modalContactViewController setTypeImage:modalTypeImages[kMTPhone]];

    BCPhoneTableViewController * tbvc = [[BCPhoneTableViewController alloc] init];
    [tbvc setContact:contact];
    [_modalContactViewController setTableViewController:tbvc];
    

    RNBlurModalView * modal = [[RNBlurModalView alloc] initWithView:[_modalContactViewController view]];
    [modal show];
}

-(void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Hello, world !");
}

-(void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Hello, world !");
}

#pragma mark - Tapped on right view buttons
-(void)tappedOnFavorite:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Hello, world !");
}

-(void)tappedOnDelete:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Hello, world !");
}


#pragma mark - Misc private functions
-(NSInteger)getIndexOfContactFromContactCell: (BCContactCell *)cell {
    return [cell tag];
}

-(BCContact *)getContactFromContactCell: (BCContactCell *)cell {
    return [_contacts contactAtIndex:[self getIndexOfContactFromContactCell:cell]];
}

-(BCContactCell *)getCellFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * path = [[self tableView] indexPathForRowAtPoint:location];
    return (BCContactCell *)[[self tableView] cellForRowAtIndexPath:path];
}

@end
