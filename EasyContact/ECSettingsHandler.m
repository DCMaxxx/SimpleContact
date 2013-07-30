//
//  ECSettingsHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 25/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECSettingsHandler.h"

@interface ECSettingsHandler ()

@property NSMutableDictionary * settings;
@property NSMutableArray * unavailabeSettings;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECSettingsHandler


/*----------------------------------------------------------------------------*/
#pragma mark - Singleton creation
/*----------------------------------------------------------------------------*/
+(ECSettingsHandler *)sharedInstance {
    static dispatch_once_t pred;
    static ECSettingsHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ECSettingsHandler alloc] init];
    });
    return shared;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    if (self = [super init]) {
        _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserSettings"] mutableCopy];
        _unavailabeSettings = [[NSMutableArray alloc] init];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced getters
/*----------------------------------------------------------------------------*/
- (void)setOption:(eSettingsOption)option ofCategory:(eSettingsCategory)category withValue:(BOOL)value {
    NSMutableDictionary * options = [_settings objectForKey:[NSString stringWithFormat:@"%d", category]];
    if (!options) {
        options = [[NSMutableDictionary alloc] init];
        [_settings setObject:options forKey:[NSString stringWithFormat:@"%d", category]];
    } else {
        options = [options mutableCopy];
        [_settings setObject:options forKey:[NSString stringWithFormat:@"%d", category]];
    }
    [options setObject:[NSNumber numberWithBool:value] forKey:[NSString stringWithFormat:@"%d", option]];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Advanced setters
/*----------------------------------------------------------------------------*/
- (void)setUnavailableContactOption:(eSettingsOption)option {
    [self setOption:option ofCategory:eSCContactKind withValue:NO];
    [_unavailabeSettings addObject:[NSNumber numberWithInt:option]];
}

- (BOOL)getOption:(eSettingsOption)option ofCategory:(eSettingsCategory)category {
    NSDictionary * options = [_settings objectForKey:[NSString stringWithFormat:@"%d", category]];
    if (!options)
        return NO;
    NSNumber * number = [options objectForKey:[NSString stringWithFormat:@"%d", option]];
    return number ? [number boolValue] : NO;
}

- (BOOL)isKindAvailable:(eSettingsOption)option {
    return ([_unavailabeSettings indexOfObject:[NSNumber numberWithInt:option]]) == NSNotFound;
        
}

- (void)saveModifications {
    [[NSUserDefaults standardUserDefaults] setObject:_settings forKey:@"UserSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)reloadSettings {
    _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserSettings"] mutableCopy];
}

@end
