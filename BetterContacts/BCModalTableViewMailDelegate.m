//
//  BCModalTableViewMailDelegate.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 09/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCModalTableViewMailDelegate.h"
#import "BCContact.h"
#import "BCModalListViewController.h"
#import "BCImageLabelCell.h"

@implementation BCModalTableViewMailDelegate

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
    NSInteger indexOfMail = [indexPath indexAtPosition:1];
    
    BCImageLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelsCell"];
    NSDictionary *mail = [[_contact mailAddresses] objectAtIndex:indexOfMail];
    NSString *label = [mail objectForKey:@"label"];
    [[cell leftImage] setImage:[_controller getImageFromLabel:label]];
    
    NSString *mailAddress = [mail objectForKey:@"value"];
    [[cell rightLabel] setText:mailAddress];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contact numberOfTextAddresses];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_controller selectedANumber:(BCImageLabelCell *)[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

@end
