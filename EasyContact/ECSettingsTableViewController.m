//
//  ECSettingsTableViewController.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 05/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECSettingsTableViewController.h"

#import "ECSettingsHandler.h"
#import "ECNavigationBar.h"

static NSUInteger kLabelViewTag = 4242;

@interface ECSettingsTableViewController ()

@end

@implementation ECSettingsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _currentCategory = eSCDefault;
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[ECSettingsTableViewController class]]) {
        ECSettingsTableViewController * tvc = [segue destinationViewController];
        [tvc setCurrentCategory:[sender tag]];
        [tvc setDelegate:_delegate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setValue:[[ECNavigationBar alloc] init] forKeyPath:@"navigationBar"];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [label setFont:[UIFont fontWithName:@"Avenir-Light" size:21.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"Préférences"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [[self navigationItem] setTitleView:label];

    UIButton * validationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [validationButton setBackgroundImage:[UIImage imageNamed:@"validation-tick.png"] forState:UIControlStateNormal];
    [validationButton addTarget:self action:@selector(cancelEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:validationButton];
    [[self navigationItem] setRightBarButtonItem:barButtonItem];
    
    NSDictionary * dic = @{UITextAttributeFont: [UIFont fontWithName:@"Avenir-Light" size:18.0f], UITextAttributeTextColor: [UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-2.0f, 2.0f) forBarMetrics:UIBarMetricsDefault];
    UIImage * image = [UIImage imageNamed:@"backbutton-background.png"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BOOL set = [[ECSettingsHandler sharedInstance] getOption:[cell tag] ofCategory:_currentCategory];
    if (set)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else if (_currentCategory == eSCContactKind && ![[ECSettingsHandler sharedInstance] isKindAvailable:[cell tag]]) {
        [cell setUserInteractionEnabled:NO];
        UILabel * label = (UILabel *)[cell viewWithTag:kLabelViewTag];
        [label setEnabled:NO];
    }
    return cell;
}

- (void) cancelEdit: (id) sender {
    [[ECSettingsHandler sharedInstance] saveModifications];
    if (_delegate)
        [_delegate updatedSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didTapBackButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell tag])
        [self saveSettingsOfCell:cell];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString * title = [self tableView:tableView titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    UILabel * label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Avenir-Light" size:20.0f]];
    [label setTextColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
    [label setText:title];
    return label;
}


-(void)saveSettingsOfCell:(UITableViewCell *)cell {
    NSArray * selectors = @[@"saveSettingsForDefaultViewWithCell:",
                            @"saveSettingsForListOrderViewWithCell:",
                            @"saveSettingsForContactKindWithCell:",
                            @"saveSettingsForFavoriteOrderWithCell:"];
    SEL selector = NSSelectorFromString([selectors objectAtIndex:(_currentCategory - eSCDefault)]);
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:cell];
#pragma clang diagnostic pop
    }
}

-(void)saveSettingsForDefaultViewWithCell:(UITableViewCell *)cell {
    if ([cell tag] != eSOShowImages)
        return ;
    [self changeSettingsForCell:cell andResetOthers:NO];
}

-(void)saveSettingsForListOrderViewWithCell:(UITableViewCell *)cell {
    if (([cell tag] != eSOFirstName && [cell tag] != eSOLastName)
        || [cell accessoryType] != UITableViewCellAccessoryNone)
        return ;
    [self changeSettingsForCell:cell andResetOthers:YES];
}

-(void)saveSettingsForContactKindWithCell:(UITableViewCell *)cell {
    if ([cell tag] != eSOPhone && [cell tag] != eSOMail
        && [cell tag] != eSOMessage && [cell tag] != eSOFaceTime)
        return ;
    [self changeSettingsForCell:cell andResetOthers:NO];
}

-(void)saveSettingsForFavoriteOrderWithCell:(UITableViewCell *)cell {
    if ([cell tag] != eSOFirstName &&[cell tag] != eSOLastName
        && [cell tag] != eSONickName)
        return ;
    [self changeSettingsForCell:cell andResetOthers:YES];
}

-(void)changeSettingsForCell:(UITableViewCell *)cell andResetOthers:(BOOL)reset {
    BOOL isSet = ([cell accessoryType] == UITableViewCellAccessoryCheckmark);
    if (!isSet || (isSet && !reset)) {
        UITableViewCellAccessoryType newType = (isSet ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark);
        [cell setAccessoryType:newType];
        [[ECSettingsHandler sharedInstance] setOption:[cell tag] ofCategory:_currentCategory withValue:!isSet];
    }
    if (reset) {
        NSIndexPath * indexPath = [[self tableView] indexPathForCell:cell];
        NSInteger sectionIdx = [indexPath indexAtPosition:0];
        for (NSUInteger i = 0; i < [[self tableView] numberOfRowsInSection:sectionIdx]; ++i) {
            if (i != [indexPath indexAtPosition:1]) {
                UITableViewCell * cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIdx]];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [[ECSettingsHandler sharedInstance] setOption:[cell tag] ofCategory:_currentCategory withValue:NO];
            }
        }
    }
}

@end
