//
//  BCFavoritesHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 16/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCFavoritesHandler.h"

#import "SCFavorite.h"
#import "SCContactList.h"
#import "SCContact.h"


@interface SCFavoritesHandler ()

@property NSMutableDictionary * favorites;

@end

static NSString * const DicKeyFavorite = @"Favorites";


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCFavoritesHandler


/*----------------------------------------------------------------------------*/
#pragma mark - Singleton creation
/*----------------------------------------------------------------------------*/
+(SCFavoritesHandler *)sharedInstance {
    static dispatch_once_t pred;
    static SCFavoritesHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SCFavoritesHandler alloc] init];
    });
    return shared;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id) init {
    if (self = [super init]) {
        NSDictionary * favorites = [[NSUserDefaults standardUserDefaults] dictionaryForKey:DicKeyFavorite];
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
- (BOOL)isFavoriteWithContact:(SCContact *)contact number:(NSString *)number ofKind:(eContactNumberKind)kind {
    NSDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        return NO;
    
    NSDictionary * kindOfFavorites = [contactFavorites objectForKey:[SCKindHandler kindToString:kind]];
    if (!kindOfFavorites)
        return NO;
    
    NSNumber * isFavorite = [kindOfFavorites objectForKey:number];
    return isFavorite && [isFavorite boolValue];
}

- (NSArray *)getAllFavoritesWithContactList:(SCContactList *)list {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for (NSString * contactUID in _favorites) {
        SCContact * contact = [list getContactFromUID:[contactUID intValue]];
        if (!contact)
            continue ;
        
        NSDictionary * allKindOfFavorites = [_favorites objectForKey:contactUID];
        for (NSString * kindOfFavorite in allKindOfFavorites) {
            NSDictionary * allNumbers = [allKindOfFavorites objectForKey:kindOfFavorite];
            for (NSString * number in allNumbers) {
                NSNumber * isFavorite = [allNumbers objectForKey:number];
                if ([isFavorite boolValue])
                    [result addObject:[[SCFavorite alloc] initWithContact:contact
                                                                     kind:[SCKindHandler kindFromString:kindOfFavorite]
                                                                andNumber:number]];
            }
        }
    }
    
    return [result sortedArrayUsingSelector:@selector(compare:)];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced Setters
/*----------------------------------------------------------------------------*/
- (void)toogleContact:(SCContact *)contact number:(NSString *)number atIndex:(NSUInteger)idx ofKind:(eContactNumberKind)kind {
    NSMutableDictionary * contactFavorites = [_favorites objectForKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    if (!contactFavorites)
        contactFavorites = [[NSMutableDictionary alloc] init];
    else
        contactFavorites = [contactFavorites mutableCopy];
    [_favorites setObject:contactFavorites forKey:[NSString stringWithFormat:@"%d", [contact UID]]];
    
    NSMutableDictionary * kindOfFavorites = [[contactFavorites objectForKey:[SCKindHandler kindToString:kind]] mutableCopy];
    if (!kindOfFavorites)
        kindOfFavorites = [[NSMutableDictionary alloc] init];
    else
        kindOfFavorites = [kindOfFavorites mutableCopy];
    [contactFavorites setObject:kindOfFavorites forKey:[SCKindHandler kindToString:kind]];
    
    NSNumber * isFavorite = [kindOfFavorites objectForKey:number];
    if (!isFavorite || ![isFavorite boolValue]) {
        isFavorite = [NSNumber numberWithBool:YES];
        [kindOfFavorites setObject:isFavorite forKey:number];
    } else
        [kindOfFavorites removeObjectForKey:number];
    [contact toogleFavoriteForNumber:number ofKind:kind];
}

- (void) saveModifications {
    [[NSUserDefaults standardUserDefaults] setObject:_favorites forKey:DicKeyFavorite];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end