//
//  ECSettingsDelegate.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 26/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

enum eSettingsOption;
enum eSettingsCategory;

@protocol ECSettingsDelegate <NSObject>

- (void)updatedSettings;

@end
