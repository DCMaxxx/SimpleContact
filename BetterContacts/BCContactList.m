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
@property (strong, nonatomic) NSMutableArray * sectionnedContacts;
@property (strong, nonatomic) NSMutableDictionary * sectionsIndexes;
@property (strong, nonatomic) NSMutableDictionary * favorites;

@end

@implementation BCContactList

@synthesize addressBook = _addressBook;
@synthesize sectionnedContacts = _sectionnedContacts;
@synthesize sectionsIndexes = _sectionsIndexes;
@synthesize favorites = _favorites;

#pragma - mark Init
-(id) init {
    if (self = [super init]) {
        
        // Initializing sections
        static NSString * sections = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
        _sectionnedContacts = [[NSMutableArray alloc] initWithCapacity:[sections length]];
        for (NSInteger i = 0; i < [sections length]; ++i) {
            NSString * character = [sections substringWithRange:NSMakeRange(i, 1)];
            NSMutableDictionary * section = [[NSMutableDictionary alloc] init];
            [section setObject:character forKey:@"initial"];
            [section setObject:[[NSMutableArray alloc] init] forKey:@"contacts"];
            [_sectionnedContacts addObject:section];
        }
        
        // Loading favorites from plist
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            _favorites = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        else
            _favorites = [[NSMutableDictionary alloc] init];

        // Loading all contacts from address book
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName, (void *)kABPersonFirstNameProperty);
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        // Loading all contacts to array
        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            BCContact * contact = [[BCContact alloc] initWithAddressBookContact:currentPerson];
            id isFavObj = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
            if (!isFavObj) {
                [_favorites setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
                [contact setFavorite:NO];
            } else
                [contact setFavorite:[isFavObj boolValue]];
            
            NSString * sectionTitle = [[contact firstName] substringToIndex:1];
            NSRange idx = [sections rangeOfString:sectionTitle options:NSCaseInsensitiveSearch];
            if (idx.location == NSNotFound) // Starts without a letter, put it in #
                idx.location = [sections length] - 1;
            NSMutableDictionary * dic = [_sectionnedContacts objectAtIndex:idx.location];
            NSMutableArray * contacts = [dic objectForKey:@"contacts"];
            [contacts addObject:contact];
        }
        [_favorites writeToFile:filePath atomically:YES];
    }
    return self;
}


#pragma - mark Getting informations
- (NSUInteger) numberOfInitials {
    return [_sectionnedContacts count];
}

- (NSString *) initialAtIndex:(NSUInteger)index {
    return [(NSDictionary *)[_sectionnedContacts objectAtIndex:index] objectForKey:@"initial"];
}

- (NSArray *) contactsForInitialAtIndex:(NSUInteger)index {
    return [(NSDictionary *)[_sectionnedContacts objectAtIndex:index] objectForKey:@"contacts"];
}

- (NSUInteger) numberOfContactsForInitialAtIndex:(NSUInteger)index {
    NSArray * contacts = [self contactsForInitialAtIndex:index];
    return [contacts count];
}

- (NSArray *) getFavoriteContacts {
    NSPredicate * pred = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary * bindings) {
        return [(BCContact *)obj favorite];
    }];
    NSArray * array = [[NSArray alloc] init];
    for (NSDictionary * section in _sectionnedContacts) {
        NSArray * contactsOfSection = [section objectForKey:@"contacts"];
        array = [array arrayByAddingObjectsFromArray:[contactsOfSection filteredArrayUsingPredicate:pred]];
    }
    return array;
}


#pragma - mark Setting informations
- (void) toogleFavoriteForContact:(BCContact *)contact {
    BOOL newStatus = ![contact favorite];
    [contact setFavorite:newStatus];

    [_favorites setObject:[NSNumber numberWithBool:newStatus] forKey:[NSString stringWithFormat:@"%d", [contact UID]]];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
    [_favorites writeToFile:filePath atomically:YES];
}

@end
