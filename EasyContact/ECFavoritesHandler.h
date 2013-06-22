//
//  BCFavoritesHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum { eCNKPhone, eCNKMail, eCNKText } eContactNumberKind;

@class ECContactList;
@class ECContact;

@interface ECFavoritesHandler : NSObject

+ (void)toogleContact:(ECContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind;
+ (void)areFavoriteForContact:(ECContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind;
+ (NSArray *)getAllFavoritesWithContactList:(ECContactList *)list;
+ (NSString *) kindToString:(eContactNumberKind)kind;
+ (eContactNumberKind) kindFromString:(NSString *)kind;

@end
