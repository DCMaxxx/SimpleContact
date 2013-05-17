//
//  BCModalListView.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 06/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCContact;

typedef enum ModalTypeView { MTVPhone, MTVMail, MTVText } eModalTypeView;

@interface BCModalListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureType;
@property (weak, nonatomic) IBOutlet UIImageView *pictureContact;

- (void)setType:(eModalTypeView)type;
- (void)setStyle;
- (void)setContactPic:(UIImage *)pic;

@end
