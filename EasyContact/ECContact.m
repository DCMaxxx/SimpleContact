//
//  BCContact.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECContact.h"

#import "ECFavoritesHandler.h"


@interface ECContact ()

@property (nonatomic, readonly) ABRecordRef addBookContact;

@end


@implementation ECContact

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize picture = _picture;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize numberOfPhoneNumbers = _numberOfPhoneNumbers;
@synthesize mailAddresses = _mailAddresses;
@synthesize numberOfMailAddresses = _numberOfMailAddresses;
@synthesize textAddresses = _textAddresses;
@synthesize numberOfTextAddresses = _numberOfTextAddresses;


#pragma - mark Init
-(id)initWithAddressBookContact:(ABRecordRef)addBookContact {
    if (self = [super init]) {
        _numberOfPhoneNumbers = -1;
        _numberOfMailAddresses = -1;
        _numberOfTextAddresses = -1;
        _addBookContact = addBookContact;

        CFDataRef pic = ABPersonCopyImageData(_addBookContact);
        if (pic)
            _picture = [UIImage imageWithData:(__bridge_transfer NSData *)pic];
        else
            _picture = [UIImage imageNamed:@"unknown-user.png"];
    }
    return self;
}


#pragma - mark Getters overrides
-(NSString *)firstName {
    if (!_firstName)
        _firstName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonFirstNameProperty);
    return _firstName;
}

-(NSString *)lastName {
    if (!_lastName)
        _lastName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonLastNameProperty);
    return _lastName;
}

-(NSInteger)UID {
    return ABRecordGetRecordID(_addBookContact);
}

-(NSInteger)numberOfPhoneNumbers {
    if (_numberOfPhoneNumbers == -1)
        [self phoneNumbers];
    return _numberOfPhoneNumbers;
}

-(NSArray *)phoneNumbers {
    if (!_phoneNumbers) {
        NSMutableArray * mutablePhoneNumbers = [[NSMutableArray alloc] init];

        ABMultiValueRef const * phones = ABRecordCopyValue(_addBookContact, kABPersonPhoneProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            CFRelease(phoneNumberRef);
            CFRelease(locLabel);
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phoneLabel, @"label", phoneNumber, @"value", nil];
            [mutablePhoneNumbers addObject:tmp];
        }
        _numberOfPhoneNumbers = [mutablePhoneNumbers count];
        [ECFavoritesHandler areFavoriteForContact:self numbers:mutablePhoneNumbers ofKind:eCNKPhone];
        _phoneNumbers = [mutablePhoneNumbers copy];
    }
    return _phoneNumbers;
}

-(NSInteger)numberOfMailAddresses {
    if (_numberOfMailAddresses == -1)
        [self mailAddresses];
    return _numberOfMailAddresses;
}

-(NSArray *)mailAddresses {
    if (!_mailAddresses) {
        NSMutableArray * mutableMailAddresses = [[NSMutableArray alloc] init];
        
        ABMultiValueRef const * mails = ABRecordCopyValue(_addBookContact, kABPersonEmailProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(mails); j++) {
            CFStringRef mailRef = ABMultiValueCopyValueAtIndex(mails, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(mails, j);
            NSString *mailLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *mailAddress = (__bridge NSString *)mailRef;
            CFRelease(mailRef);
            CFRelease(locLabel);
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mailLabel, @"label", mailAddress, @"value", nil];
            [mutableMailAddresses addObject:tmp];
        }
        _numberOfMailAddresses = [mutableMailAddresses count];
        [ECFavoritesHandler areFavoriteForContact:self numbers:mutableMailAddresses ofKind:eCNKMail];
        _mailAddresses = [mutableMailAddresses copy];
    }
    return _mailAddresses;
}

-(NSArray *)textAddresses {
    if (!_phoneNumbers)
        [self phoneNumbers];
    if (!_mailAddresses)
        [self mailAddresses];
    if (!_textAddresses) {
        NSMutableArray * mutableTextAddess = [[[self deepCopy:_phoneNumbers] arrayByAddingObjectsFromArray:[self deepCopy:_mailAddresses]] mutableCopy];
        _numberOfTextAddresses = [mutableTextAddess count];
        [ECFavoritesHandler areFavoriteForContact:self numbers:mutableTextAddess ofKind:eCNKText];
        _textAddresses = [mutableTextAddess copy];
    }
    return _textAddresses;
}

-(NSInteger)numberOfTextAddresses {
    if (_numberOfTextAddresses == -1)
        [self textAddresses];
    return _numberOfTextAddresses;
}


#pragma - mark Misc private functions
- (NSMutableArray *)deepCopy:(NSArray *)array {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (NSMutableDictionary * dic in array) {
        NSMutableDictionary * copy = [[NSMutableDictionary alloc] init];
        [copy setObject:[NSString stringWithString:[dic objectForKey:@"label"]] forKey:@"label"];
        [copy setObject:[NSString stringWithString:[dic objectForKey:@"value"]] forKey:@"value"];
        [result addObject:copy];
    }
    return result;
}

@end