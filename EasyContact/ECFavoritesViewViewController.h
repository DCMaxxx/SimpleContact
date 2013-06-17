//
//  BCFavoritesViewViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ECFavoritesViewViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray * favoriteContacts;

- (IBAction)goBackToContacts;

@end
