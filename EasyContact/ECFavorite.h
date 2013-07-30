//
//  ECFavoriteNumber.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 18/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECKindHandler.h"

@class ECContact;


@interface ECFavorite : NSObject

@property (strong, nonatomic, readonly) NSString * contactNumber;
@property (nonatomic, readonly) eContactNumberKind kind;
@property (strong, nonatomic, readonly) ECContact * contact;

- (id)initWithContact:(ECContact *)contact kind:(eContactNumberKind)kind andNumber:(NSString *) contactNumber;

@end
