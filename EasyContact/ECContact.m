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

static NSString * const DicKeyLabel = @"label";
static NSString * const DicKeyValue = @"value";
static NSString * const DicKeyFavorite = @"favorite";


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
        NSString * const ImgUnknownUser = @"unknown-user.png";

        _addresses = [[NSMutableDictionary alloc] init];
        _addBookContact = addBookContact;

        CFDataRef pic = ABPersonCopyImageData(_addBookContact);
        if (pic)
            _picture = [UIImage imageWithData:(__bridge_transfer NSData *)pic];
        else
            _picture = [UIImage imageNamed:ImgUnknownUser];
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
    SEL selector = [ECKindHandler selectorForKind:kind prefix:@"numberOf" andSuffix:@"s"];
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [[self performSelector:selector] integerValue];
#pragma clang diagnostic pop
    }
    return 0;
}

- (NSArray *)addessesOf:(eContactNumberKind)kind {
    SEL selector = [ECKindHandler selectorForKind:kind prefix:@"addressesFor" andSuffix:nil];
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector];
#pragma clang diagnostic pop
    }
    return [[NSArray alloc] init];
}

- (NSString *)addressValueWithKind:(eContactNumberKind)kind andIndex:(NSUInteger)idx {
    NSArray * addresses = [self addessesOf:kind];
    if (idx >= [addresses count])
        return nil;
    return [[addresses objectAtIndex:idx] objectForKey:DicKeyValue];
}

- (NSString *)addressLabelWithKind:(eContactNumberKind)kind andIndex:(NSUInteger)idx {
    NSArray * addresses = [self addessesOf:kind];
    if (idx >= [addresses count])
        return nil;
    return [[addresses objectAtIndex:idx] objectForKey:DicKeyLabel];
}

- (BOOL)addressIsFavoriteWithKind:(eContactNumberKind)kind andIndex:(NSUInteger)idx {
    NSArray * addresses = [self addessesOf:kind];
    if (idx >= [addresses count])
        return NO;
    NSNumber * nb = [[addresses objectAtIndex:idx] objectForKey:DicKeyFavorite];
    return nb && [nb boolValue];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced setters
/*----------------------------------------------------------------------------*/
- (void)toogleFavoriteForNumber:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSArray * addresses = [self addessesOf:kind];
    for (NSUInteger i = 0; i < [addresses count]; ++i) {
        if ([[self addressValueWithKind:kind andIndex:i] isEqualToString:number]) {
            NSMutableDictionary * number = [addresses objectAtIndex:i];
            BOOL isFavorite = [self addressIsFavoriteWithKind:kind andIndex:i];
            [number setObject:@(!isFavorite) forKey:DicKeyFavorite];
            break ;
        }
    }
    
}

- (void)toogleFavoriteForNumberWithKind:(eContactNumberKind)kind atIndex:(NSUInteger)idx {
    NSArray * addresses = [self addessesOf:kind];
    if (idx >= [addresses count])
        return ;
    NSMutableDictionary * number = [addresses objectAtIndex:idx];
    BOOL isFavorite = [self addressIsFavoriteWithKind:kind andIndex:idx];
    [number setObject:@(!isFavorite) forKey:DicKeyFavorite];
}

- (void)setFavorite:(BOOL)isFavorite forNumberWithKind:(eContactNumberKind)kind atIndex:(NSUInteger)idx {
    NSArray * addresses = [self addessesOf:kind];
    if (idx >= [addresses count])
        return ;
    NSMutableDictionary * number = [addresses objectAtIndex:idx];
    [number setObject:@(isFavorite) forKey:DicKeyFavorite];
}

/*----------------------------------------------------------------------------*/
#pragma mark - Hidden getters
/*----------------------------------------------------------------------------*/
- (NSNumber *)numberOfPhones {
    return [NSNumber numberWithInt:[[self addressesForPhone] count]];
}

- (NSNumber *)numberOfMails {
    return [NSNumber numberWithInt:[[self addressesForMail] count]];
}

- (NSNumber *)numberOfTexts {
    return [NSNumber numberWithInt:[[self addressesForText] count]];
}

- (NSNumber *)numberOfFaceTimes {
    return [NSNumber numberWithInt:[[self addressesForFaceTime] count]];
}

- (NSArray *)addressesForPhone {
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
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phoneLabel, DicKeyLabel, phoneNumber, DicKeyValue, nil];
            if ([[ECFavoritesHandler sharedInstance] isFavoriteWithContact:self number:phoneNumber ofKind:eCNKPhone])
                [tmp setObject:@(YES) forKey:DicKeyFavorite];
            [result addObject:tmp];
        }
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKPhone]];
    }
    return result;
}

- (NSArray *)addressesForMail {
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
            NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mailLabel, DicKeyLabel, mailAddress, DicKeyValue, nil];
            if ([[ECFavoritesHandler sharedInstance] isFavoriteWithContact:self number:mailAddress ofKind:eCNKMail])
                [tmp setObject:@(YES) forKey:DicKeyFavorite];
            [result addObject:tmp];
        }
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKMail]];
    }
    return result;

}

- (NSArray *)addressesForText {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKText]];
    if (!result) {
        NSMutableArray * phones = [self deepCopy:[self addressesForPhone]];
        NSMutableArray * mails = [self deepCopy:[self addressesForMail]];
        result = [[phones arrayByAddingObjectsFromArray:mails] mutableCopy];
        for (NSMutableDictionary * number in result) {
            if ([[ECFavoritesHandler sharedInstance] isFavoriteWithContact:self number:[number objectForKey:DicKeyValue] ofKind:eCNKText])
                [number setObject:@(YES) forKey:DicKeyFavorite];
        }
        [_addresses setObject:result forKey:[ECKindHandler kindToString:eCNKText]];
    }
    return result;
}

- (NSArray *)addressesForFaceTime {
    NSMutableArray * result = [_addresses objectForKey:[ECKindHandler kindToString:eCNKFaceTime]];
    if (!result) {
        result = [self deepCopy:[self addressesForText]];
        for (NSMutableDictionary * number in result) {
            if ([[ECFavoritesHandler sharedInstance] isFavoriteWithContact:self number:[number objectForKey:DicKeyValue] ofKind:eCNKFaceTime])
                [number setObject:@(YES) forKey:DicKeyFavorite];
        }
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
        [copy setObject:[NSString stringWithString:[dic objectForKey:DicKeyLabel]] forKey:DicKeyLabel];
        [copy setObject:[NSString stringWithString:[dic objectForKey:DicKeyValue]] forKey:DicKeyValue];
        [result addObject:copy];
    }
    return result;
}

@end