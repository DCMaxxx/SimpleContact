//
//  BCContactList.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCContactList.h"

static NSString * plistFileName = @"favorites.plist";

@implementation BCContactList

-(id) init {
    if (self = [super init]) {
        BOOL writePlist = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *plistFile = [documentsPath stringByAppendingPathComponent:plistFileName];

        _favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
        if (!_favPlist) {
            _favPlist = [NSMutableDictionary new];
            writePlist = YES;
        }
        
        // Loading addressbook
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName, (void *)kABPersonFirstNameProperty);
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        _contacts = [NSMutableArray arrayWithCapacity:[allPersons count]];
        
        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            BCContact * contact = [[BCContact alloc] initWithAddressBookContact:currentPerson];
            id isFavObj = [_favPlist objectForKey:[NSNumber numberWithInteger:[contact getUID]]];
            if (!isFavObj) {
                [_favPlist setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", [contact getUID]]];
                [contact setFavorite:!(arc4random() % 2)];
                writePlist = YES;
                
            } else
                [contact setFavorite:[isFavObj boolValue]];
            [_contacts insertObject:contact atIndex:i];
        }
        if (writePlist)
            [_favPlist writeToFile:plistFile atomically:YES];
    }
    NSLog(@"Nombre de contacts (1) : %d", [_contacts count]);
    return self;
}

- (BCContact *) contactAtIndex:(NSUInteger)index {
    return [_contacts objectAtIndex:index];
}

- (NSUInteger) numberOfContacts {
    return [_contacts count];
}

- (BOOL) changeFavForContactAtIndex:(NSUInteger)index {
    BCContact * contact = [self contactAtIndex:index];
    BOOL newStatus = ![contact favorite];
    [contact setFavorite:newStatus];

    [_favPlist setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", [contact getUID]]];
    [self updateFavorites];    return newStatus;
}

- (void) updateFavorites {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistFile = [documentsPath stringByAppendingPathComponent:plistFileName];

    [_favPlist writeToFile:plistFile atomically:YES];
}

@end
