//
//  BCFavoritesHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { eCNKPhone, eCNKMail, eCNKText } eContactNumberKind;

@class BCContact;

@interface BCFavoritesHandler : NSObject

+ (void)toogleContact:(BCContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind;
+ (void)areFavoriteForContact:(BCContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind;

@end
