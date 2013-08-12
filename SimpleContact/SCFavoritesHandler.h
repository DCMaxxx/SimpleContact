//
//  BCFavoritesHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCKindHandler.h"

@class SCContactList;
@class SCContact;


@interface SCFavoritesHandler : NSObject

+ (SCFavoritesHandler *)sharedInstance;

- (void)toogleContact:(SCContact *)contact number:(NSString *)number atIndex:(NSUInteger)idx ofKind:(eContactNumberKind)kind;
- (BOOL)isFavoriteWithContact:(SCContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind;
- (NSArray *)getAllFavoritesWithContactList:(SCContactList *)list;
- (void) saveModifications;

@end
