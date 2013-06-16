//
//  BCFavoritesHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCFavoritesHandler.h"

#import "BCContact.h"

@implementation BCFavoritesHandler

+ (void)toogleContact:(BCContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSMutableDictionary * favorites = [BCFavoritesHandler loadFavoritesFromFile];
    
    NSMutableDictionary * contactFavorites = [favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites) {
        contactFavorites = [[NSMutableDictionary alloc] init];
        [favorites setObject:contactFavorites forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    }
    
    NSMutableDictionary * kindOfFavorites = [contactFavorites objectForKey:[NSString stringWithFormat:@"%d", kind]];
    if (!kindOfFavorites) {
        kindOfFavorites = [[NSMutableDictionary alloc] init];
        [contactFavorites setObject:kindOfFavorites forKey:[NSString stringWithFormat:@"%d", kind]];
    }
    
    NSNumber * isFavorite = [kindOfFavorites objectForKey:number];
    if (!isFavorite || ![isFavorite boolValue]) {
        isFavorite = [NSNumber numberWithBool:YES];
        [kindOfFavorites setObject:isFavorite forKey:number];
    } else
        [kindOfFavorites removeObjectForKey:number];
    
    [BCFavoritesHandler writeDictionaryToFile:favorites];
}

+ (void)areFavoriteForContact:(BCContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind {
    if (![numbers count])
        return ;
    
    NSMutableDictionary * favorites = [BCFavoritesHandler loadFavoritesFromFile];

    NSMutableDictionary * contactFavorites = [favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        return ;
    
    NSMutableDictionary * kindOfFavorites = [contactFavorites objectForKey:[NSString stringWithFormat:@"%d", kind]];
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
