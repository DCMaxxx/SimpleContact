//
//  BCContactList.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 11/03/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECContactList.h"


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

        // Loading all contacts from address book
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
        CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(peopleMutable)), (CFComparatorFunction) ABPersonComparePeopleByName, (void *)kABPersonFirstNameProperty);
        NSArray * allPersons = (__bridge_transfer NSArray *)peopleMutable;
        
        // Loading all contacts to array
        for (NSUInteger i = 0; i < [allPersons count]; ++i) {
            ABRecordRef currentPerson = (__bridge ABRecordRef)[allPersons objectAtIndex:i];
            ECContact * contact = [[ECContact alloc] initWithAddressBookContact:currentPerson];
            
            NSString * sectionTitle = [[contact firstName] substringToIndex:1];
            NSRange idx = [sections rangeOfString:sectionTitle options:NSCaseInsensitiveSearch];
            if (idx.location == NSNotFound) // Starts without a letter, put it in #
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

- (NSArray *) getFavoriteContacts {
    NSArray * array = [[NSArray alloc] init];
    // Will be removed soon
    return array;
}

@end