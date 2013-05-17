//
//  BCContact.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface BCContact : NSObject

@property (nonatomic, readonly) ABRecordRef addBookContact;

@property (nonatomic) BOOL favorite;

@property (nonatomic, readonly) NSInteger UID;

@property (strong, nonatomic, readonly) NSString * firstName;
@property (strong, nonatomic, readonly) NSString * lastName;
@property (strong, nonatomic, readonly) UIImage * picture;

@property (strong, nonatomic, readonly) NSArray * phoneNumbers;
@property (nonatomic, readonly) NSInteger numberOfPhoneNumbers;

@property (strong, nonatomic, readonly) NSArray * mailAddresses;
@property (nonatomic, readonly) NSInteger numberOfMailAddresses;

@property (strong, nonatomic, readonly) NSArray * textAddresses;
@property (nonatomic, readonly) NSInteger numberOfTextAddresses;

- (id) initWithAddressBookContact:(ABRecordRef)addBookContact;

@end
