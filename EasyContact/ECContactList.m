//
//  BCContactList.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECContactList.h"

#import "ECSettingsHandler.h"


@interface ECContactList ()

@property (nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSMutableArray * sectionnedContacts;
@property (strong, nonatomic) NSMutableDictionary * sectionsIndexes;
@property (strong, nonatomic) NSMutableDictionary * favorites;

@end


@implementation ECContactList

#pragma - mark Init
-(id) init {
    if (self = [super init]) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (!_addressBook)
            return nil;
        
        NSString * sections = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
        _sectionnedContacts = [[NSMutableArray alloc] initWithCapacity:[sections length]];
        for (NSInteger i = 0; i < [sections length]; ++i) {
            NSString * character = [sections substringWithRange:NSMakeRange(i, 1)];
            NSMutableDictionary * section = [[NSMutableDictionary alloc] init];
            [section setObject:character forKey:@"initial"];
            [section setObject:[[NSMutableArray alloc] init] forKey:@"contacts"];
            [_sectionnedContacts addObject:section];
        }
        
        BOOL orderByFirstName = [[ECSettingsHandler sharedInstance] getOption:eSOFirstName ofCategory:eSCListOrder];
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*)(orderByFirstName ? kABPersonFirstNameProperty : kABPersonLastNameProperty));
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            ECContact * contact = [[ECContact alloc] initWithAddressBookContact:currentPerson];
            
            NSRange idx;
            if ([[contact importantName] length]) {
                NSString * sectionTitle = [[contact importantName] substringToIndex:1];
                 idx = [sections rangeOfString:sectionTitle options:NSCaseInsensitiveSearch];
            } else
                idx.location = NSNotFound;
            if (idx.location == NSNotFound)
                idx.location = [sections length] - 1;
            NSMutableDictionary * dic = [_sectionnedContacts objectAtIndex:idx.location];
            NSMutableArray * contacts = [dic objectForKey:@"contacts"];
            [contacts addObject:contact];
        }
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

- (ECContact *) getContactFromUID:(NSUInteger)UID {
    for (NSDictionary * section in _sectionnedContacts) {
        for (ECContact * contact in [section objectForKey:@"contacts"]) {
            if ([contact UID] == UID)
                return contact;
        }
    }
    return nil;
}

- (void)sortArrayAccordingToSettings {
    NSString * sections = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
    NSMutableArray * newSections = [[NSMutableArray alloc] initWithCapacity:[sections length]];
    for (NSInteger i = 0; i < [sections length]; ++i) {
        NSString * character = [sections substringWithRange:NSMakeRange(i, 1)];
        NSMutableDictionary * section = [[NSMutableDictionary alloc] init];
        [section setObject:character forKey:@"initial"];
        [section setObject:[[NSMutableArray alloc] init] forKey:@"contacts"];
        [newSections addObject:section];
    }
    
    for (NSMutableDictionary * section in _sectionnedContacts) {
        for (ECContact * contact in [section objectForKey:@"contacts"]) {
            NSRange idx;
            if ([[contact importantName] length]) {
                NSString * sectionTitle = [[contact importantName] substringToIndex:1];
                idx = [sections rangeOfString:sectionTitle options:NSCaseInsensitiveSearch];
            } else
                idx.location = NSNotFound;
            if (idx.location == NSNotFound)
                idx.location = [sections length] - 1;
            NSMutableDictionary * dic = [newSections objectAtIndex:idx.location];
            NSMutableArray * contacts = [dic objectForKey:@"contacts"];
            [contacts addObject:contact];
        }
    }
    _sectionnedContacts = newSections;
}

@end