//
//  BCFavoriteCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECFavorite;


@interface ECFavoriteCell : UICollectionViewCell

@property (strong, nonatomic) ECFavorite * number;

- (void)setInformationsWithNumber:(ECFavorite *)number;

@end
