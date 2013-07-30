//
//  BCContact.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 01/02/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECContact.h"

#import "ECSettingsHandler.h"
#import "ECKindHandler.h"

@interface ECContact ()

@property (nonatomic, readonly) ABRecordRef addBookContact;
@property (strong, nonatomic) NSMutableDictionary * addresses;

@end

static NSString * const lgLabelKey = @"label";
static NSString * const lgAddressKey = @"value";


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECContact

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize nickName = _nickName;

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithAddressBookContact:(ABRecordRef)addBookContact {
    if (self = [super init]) {
        _addresses = [[NSMutableDictionary alloc] init];
        _addBookContact = addBookContact;

        CFDataRef pic = ABPersonCopyImageData(_addBookContact);
        if (pic)
            _picture = [UIImage imageWithData:(__bridge_transfer NSData *)pic];
        else
            _picture = [UIImage imageNamed:@"unknown-user.png"];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Getting values
/*----------------------------------------------------------------------------*/
- (NSString *)importantName {
    if ([[ECSettingsHandler sharedInstance] getOption:eSOFirstName ofCategory:eSCListOrder])
        return [self firstName];
    return [self lastName];
}

- (NSString *)secondaryName {
    if ([[ECSettingsHandler sharedInstance] getOption:eSOFirstName ofCategory:eSCListOrder])
        return [self lastName];
    return [self firstName];
}

- (NSString *)favoriteName {
    if ([[ECSettingsHandler sharedInstance] getOption:eSOFirstName ofCategory:eSCFavoriteOrder])
        return [self firstName];
    else if ([[ECSettingsHandler sharedInstance] getOption:eSOLastName ofCategory:eSCFavoriteOrder])
        return [self lastName];
    return [self nickName];
}

- (NSString *)firstName {
    if (!_firstName) {
        _firstName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonFirstNameProperty);
        if (!_firstName)
            _firstName = @"";
    }
    return _firstName;
}

- (NSString *)lastName {
    if (!_lastName) {
        _lastName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonLastNameProperty);
        if (!_lastName)
            _lastName = @"";
    }
    return _lastName;
}

- (NSString *)nickName {
    if (!_nickName) {
        _nickName = (__bridge_transfer NSString *)ABRecordCopyValue(_addBookContact, kABPersonNicknameProperty);
        if (!_nickName)
            _nickName = @"";
    }
    return _nickName;
}

- (NSInteger)UID {
    return ABRecordGetRecordID(_addBookContact);
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced getters
/*----------------------------------------------------------------------------*/
- (NSInteger)numberOf:(eContactNumberKind)kind {
    NSArray * selectors = @[@"numberOfPhones",
                            @"numberOfMails",
                            @"numberOfTexts",
                            @"numberOfFaceTimes"];
    SEL selector = NSSelectorFromString([selectors objectAtIndex:kind]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [[self performSelector:selector] integerValue];
#pragma clang diagnostic pop
    }
    return 0;
}

- (NSArray *)addessesOf:(eContactNumberKind)kind {
    NSArray * selectors = @[@"phones",
                            @"mails",
                            @"texts",
                            @"facetimes"];
    SEL selector = NSSelectorFromString([selectors objectAtIndex:kind]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector];
#pragma clang diagnostic pop
    }
    return [[NSArray alloc] init];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced setters
/*----------------------------------------------------------------------------*/
- (void)toogleFavoriteForNumber:(NSString *)number andKind:(eContactNumberKind)kind {
    [[ECFavoritesHandler sharedInstance] areFavoriteForContact:self numbers:[_addresses objectForKey:[ECKindHandler kindToString:kind]] ofKind:kind];
}

/*----------------------------------------------------------------------------*/
#pragma mark - Hidden getters
/*----------------------------------------------------------------------------*/
- (NSNumber *)numberOfPhones {
    return [NSNumber numberWithInt:[[self phones] count]];
}

- (NSNumber *)numberOfMails {
    return [NSNumber numberWithInt:[[self mails] count]];
}

- (NSNumber *)numberOfTexts {
    return [NSNumber numberWithInt:[[self texts] count]];
}

- (NSNumber *)numberOfFaceTimes {
    return [NSNumber numberWithInt:[[self facetimes] count]];
}

- (NSArray *)phones {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKPhone]];
    if (!result) {
        result = [[NSMutableArray alloc] init];
        
        ABMultiValueRef const * phones = ABRecordCopyValue(_addBookContact, kABPersonPhoneProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            if (phoneNumberRef)
                CFRelease(phoneNumberRef);
            if (locLabel)
                CFRelease(locLabel);
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phoneLabel, lgLabelKey, phoneNumber, lgAddressKey, nil];
            [result addObject:tmp];
        }
        [[ECFavoritesHandler sharedInstance] areFavoriteForContact:self numbers:result ofKind:eCNKPhone];
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKPhone]];
    }
    return result;
}

- (NSArray *)mails {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKMail]];
    if (!result) {
        result = [[NSMutableArray alloc] init];
        
        ABMultiValueRef const * mails = ABRecordCopyValue(_addBookContact, kABPersonEmailProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(mails); j++) {
            CFStringRef mailRef = ABMultiValueCopyValueAtIndex(mails, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(mails, j);
            NSString *mailLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *mailAddress = (__bridge NSString *)mailRef;
            if (mailRef)
                CFRelease(mailRef);
            if (locLabel)
                CFRelease(locLabel);
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mailLabel, lgLabelKey, mailAddress, lgAddressKey, nil];
            [result addObject:tmp];
        }
        [[ECFavoritesHandler sharedInstance] areFavoriteForContact:self numbers:result ofKind:eCNKMail];
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKMail]];
    }
    return result;

}

- (NSArray *)texts {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKText]];
    if (!result) {
        NSMutableArray * phones = [self deepCopy:[self phones]];
        NSMutableArray * mails = [self deepCopy:[self mails]];
        result = [[phones arrayByAddingObjectsFromArray:mails] mutableCopy];
        [[ECFavoritesHandler sharedInstance] areFavoriteForContact:self numbers:result ofKind:eCNKText];
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKText]];
    }
    return result;
}

- (NSArray *)facetimes {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKFaceTime]];
    if (!result) {
        result = [self deepCopy:[self texts]];
        [[ECFavoritesHandler sharedInstance] areFavoriteForContact:self numbers:result ofKind:eCNKFaceTime];
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKFaceTime]];
    }
    return result;
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc hidden methods
/*----------------------------------------------------------------------------*/
- (NSMutableArray *)deepCopy:(NSArray *)array {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (NSMutableDictionary * dic in array) {
        NSMutableDictionary * copy = [[NSMutableDictionary alloc] init];
        [copy setObject:[NSString stringWithString:[dic objectForKey:lgLabelKey]] forKey:lgLabelKey];
        [copy setObject:[NSString stringWithString:[dic objectForKey:lgAddressKey]] forKey:lgAddressKey];
        [result addObject:copy];
    }
    return result;
}

@end