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

@end

@implementation ECSettingsHandler

+(ECSettingsHandler *)sharedInstance {
    static dispatch_once_t pred;
    static ECSettingsHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ECSettingsHandler alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserSettings"] mutableCopy];
    }
    return self;
}

- (BOOL)getOption:(eSettingsOption)option ofCategory:(eSettingsCategory)category {
    NSDictionary * options = [_settings objectForKey:[NSString stringWithFormat:@"%d", category]];
    if (!options)
        return NO;
    NSNumber * number = [options objectForKey:[NSString stringWithFormat:@"%d", option]];
    return number ? [number boolValue] : NO;
}

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

- (void)saveModifications {
    [[NSUserDefaults standardUserDefaults] setObject:_settings forKey:@"UserSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
