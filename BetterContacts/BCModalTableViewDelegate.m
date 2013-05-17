//
//  BCPhoneNumberTableViewDelegate.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 06/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RMPhoneFormat.h"

#import "BCModalListViewController.h"
#import "BCModalTableViewDelegate.h"
#import "BCImageLabelCell.h"
#import "BCContact.h"


@implementation BCModalTableViewDelegate

- (id)initWithContact:(BCContact *)contact {
    if (self = [super init]) {
        _contact = contact;
    }
    return self;
}

- (void)setController:(BCModalListViewController *)controller {
    _controller = controller;
}

#pragma mark UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfPhone = [indexPath indexAtPosition:1];

    BCImageLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelsCell"];
    NSDictionary *phone = [[_contact phoneNumbers] objectAtIndex:indexOfPhone];
    NSString *label = [phone objectForKey:@"label"];
    [[cell leftImage] setImage:[_controller getImageFromLabel:label]];
    
    NSString *phoneNumber = [phone objectForKey:@"value"];
    [[cell rightLabel] setText:phoneNumber];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfPhoneNumbers];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_controller selectedANumber:(BCImageLabelCell *)[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

@end
