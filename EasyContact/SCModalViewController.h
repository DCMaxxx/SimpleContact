//
//  BCContactModalViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCKindHandler.h"

@class SCContact;
@class SCNumberCell;


@interface SCModalViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) SCContact * contact;
@property (nonatomic) eContactNumberKind kind;

@end
