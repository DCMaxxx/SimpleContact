//
//  BCFavoritesHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECFavoritesHandler.h"

#import "ECFavoriteNumber.h"
#import "ECContactList.h"
#import "ECContact.h"


@implementation ECFavoritesHandler

#pragma - mark Handle favorites functions
+ (void)toogleContact:(ECContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSMutableDictionary * favorites = [ECFavoritesHandler loadFavoritesFromFile];
    
    NSMutableDictionary * contactFavorites = [favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites) {
        contactFavorites = [[NSMutableDictionary alloc] init];
        [favorites setObject:contactFavorites forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
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
    
    [ECFavoritesHandler writeDictionaryToFile:favorites];
}

+ (void)areFavoriteForContact:(ECContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind {
    if (![numbers count])
        return ;
    
    NSMutableDictionary * favorites = [ECFavoritesHandler loadFavoritesFromFile];
    
    NSMutableDictionary * contactFavorites = [favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
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

+ (NSArray *)getAllFavoritesWithContactList:(ECContactList *)list {
    NSMutableDictionary * favorites = [ECFavoritesHandler loadFavoritesFromFile];
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for (NSString * contactUID in favorites) {
        ECContact * contact = [list getContactFromUID:[contactUID intValue]];
        if (!contact)
            continue ;
        
        NSMutableDictionary * allKindOfFavorites = [favorites objectForKey:contactUID];
        for (NSString * kindOfFavorite in allKindOfFavorites) {
            NSMutableDictionary * allNumbers = [allKindOfFavorites objectForKey:kindOfFavorite];
            for (NSString * number in allNumbers) {
                NSNumber * isFavorite = [allNumbers objectForKey:number];
                if ([isFavorite boolValue])
                    [result addObject:[[ECFavoriteNumber alloc] initWithContact:contact
                                                                           kind:[ECKindHandler kindFromString:kindOfFavorite]
                                                                      andNumber:number]];
            }
        }
    }
    
    return [result sortedArrayUsingSelector:@selector(compare:)];
}


#pragma - mark Private functions for handeling favorites file.
+ (NSMutableDictionary *)loadFavoritesFromFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
    
    NSMutableDictionary * favorites;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        favorites = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    else
        favorites = [[NSMutableDictionary alloc] init];
    
    return favorites;
}

+ (void)writeDictionaryToFile:(NSDictionary *)dictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString * bundle = [[NSBundle mainBundle] pathForResource:@"Favorites" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:filePath error:nil];
    }
    
    [dictionary writeToFile:filePath atomically:YES];
}

@end