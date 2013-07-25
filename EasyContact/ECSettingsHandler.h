//
//  ECSettingsHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 25/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECSettingsTableViewController.h"

@interface ECSettingsHandler : NSObject

+ (ECSettingsHandler *)sharedInstance;
- (BOOL)getOption:(eTagCellValue)option ofCategory:(eTagTableViewKind)category;
- (void)setOption:(eTagCellValue)option ofCategory:(eTagTableViewKind)category withValue:(BOOL)value;
- (void)saveModifications;

@end
