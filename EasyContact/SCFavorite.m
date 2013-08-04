//
//  ECFavoriteNumber.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 18/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCFavorite.h"

#import "SCContact.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCFavorite

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithContact:(SCContact *)contact kind:(eContactNumberKind)kind andNumber:(NSString *) contactNumber {
    if (self = [super init]) {
        _contactNumber = contactNumber;
        _kind = kind;
        _contact = contact;
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Comparison
/*----------------------------------------------------------------------------*/
- (NSComparisonResult)compare:(SCFavorite *)number {
    NSComparisonResult res = [[_contact favoriteName] compare:[[number contact] favoriteName] options:NSCaseInsensitiveSearch];
    if (res == NSOrderedSame) {
        res = [[_contact lastName] compare:[[number contact] lastName]];
        if (res == NSOrderedSame)
            res = (_kind < [number kind] ? NSOrderedAscending : (_kind > [number kind] ? NSOrderedDescending : NSOrderedSame));
    }
    return res;
}

@end
