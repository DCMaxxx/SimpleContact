//
//  ECFavoriteNumber.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 18/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECFavoriteNumber.h"

#import "ECContact.h"


@implementation ECFavoriteNumber

- (id)initWithContact:(ECContact *)contact kind:(eContactNumberKind)kind andNumber:(NSString *) contactNumber {
    if (self = [super init]) {
        _contactNumber = contactNumber;
        _kind = kind;
        _contact = contact;
    }
    return self;
}

- (NSComparisonResult)compare:(ECFavoriteNumber *)number {
    NSComparisonResult res = [[_contact firstName] compare:[[number contact] firstName]];
    if (res == NSOrderedSame) {
        res = [[_contact lastName] compare:[[number contact] lastName]];        if (res == NSOrderedSame)
            res = (_kind < [number kind] ? NSOrderedAscending : (_kind > [number kind] ? NSOrderedDescending : NSOrderedSame));
    }
    return res;
}

@end
