//
//  BCViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 31/01/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forward declaring
@class BCModalListViewController;
@class BCContactsTableViewDelegate;
@class BCContactCell;
@class BCContact;

@interface BCViewController : UITableViewController {
    BCContactsTableViewDelegate * _contactListViewDelegate;
    BCModalListViewController * _modalViewController;
}


@property (strong, nonatomic) IBOutlet UITableView *contactListView;

- (void)swipedLeftOnContact:(UIGestureRecognizer *)gestureRecognizer;
- (void)swipedRightOnContact:(UIGestureRecognizer *)gestureRecognizer;

- (void)tappedOnPhone:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedOnMail:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedOnText:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedOnDelete:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedOnFavorite:(UIGestureRecognizer *)gestureRecognizer;

- (void)tappedOnContact:(BCContactCell *)cell;

@end
