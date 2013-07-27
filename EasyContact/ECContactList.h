//
//  BCContactList.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECContact.h"


@interface ECContactList : NSObject

- (NSUInteger)numberOfInitials;
- (NSString *)initialAtIndex:(NSUInteger)index;
- (NSArray *)contactsForInitialAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfContactsForInitialAtIndex:(NSUInteger)index;
- (ECContact *)getContactFromUID:(NSUInteger)UID;
- (void)sortArrayAccordingToSettings;
- (NSArray *)filterWithText:(NSString *)text;

@end
