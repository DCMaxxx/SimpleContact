//
//  ECSettingsHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 25/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCSettingsHandler.h"

@interface SCSettingsHandler ()

@property NSMutableDictionary * settings;
@property NSMutableArray * unavailabeSettings;

@end

static NSString * const DicKeySettingsImported = @"UserSettings";


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCSettingsHandler


/*----------------------------------------------------------------------------*/
#pragma mark - Singleton creation
/*----------------------------------------------------------------------------*/
+ (SCSettingsHandler *)sharedInstance {
    static dispatch_once_t pred;
    static SCSettingsHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SCSettingsHandler alloc] init];
    });
    return shared;
}

+ (void)loadSettings {
    static NSString * const FileDefaultSettings = @"Settings";

    if (![[NSUserDefaults standardUserDefaults] objectForKey:DicKeySettingsImported]) {
        NSDictionary * settings = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FileDefaultSettings ofType:@"plist"]];
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:DicKeySettingsImported];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[SCSettingsHandler sharedInstance] reloadSettings];
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    if (self = [super init]) {
        _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:DicKeySettingsImported] mutableCopy];
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
    [[NSUserDefaults standardUserDefaults] setObject:_settings forKey:DicKeySettingsImported];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)reloadSettings {
    _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:DicKeySettingsImported] mutableCopy];
}

@end
