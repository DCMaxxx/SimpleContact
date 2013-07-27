//
//  ECContactJointer.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 22/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"
#import "UIDevice-Hardware.h"

#import "ECContactJoiner.h"


@interface ECContactJoiner ()

@property (strong, nonatomic) MFMailComposeViewController *mailViewController;
@property (strong, nonatomic) MFMessageComposeViewController * messageViewController;
@property (weak, nonatomic) UIViewController * currentController;

@end

@implementation ECContactJoiner

#pragma - mark Join a contact
- (void) joinContactWithKind:(eContactNumberKind)kind address:(NSString *)address andViewController:(UIViewController *)vc {
    switch (kind) {
        case eCNKPhone:
            [self callNumber:address];
            break;
        case eCNKMail:
            [self sendMail:address withCurrentController:vc];
            break;
        case eCNKText:
            [self sendText:address withCurrentController:vc];
            break;
        case eCNKFaceTime:
            [self faceTimeNumber:address];
            break;
    }
}

- (void) reportIssueOnViewController:(UIViewController *)controller {
    _mailViewController = [[MFMailComposeViewController alloc] init];
    [_mailViewController setMailComposeDelegate:self];
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"maxime.dechalendar@me.com"];
    [_mailViewController setToRecipients:toRecipients];
    
    [_mailViewController setSubject:@"Problème avec EasyContact"];
    
    NSString * appV = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * iOSV = [[UIDevice currentDevice] systemVersion];
    NSString * deviceV = [[UIDevice currentDevice] platformString];
    NSString * body = [NSString stringWithFormat:@"Je suis désolé que vous rencontriez un problème.\nMerci de le décrire précisément, avec le nom et prénom du contact posant éventuellement problème, l'action pour reproduire le bug, etc.\nMerci également de laisser toutes les lignes en dessous des \"-----\"\n\n-----\nVersion d'EasyContact : %@\nVersion d'iOS : %@\n iDevice : %@\n", appV, iOSV, deviceV];
    [_mailViewController setMessageBody:body isHTML:NO];

    [controller presentViewController:_mailViewController animated:YES completion:nil];
}



#pragma - mark Private methods to contact
- (void) callNumber:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"tel://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];   
}

- (void) sendMail:(NSString *)mail withCurrentController:(UIViewController *)controller {
    _currentController = controller;

    [[[[_currentController view] superview] viewWithTag:kRNBlurCloseViewTag] removeFromSuperview];
    
    _mailViewController = [[MFMailComposeViewController alloc] init];
    [_mailViewController setMailComposeDelegate:self];
    
    NSArray *toRecipients = [NSArray arrayWithObject:mail];
    [_mailViewController setToRecipients:toRecipients];
    
    [_currentController presentViewController:_mailViewController animated:YES completion:nil];
}

- (void) sendText:(NSString *)address withCurrentController:(UIViewController *)controller {
    _currentController = controller;
    
    [[[[_currentController view] superview] viewWithTag:kRNBlurCloseViewTag] removeFromSuperview];
    
    _messageViewController = [[MFMessageComposeViewController alloc] init];
    [_messageViewController setMessageComposeDelegate:self];
    
    NSArray *toRecipients = [NSArray arrayWithObject:address];
    [_messageViewController setRecipients:toRecipients];
    
    [_currentController presentViewController:_messageViewController animated:YES completion:nil];
}

- (void) faceTimeNumber:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"facetime://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];
}


#pragma mark - MFMailCompose View Controller Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    BOOL hidePopupExists = [_currentController respondsToSelector:@selector(hidePopup)];
    [_currentController dismissViewControllerAnimated:!hidePopupExists
                                             completion:^{
                                                 if (hidePopupExists)
                                                     [_currentController performSelector:@selector(hidePopup)];
                                             }];
}


#pragma mark - MFMailCompose View Controller Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    BOOL hidePopupExists = [_currentController respondsToSelector:@selector(hidePopup)];
    [_currentController dismissViewControllerAnimated:!hidePopupExists
                                             completion:^{
                                                 if (hidePopupExists)
                                                     [_currentController performSelector:@selector(hidePopup)];
                                             }];
}

@end
