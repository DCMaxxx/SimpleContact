//
//  BCTwoLabelsCell.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCModalViewController;


@interface SCNumberCell : UITableViewCell

@property (weak, nonatomic) SCModalViewController * viewController;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) NSString * value;

- (void)isFavorite:(BOOL)favorite;

@end
