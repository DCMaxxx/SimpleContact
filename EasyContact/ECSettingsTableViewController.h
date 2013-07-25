//
//  ECSettingsTableViewController.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 05/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum { eTTVKDefault = 4341, eTTVKListOrder, eTTVKContactKind, eTTVKFavoriteOrder } eTagTableViewKind;

typedef enum { eTCVShowImages = 4242, eTCVFirstName, eTCVLastName, eTCVNickName,
    eTCVPhone, eTCVMail, eTCVMessage, eTCVFaceTime } eTagCellValue;


@interface ECSettingsTableViewController : UITableViewController

@property eTagTableViewKind kind;

@end
