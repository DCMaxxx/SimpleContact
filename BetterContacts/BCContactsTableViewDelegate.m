//
//  BCContactsTableViewDelegate.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 31/01/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

#import "BCContactsTableViewDelegate.h"

#import "BCContactCell.h"
#import "BCContactList.h"
#import "BCViewController.h"

#import "BCContact.h"

@implementation BCContactsTableViewDelegate

static NSString * const reusableIdentifier = @"contactCell";

@synthesize view = _view;
@synthesize viewController = _viewController;


#pragma make Init
- (id) init {
    if (self = [super init]) {
        _contacts = [[BCContactList alloc] init];
        _swipedCell = nil;
    }
    return self;
}


#pragma mark UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfContact = [indexPath indexAtPosition:1];
    
    BCContact * contact = [_contacts contactAtIndex:indexOfContact];
    BCContactCell * cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    
    if (![[cell gestureRecognizers] count]) {
        UISwipeGestureRecognizer * swipeLeftOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:_viewController action:@selector(swipedLeftOnContact:)];
        [swipeLeftOnContact setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeLeftOnContact];

        UISwipeGestureRecognizer * swipeRightOnContact = [[UISwipeGestureRecognizer alloc] initWithTarget:_viewController action:@selector(swipedRightOnContact:)];
        [swipeRightOnContact setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [cell addGestureRecognizer:swipeRightOnContact];
    }
    
    [cell setTag:indexOfContact];
    [cell setPictureAndNameInfosWithContact:contact andReceiver:_viewController];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contacts numberOfContacts];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCContactCell * cell = (BCContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    [_viewController tappedOnContact:cell];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self unselectCell:_swipedCell];
}


#pragma mark Act on cell
- (void)displayContactButtonsOfCell:(BCContactCell *)cell {
    if (cell == _swipedCell  && [[cell defaultView] frame].origin.x > 0)
        return ;
    [self unselectCell:_swipedCell];
    _swipedCell = cell;
    
    BCContact * contact = [_contacts contactAtIndex:[cell tag]];
    [cell setPhoneInfosWithContact:contact andReceiver:_viewController];
    [cell setMailInfosWithContact:contact andReceiver:_viewController];
    [cell setTextInfosWithContact:contact andReceiver:_viewController];

    CGRect newContactFrame = [[cell defaultView] frame];
    newContactFrame.origin.x += [[cell swipingView] frame].size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [[cell defaultView] setFrame:newContactFrame];
    [UIView commitAnimations];
}

- (void)displayOtherButtonsOfCell:(BCContactCell *)cell {
    if (cell == _swipedCell && [[cell defaultView] frame].origin.x < 0)
        return ;
    [self unselectCell:_swipedCell];
    _swipedCell = cell;

    BCContact * contact = [_contacts contactAtIndex:[cell tag]];
    [cell setDeleteInfosWithContact:contact andReceiver:_viewController];
    [cell setFavoriteInfosWithContact:contact andReceiver:_viewController];

    CGRect newContactFrame = [[cell defaultView] frame];
    newContactFrame.origin.x -= [[cell rightSwipingView] frame].size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [[cell defaultView] setFrame:newContactFrame];
    [UIView commitAnimations];
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


#pragma mark Misc private functions
- (NSInteger) getIndexOfContactFromContactCell: (BCContactCell *)cell {
    return [cell tag];
}

- (BCContact *) getContactFromContactCell: (BCContactCell *)cell {
    return [_contacts contactAtIndex:[self getIndexOfContactFromContactCell:cell]];
}

@end
