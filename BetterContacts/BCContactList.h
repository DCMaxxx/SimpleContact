//
//  BCContactList.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCContact.h"

@interface BCContactList : NSObject

- (void) toogleFavoriteForContact:(BCContact *)contact;
- (NSArray *) getFavoriteContacts;

- (NSUInteger) numberOfInitials;
- (NSString *) initialAtIndex:(NSUInteger)index;
- (NSArray *) contactsForInitialAtIndex:(NSUInteger)index;
- (NSUInteger) numberOfContactsForInitialAtIndex:(NSUInteger)index;

@end
