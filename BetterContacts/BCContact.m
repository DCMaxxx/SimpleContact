//
//  BCContact.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCContact.h"

static UIImage * noPictureContact = nil;

@implementation BCContact

@synthesize favorite = _favorite;
@synthesize addBookContact = _addBookContact;

#pragma mark Init
- (id) initWithAddressBookContact:(ABRecordRef)addBookContact {
    if (self = [super init]) {
        if (!noPictureContact)
            noPictureContact = [UIImage imageNamed:@"user.png"];
        _numberOfPhoneNumbers = -1;
        _numberOfMailAddresses = -1;
        _numberOfMessageAddresses = -1;
        _addBookContact = addBookContact;
        _favorite = YES;
    }
    return self;
}


#pragma mark Getting user informations
- (NSString *) getFirstName {
    if (!_firstName)
        _firstName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonFirstNameProperty);
    return _firstName;
}

- (NSString *) getLastName {
    if (!_lastName)
        _lastName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonLastNameProperty);
    return _lastName;
}

- (UIImage *) getPicture {
    if (!_picture) {
        CFDataRef pic = ABPersonCopyImageData(_addBookContact);
        if (pic)
            _picture = [UIImage imageWithData:(__bridge_transfer NSData *)pic];
        else
            _picture = noPictureContact;
    }
    return _picture;
}

- (NSInteger)getUID {
    return ABRecordGetRecordID(_addBookContact);
}

- (NSInteger)getNumberOfPhoneNumbers {
    if (_numberOfPhoneNumbers == -1)
        [self getPhoneNumbers];
    return _numberOfPhoneNumbers;
}


- (NSArray *)getPhoneNumbers {
    if (!_phoneNumbers) {
        _phoneNumbers = [[NSMutableArray alloc] init];

        ABMultiValueRef const * phones = ABRecordCopyValue(_addBookContact, kABPersonPhoneProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            CFRelease(phoneNumberRef);
            CFRelease(locLabel);
            NSDictionary * tmp = [[NSDictionary alloc] initWithObjectsAndKeys:phoneLabel, @"label", phoneNumber, @"value", nil];
            [_phoneNumbers addObject:tmp];
        }
        _numberOfPhoneNumbers = [_phoneNumbers count];
    }
    return _phoneNumbers;
}

- (NSArray *)getMailAddresses {
    if (!_mailAddresses) {
        _mailAddresses = [[NSMutableArray alloc] init];
        
        ABMultiValueRef const * mails = ABRecordCopyValue(_addBookContact, kABPersonEmailProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(mails); j++) {
            CFStringRef mailRef = ABMultiValueCopyValueAtIndex(mails, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(mails, j);
            NSString *mailLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *mailAddress = (__bridge NSString *)mailRef;
            CFRelease(mailRef);
            CFRelease(locLabel);
            NSDictionary * tmp = [[NSDictionary alloc] initWithObjectsAndKeys:mailLabel, @"label", mailAddress, @"value", nil];
            [_mailAddresses addObject:tmp];
        }
        _numberOfMailAddresses = [_mailAddresses count];
    }
    return _mailAddresses;
}

- (NSInteger)getNumberOfMailAddresses {
    if (_numberOfMailAddresses == -1)
        [self getMailAddresses];
    return _numberOfMailAddresses;
}

- (NSArray *)getMessageAddresses {
    if (!_phoneNumbers)
        [self getPhoneNumbers];
    if (!_mailAddresses)
        [self getMailAddresses];
    if (!_messageAddresses) {
        _messageAddresses = [[_phoneNumbers arrayByAddingObjectsFromArray:_mailAddresses] mutableCopy];
        _numberOfMessageAddresses = [_messageAddresses count];
    }
    return _messageAddresses;
}

- (NSInteger)getNumberOfMessageAddresses {
    if (_numberOfMessageAddresses == -1)
        [self getMessageAddresses];
    return _numberOfMessageAddresses;
}


@end
