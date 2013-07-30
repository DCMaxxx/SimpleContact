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

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECFavoritesHandler


/*----------------------------------------------------------------------------*/
#pragma mark - Singleton creation
/*----------------------------------------------------------------------------*/
+(ECFavoritesHandler *)sharedInstance {
    static dispatch_once_t pred;
    static ECFavoritesHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ECFavoritesHandler alloc] init];
    });
    return shared;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id) init {
    if (self = [super init]) {
        NSDictionary * favorites = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"Favorites"];
        if (!favorites)
            _favorites = [[NSMutableDictionary alloc] init];
        else
            _favorites = [favorites mutableCopy];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced Getters
/*----------------------------------------------------------------------------*/
- (void)areFavoriteForContact:(ECContact *)contact numbers:(NSMutableArray *)numbers ofKind:(eContactNumberKind)kind {
    if (![numbers count])
        return ;
    
    NSDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        return ;
    
    NSDictionary * kindOfFavorites = [contactFavorites objectForKey:[ECKindHandler kindToString:kind]];
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
        
        NSDictionary * allKindOfFavorites = [_favorites objectForKey:contactUID];
        for (NSString * kindOfFavorite in allKindOfFavorites) {
            NSDictionary * allNumbers = [allKindOfFavorites objectForKey:kindOfFavorite];
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


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced Setters
/*----------------------------------------------------------------------------*/
- (void)toogleContact:(ECContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSMutableDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        contactFavorites = [[NSMutableDictionary alloc] init];
    else
        contactFavorites = [contactFavorites mutableCopy];
    
    [_favorites setObject:contactFavorites forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    
    NSMutableDictionary * kindOfFavorites = [[contactFavorites objectForKey:[ECKindHandler kindToString:kind]] mutableCopy];
    if (!kindOfFavorites)
        kindOfFavorites = [[NSMutableDictionary alloc] init];
    else
        kindOfFavorites = [kindOfFavorites mutableCopy];
    [contactFavorites setObject:kindOfFavorites forKey:[ECKindHandler kindToString:kind]];
    
    NSNumber * isFavorite = [kindOfFavorites objectForKey:number];
    if (!isFavorite || ![isFavorite boolValue]) {
        isFavorite = [NSNumber numberWithBool:YES];
        [kindOfFavorites setObject:isFavorite forKey:number];
    } else
        [kindOfFavorites removeObjectForKey:number];
    [contact toogleFavoriteForNumber:number andKind:kind];
}

- (void) saveModifications {
    [[NSUserDefaults standardUserDefaults] setObject:_favorites forKey:@"Favorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end