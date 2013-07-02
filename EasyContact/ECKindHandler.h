//
//  ECKindHandler.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 30/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { eCNKPhone, eCNKMail, eCNKText } eContactNumberKind;


@interface ECKindHandler : NSObject

+ (NSString *) kindToString:(eContactNumberKind)kind;
+ (eContactNumberKind) kindFromString:(NSString *)kind;
+ (NSArray *)availableKinds;
+ (UIImage *)iconForKind:(eContactNumberKind)kind andWhite:(BOOL)white;
+ (SEL)selectorForKind:(eContactNumberKind)kind prefix:(NSString *)prefix andSuffix:(NSString *)suffix;


@end
