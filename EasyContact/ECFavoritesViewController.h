//
//  BCFavoritesViewViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECSettingsDelegate.h"


@interface ECFavoritesViewController : UICollectionViewController
<
UICollectionViewDataSource,
UICollectionViewDelegate,
ECSettingsDelegate
>

@property (strong, nonatomic) NSArray * favoriteContacts;

- (IBAction)goBackToContacts;
- (IBAction)displaySettings:(id)sender;

@end
