//
//  BCModalListViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 07/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCModalListViewController.h"
#import "BCModalTableViewDelegate.h"
#import "BCModalTableViewMailDelegate.h"
#import "BCImageLabelCell.h"
#import "BCContact.h"

@interface BCModalListViewController ()

@end

@implementation BCModalListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myInitWithType:(eModalTypeView)type andContact:(BCContact *)contact {
    [[self view] setStyle];
    [[self view] setType:type];
    [[self view] setContactPic:[contact picture]];
    _delegate = [self getDelegateFromType:type WithContact:contact];
    [_delegate performSelector:@selector(setController:) withObject:self];
    [[[self view] tableView] setDelegate:_delegate];
    [[[self view] tableView] setDataSource:_delegate];
}

- (void)selectedANumber:(BCImageLabelCell *)cell {
    NSString * phoneNumber = [[[cell rightLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * callUrl = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callUrl]];
}

- (UIImage *) getImageFromLabel:(NSString *)label {
    static NSMutableDictionary * dic = nil;
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[UIImage imageNamed:@"home.png"] forKey:@"home"];
        [dic setObject:[UIImage imageNamed:@"mobile.png"] forKey:@"mobile"];
        [dic setObject:[UIImage imageNamed:@"mobile.png"] forKey:@"iPhone"];
        [dic setObject:[UIImage imageNamed:@"work.png"] forKey:@"work"];
        [dic setObject:[UIImage imageNamed:@"user.png"] forKey:@"other"];
    }
    if (![dic objectForKey:label])
        return [dic objectForKey:@"other"];
    return [dic objectForKey:label];
}

#pragma mark Im in a hurry no time to mark this
- (id<UITableViewDataSource,UITableViewDelegate>)getDelegateFromType:(eModalTypeView)type WithContact:(BCContact *)contact {
    if (type == MTVPhone)
        return [[BCModalTableViewDelegate alloc] initWithContact:contact];
    else if (type == MTVMail)
        return [[BCModalTableViewMailDelegate alloc] initWithContact:contact];
    else // RETURN TEXTO
        return nil;
}

@end
