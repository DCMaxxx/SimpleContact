//
//  BCContact.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#import "ECFavoritesHandler.h"


@interface ECContact : NSObject

@property (nonatomic, readonly) NSInteger UID;
@property (strong, nonatomic, readonly) NSString * firstName;
@property (strong, nonatomic, readonly) NSString * lastName;
@property (strong, nonatomic, readonly) UIImage * picture;

- (id) initWithAddressBookContact:(ABRecordRef)addBookContact;
- (NSInteger) numberOf:(eContactNumberKind)kind;
- (NSArray *) addessesOf:(eContactNumberKind)kind;

@end
