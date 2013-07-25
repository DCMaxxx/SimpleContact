//
//  BCFavoritesHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECFavoritesHandler.h"

#import "ECFavorite.h"
#import "ECContactList.h"
#import "ECContact.h"


@interface ECFavoritesHandler ()

@property NSMutableDictionary * favorites;
@property NSString * filePath;

@end


@implementation ECFavoritesHandler

+(ECFavoritesHandler *)sharedInstance {
    static dispatch_once_t pred;
    static ECFavoritesHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ECFavoritesHandler alloc] init];
    });
    return shared;
}

- (id) init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filePath = [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
            _favorites = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];
        else {
            _favorites = [[NSMutableDictionary alloc] init];
            NSString * bundle = [[NSBundle mainBundle] pathForResource:@"Favorites" ofType:@"plist"];
            [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:_filePath error:nil];
        }
    }
    return self;
}

#pragma - mark Handle favorites functions
- (void)toogleContact:(ECContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSMutableDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites) {
        contactFavorites = [[NSMutableDictionary alloc] init];
        [_favorites setObject:contactFavorites forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    }
    
    NSMutableDictionary * kindOfFavorites = [contactFavorites objectForKey:[ECKindHandler kindToString:kind]];
    if (!kindOfFavorites) {
        kindOfFavorites = [[NSMutableDictionary alloc] init];
        [contactFavorites setObject:kindOfFavorites forKey:[ECKindHandler kindToString:kind]];
    }
    
    NSNumber * isFavorite = [kindOfFavorites objectForKey:number];
    if (!isFavorite || ![isFavorite boolValue]) {
        isFavorite = [NSNumber numberWithBool:YES];
        [kindOfFavorites setObject:isFavorite forKey:number];
    } else
        [kindOfFavorites removeObjectForKey:number];
}

- (void)areFavoriteForContact:(ECContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind {
    if (![numbers count])
        return ;
    
    NSMutableDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        return ;
    
    NSMutableDictionary * kindOfFavorites = [contactFavorites objectForKey:[ECKindHandler kindToString:kind]];
    if (!kindOfFavorites)
        return ;
    
    for (NSMutableDictionary * number in numbers) {
        NSString * numberStr = [number objectForKey:@"value"];
        NSNumber * isFavorite = [kindOfFavorites objectForKey:numberStr];
        if (!isFavorite || ![isFavorite boolValue])
            [number setObject:[NSNumber numberWithBool:NO] forKey:@"favorite"];
        else
            [number setObject:[NSNumber numberWithBool:YES] forKey:@"favorite"];
    }
}

- (NSArray *)getAllFavoritesWithContactList:(ECContactList *)list {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for (NSString * contactUID in _favorites) {
        ECContact * contact = [list getContactFromUID:[contactUID intValue]];
        if (!contact)
            continue ;
        
        NSMutableDictionary * allKindOfFavorites = [_favorites objectForKey:contactUID];
        for (NSString * kindOfFavorite in allKindOfFavorites) {
            NSMutableDictionary * allNumbers = [allKindOfFavorites objectForKey:kindOfFavorite];
            for (NSString * number in allNumbers) {
                NSNumber * isFavorite = [allNumbers objectForKey:number];
                if ([isFavorite boolValue])
                    [result addObject:[[ECFavorite alloc] initWithContact:contact
                                                                           kind:[ECKindHandler kindFromString:kindOfFavorite]
                                                                      andNumber:number]];
            }
        }
    }
    
    return [result sortedArrayUsingSelector:@selector(compare:)];
}

- (void) saveModifications {
    [_favorites writeToFile:_filePath atomically:YES];
}

@end