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

- (BCContact *)contactAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfContacts;
- (void)changeFavForContactAtIndex:(NSUInteger)index;

@end
