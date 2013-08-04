//
//  ECFavoriteNumber.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 18/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCKindHandler.h"

@class SCContact;


@interface SCFavorite : NSObject

@property (strong, nonatomic, readonly) NSString * contactNumber;
@property (nonatomic, readonly) eContactNumberKind kind;
@property (strong, nonatomic, readonly) SCContact * contact;

- (id)initWithContact:(SCContact *)contact kind:(eContactNumberKind)kind andNumber:(NSString *) contactNumber;

@end
