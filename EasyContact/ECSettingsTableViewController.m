//
//  ECSettingsTableViewController.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 05/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECSettingsTableViewController.h"

#import "ECNavigationBar.h"

@interface ECSettingsTableViewController ()

@end

typedef enum { eTTVKListOrder = 4242, eTTVKListDisplay, eTTVKFavoriteOrder, eTTVKFavoriteDisplay } eTagTableViewKind;

typedef enum { eTCVShowImages = 4242, eTCVFirstName, eTCVLastName, eTCVNickName } eTagCellValue;

@implementation ECSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setValue:[[ECNavigationBar alloc] init] forKeyPath:@"navigationBar"];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
    [label setFont:[UIFont fontWithName:@"Avenir-Light" size:21.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor colorWithRed:0 green:119.0f/255.0f blue:1.0f alpha:1.0f]];
    [label setText:@"Préférences"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [[self navigationItem] setTitleView:label];

    UIButton * validationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [validationButton setBackgroundImage:[UIImage imageNamed:@"validation-tick.png"] forState:UIControlStateNormal];
    [validationButton addTarget:self action:@selector(cancelEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:validationButton];
    [[self navigationItem] setRightBarButtonItem:barButtonItem];
    
    NSDictionary * dic = @{UITextAttributeFont: [UIFont fontWithName:@"Avenir-Light" size:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-2.0f, 2.0f) forBarMetrics:UIBarMetricsDefault];
    UIImage * image = [UIImage imageNamed:@"backbutton-background.png"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}

- (void) cancelEdit: (id) sender {
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
    [label setTextColor:[UIColor colorWithWhite:0.75f alpha:1.0f]];
    [label setText:title];
    return label;
}


-(void)saveSettingsOfCell:(UITableViewCell *)cell {
    if ([cell tag] == eTCVShowImages) {
        BOOL isSet = ([cell accessoryType] == UITableViewCellAccessoryNone);
        UITableViewCellAccessoryType newType = (isSet ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        [cell setAccessoryType:newType];
        // Updated preferences
    }
}

@end
