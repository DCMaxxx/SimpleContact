//
//  ECKindHandler.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 30/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "ECKindHandler.h"

@implementation ECKindHandler

+ (NSString *) kindToString:(eContactNumberKind)kind {
    return [NSString stringWithFormat:@"%d", kind];
}

+ (eContactNumberKind) kindFromString:(NSString *)kind {
    return (eContactNumberKind)[kind intValue];
}

+ (NSArray *) availableKinds {
    NSMutableArray * kinds = [[NSMutableArray alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
        [kinds addObject:[ECKindHandler kindToString:eCNKPhone]];
    if ([MFMailComposeViewController canSendMail])
        [kinds addObject:[ECKindHandler kindToString:eCNKMail]];
    if ([MFMessageComposeViewController canSendText])
        [kinds addObject:[ECKindHandler kindToString:eCNKText]];
    return kinds;
}

+ (UIImage *)iconForKind:(eContactNumberKind)kind andWhite:(BOOL)white {
    NSArray * iconBaseNames = @[@"phone", @"mail", @"text"];
    NSString * imageName = [NSString stringWithFormat:@"%@-%@.png", [iconBaseNames objectAtIndex:kind], (white ? @"white" : @"black")];
    return [UIImage imageNamed:imageName];
}

+ (SEL)selectorForKind:(eContactNumberKind)kind prefix:(NSString *)prefix andSuffix:(NSString *)suffix {
    NSArray * kinds = @[@"Phone", @"Mail", @"Text"];
    NSString * kindStr = [kinds objectAtIndex:kind];
    NSString * selectorStr = [NSString stringWithFormat:@"%@%@%@", (prefix ? prefix : @""), kindStr, (suffix ? suffix : @"")];
    return NSSelectorFromString(selectorStr);
}


@end
