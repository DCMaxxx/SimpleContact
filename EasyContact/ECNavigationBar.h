//
//  ECNavigationBar.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 12/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECSettingsDelegate.h"


@interface ECNavigationBar : UINavigationBar

- (void)displaySettingsOnNavigationController:(UINavigationController *)controller andDelegate:(id<ECSettingsDelegate>)delegate;

@end
