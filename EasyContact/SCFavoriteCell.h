//
//  BCFavoriteCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCFavorite;


@interface SCFavoriteCell : UICollectionViewCell

@property (strong, nonatomic) SCFavorite * number;

- (void)setInformationsWithNumber:(SCFavorite *)number;

@end
