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
@property NSString * filePath;

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
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsPath = [paths objectAtIndex:0];
        _filePath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
            _settings = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];
        else
            _settings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)getOption:(eTagCellValue)option ofCategory:(eTagTableViewKind)category {
    NSMutableDictionary * options = [_settings objectForKey:[NSString stringWithFormat:@"%d", category]];
    if (!options)
        return NO;
    NSNumber * number = [options objectForKey:[NSString stringWithFormat:@"%d", option]];
    return number ? [number boolValue] : NO;
}

- (void)setOption:(eTagCellValue)option ofCategory:(eTagTableViewKind)category withValue:(BOOL)value {
    NSMutableDictionary * options = [_settings objectForKey:[NSString stringWithFormat:@"%d", category]];
    if (!options) {
        options = [[NSMutableDictionary alloc] init];
        [_settings setObject:options forKey:[NSString stringWithFormat:@"%d", category]];
    }
    [options setObject:[NSNumber numberWithBool:value] forKey:[NSString stringWithFormat:@"%d", option]];
}

- (void)saveModifications {
    [_settings writeToFile:_filePath atomically:YES];
    NSLog(@"Content of file : %@", [NSDictionary dictionaryWithContentsOfFile:_filePath]);
}

@end
