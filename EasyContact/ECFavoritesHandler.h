//
//  BCFavoritesHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECKindHandler.h"

@class ECContactList;
@class ECContact;


@interface ECFavoritesHandler : NSObject

+ (ECFavoritesHandler *)sharedInstance;

- (void)toogleContact:(ECContact *)contact number:(NSString *)number atIndex:(NSUInteger)idx ofKind:(eContactNumberKind)kind;
- (BOOL)isFavoriteWithContact:(ECContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind;
- (NSArray *)getAllFavoritesWithContactList:(ECContactList *)list;
- (void) saveModifications;

@end
