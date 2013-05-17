//
//  BCModalTableViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCContactModalViewController;


@protocol BCModalTableViewController <NSObject>

@property (weak, nonatomic) BCContactModalViewController * modalViewController;

@end
