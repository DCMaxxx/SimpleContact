//
//  ECSettingsHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 25/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ** Linked with ECSettingsTableView's tags, be sure to change both
 */
typedef enum { eSCDefault = 4341, eSCListOrder, eSCContactKind, eSCFavoriteOrder } eSettingsCategory;

typedef enum { eSOShowImages = 4242, eSOFirstName, eSOLastName, eSONickName,
    eSOPhone, eSOMail, eSOMessage, eSOFaceTime } eSettingsOption;


@interface ECSettingsHandler : NSObject

+ (ECSettingsHandler *)sharedInstance;

- (BOOL)getOption:(eSettingsOption)option ofCategory:(eSettingsCategory)category;
- (void)setOption:(eSettingsOption)option ofCategory:(eSettingsCategory)category withValue:(BOOL)value;
- (void)setUnavailableContactOption:(eSettingsOption)option;
- (BOOL)isKindAvailable:(eSettingsOption)option;
- (void)saveModifications;
- (void)reloadSettings;

@end
