//
//  BCFavoriteCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ECFavoriteNumber;

@interface ECFavoriteCell : UICollectionViewCell

- (void)setInformationsWithNumber:(ECFavoriteNumber *)number;

@end
