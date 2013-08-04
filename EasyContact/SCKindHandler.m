//
//  ECKindHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 30/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "SCKindHandler.h"

#import "SCSettingsHandler.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCKindHandler

/*----------------------------------------------------------------------------*/
#pragma mark - Advanced getters
/*----------------------------------------------------------------------------*/
+ (NSArray *) enabledKinds {
    NSMutableArray * kinds = [[NSMutableArray alloc] init];
    SCSettingsHandler * settingsHandler = [SCSettingsHandler sharedInstance];
    if ([settingsHandler getOption:eSOPhone ofCategory:eSCContactKind])
        [kinds addObject:[SCKindHandler kindToString:eCNKPhone]];
    if ([settingsHandler getOption:eSOMail ofCategory:eSCContactKind])
        [kinds addObject:[SCKindHandler kindToString:eCNKMail]];
    if ([settingsHandler getOption:eSOMessage ofCategory:eSCContactKind])
        [kinds addObject:[SCKindHandler kindToString:eCNKText]];
    if ([settingsHandler getOption:eSOFaceTime ofCategory:eSCContactKind])
        [kinds addObject:[SCKindHandler kindToString:eCNKFaceTime]];
    return kinds;
}

+ (UIImage *)iconForKind:(eContactNumberKind)kind andWhite:(BOOL)white {
    NSArray * iconBaseNames = @[@"phone", @"mail", @"text", @"facetime"];
    NSString * imageName = [NSString stringWithFormat:@"%@-%@.png", [iconBaseNames objectAtIndex:kind], (white ? @"white" : @"black")];
    return [UIImage imageNamed:imageName];
}

+ (SEL)selectorForKind:(eContactNumberKind)kind prefix:(NSString *)prefix andSuffix:(NSString *)suffix {
    NSArray * kinds = @[@"Phone", @"Mail", @"Text", @"FaceTime"];
    NSString * kindStr = [kinds objectAtIndex:kind];
    NSString * selectorStr = [NSString stringWithFormat:@"%@%@%@", (prefix ? prefix : @""), kindStr, (suffix ? suffix : @"")];
    return NSSelectorFromString(selectorStr);
}

/*----------------------------------------------------------------------------*/
#pragma mark - Advanced setters
/*----------------------------------------------------------------------------*/
+ (void)setPossibleKinds {
    SCSettingsHandler * settingsHandler = [SCSettingsHandler sharedInstance];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
        [settingsHandler setUnavailableContactOption:eSOPhone];
    if (![MFMailComposeViewController canSendMail])
        [settingsHandler setUnavailableContactOption:eSOMail];
    if (![MFMessageComposeViewController canSendText])
        [settingsHandler setUnavailableContactOption:eSOMessage];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"facetime://"]])
        [settingsHandler setUnavailableContactOption:eSOFaceTime];
    [settingsHandler saveModifications];
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
+ (NSString *)kindToString:(eContactNumberKind)kind {
    return [NSString stringWithFormat:@"%d", kind];
}

+ (eContactNumberKind)kindFromString:(NSString *)kind {
    return (eContactNumberKind)[kind intValue];
}

@end
