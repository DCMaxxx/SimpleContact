//
//  BCContactList.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCContactList.h"

@interface BCContactList ()

@property (nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSMutableArray * contacts;
@property (strong, nonatomic) NSMutableDictionary * favorites;

@end


@implementation BCContactList

@synthesize addressBook = _addressBook;
@synthesize contacts = _contacts;
@synthesize favorites = _favorites;

-(id) init {
    if (self = [super init]) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName, (void *)kABPersonFirstNameProperty);
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        _contacts = [NSMutableArray arrayWithCapacity:[allPersons count]];

        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            BCContact * contact = [[BCContact alloc] initWithAddressBookContact:currentPerson];
            id isFavObj = [_favorites objectForKey:[NSNumber numberWithInteger:[contact UID]]];
            if (!isFavObj) {
                [_favorites setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
                [contact setFavorite:NO];
            } else
                [contact setFavorite:[isFavObj boolValue]];
            [_contacts insertObject:contact atIndex:i];
        }
    }
    return self;
}

- (BCContact *) contactAtIndex:(NSUInteger)index {
    return [_contacts objectAtIndex:index];
}

- (NSUInteger) numberOfContacts {
    return [_contacts count];
}

- (void) changeFavForContactAtIndex:(NSUInteger)index {
    BCContact * contact = [self contactAtIndex:index];
    BOOL newStatus = ![contact favorite];
    [contact setFavorite:newStatus];

    [_favorites setObject:[NSNumber numberWithBool:newStatus] forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
}
@end
