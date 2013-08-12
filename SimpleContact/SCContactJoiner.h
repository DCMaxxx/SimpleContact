//
//  ECContactJointer.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 22/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Foundation/Foundation.h>

#import "SCKindHandler.h"


@interface SCContactJoiner : NSObject
<
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate
>

- (void)joinContactWithKind:(eContactNumberKind)kind address:(NSString *)address andViewController:(UIViewController *)vc;
- (void)reportIssueOnViewController:(UIViewController *)controller;

@end
