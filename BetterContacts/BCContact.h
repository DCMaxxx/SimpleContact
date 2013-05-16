//
//  BCContact.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface BCContact : NSObject {
    NSString * _firstName;
    NSString * _lastName;
    UIImage * _picture;
    NSMutableArray * _phoneNumbers;
    NSInteger _numberOfPhoneNumbers;
    NSMutableArray * _mailAddresses;
    NSInteger _numberOfMailAddresses;
    NSMutableArray * _messageAddresses;
    NSInteger _numberOfMessageAddresses;
}

@property (nonatomic) BOOL favorite;
@property (nonatomic, readonly) ABRecordRef addBookContact;

#pragma mark Init
- (id) initWithAddressBookContact:(ABRecordRef)addBookContact;


#pragma mark Getting user informations
- (NSString *)getFirstName;
- (NSString *)getLastName;
- (UIImage *)getPicture;
- (NSInteger)getUID;
- (NSArray *)getPhoneNumbers;
- (NSInteger)getNumberOfPhoneNumbers;
- (NSArray *)getMailAddresses;
- (NSInteger)getNumberOfMailAddresses;
- (NSArray *)getMessageAddresses;
- (NSInteger)getNumberOfMessageAddresses;

@end
