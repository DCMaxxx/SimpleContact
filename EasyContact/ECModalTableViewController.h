//
//  BCModalTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECContactModalViewController;
@class ECContactModalCell;
@class ECContact;


@protocol ECModalTableViewController <NSObject>

@property (weak, nonatomic) ECContactModalViewController * modalViewController;
@property (weak, nonatomic) ECContact * contact;

- (void) setFavoriteForCell:(ECContactModalCell *)cell;

@end
