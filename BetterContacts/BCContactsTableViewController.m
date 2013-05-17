//
//  BCContactsTableViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 16/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCContactsTableViewController.h"

#import "BCContactCell.h"
#import "BCContactList.h"

@interface BCContactsTableViewController ()

@end

@implementation BCContactsTableViewController

#pragma mark - Init
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _contacts = [[BCContactList alloc] init];
        _swipedCell = nil;
    }
    return self;
}

#pragma mark - View controller delegate
- (void) viewDidLoad {
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"top_background.png"] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts numberOfContacts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";

    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    
    BCContact * contact = [_contacts contactAtIndex:indexOfContact];
    BCContactCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (![[cell gestureRecognizers] count]) {
        UISwipeGestureRecognizer * swipeRightOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRightOnContact:)];
        [swipeRightOnContact setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRightOnContact];
        
        UISwipeGestureRecognizer * swipeLeftOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeftOnContact:)];
        [swipeLeftOnContact setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [cell addGestureRecognizer:swipeLeftOnContact];
    }
    
    [cell setTag:indexOfContact];
    [cell setPictureAndNameInfosWithContact:contact andReceiver:self];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self unselectCell:(BCContactCell *)[tableView cellForRowAtIndexPath:indexPath]];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self unselectCell:_swipedCell];
}

- (void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell  && [[cell defaultView] frame].origin.x > 0)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        BCContact * contact = [_contacts contactAtIndex:[cell tag]];
        [cell setPhoneInfosWithContact:contact andReceiver:self];
        [cell setMailInfosWithContact:contact andReceiver:self];
        [cell setTextInfosWithContact:contact andReceiver:self];
        
        CGRect newContactFrame = [[cell defaultView] frame];
        newContactFrame.origin.x += [[cell swipingView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell defaultView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

- (void)swipedLeftOnContact:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        BCContactCell * cell = [self getCellFromGestureRecognizer:gestureRecognizer];
        if (cell == _swipedCell && [[cell defaultView] frame].origin.x < 0)
            return ;
        [self unselectCell:_swipedCell];
        _swipedCell = cell;
        
        BCContact * contact = [_contacts contactAtIndex:[cell tag]];
        [cell setDeleteInfosWithContact:contact andReceiver:self];
        [cell setFavoriteInfosWithContact:contact andReceiver:self];
        
        CGRect newContactFrame = [[cell defaultView] frame];
        newContactFrame.origin.x -= [[cell rightSwipingView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[cell defaultView] setFrame:newContactFrame];
        [UIView commitAnimations];
    }
}

- (void)unselectCell:(BCContactCell *)cell {
    if (_swipedCell) {
        [_swipedCell setSelected:NO animated:NO];
        
        CGRect newContactFrame = [[_swipedCell defaultView] frame];
        newContactFrame.origin.x = -[[cell swipingView] frame].size.width;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [[_swipedCell defaultView] setFrame:newContactFrame];
        [UIView commitAnimations];
        _swipedCell = nil;
    }
    if (cell)
        [cell setSelected:NO animated:NO];
}


#pragma mark - Misc private functions
- (NSInteger) getIndexOfContactFromContactCell: (BCContactCell *)cell {
    return [cell tag];
}

- (BCContact *) getContactFromContactCell: (BCContactCell *)cell {
    return [_contacts contactAtIndex:[self getIndexOfContactFromContactCell:cell]];
}

- (BCContactCell *) getCellFromGestureRecognizer: (UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self tableView]];
    NSIndexPath * path = [[self tableView] indexPathForRowAtPoint:location];
    return (BCContactCell *)[[self tableView] cellForRowAtIndexPath:path];
}

@end
