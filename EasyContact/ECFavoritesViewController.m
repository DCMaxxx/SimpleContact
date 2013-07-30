//
//  BCFavoritesViewViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RNBlurModalView.h"
#import "RMPhoneFormat.h"

#import "ECFavoritesViewController.h"

#import "ECNavigationBar.h"
#import "ECContactJoiner.h"
#import "ECFavoriteCell.h"
#import "ECFavorite.h"
#import "ECContact.h"

@interface ECFavoritesViewController ()

@property (strong, nonatomic) NSMutableArray * contacts;
@property (strong, nonatomic) ECContactJoiner * joiner;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECFavoritesViewController

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[self navigationItem] setHidesBackButton:YES];
        _joiner = [[ECContactJoiner alloc] init];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UIViewController
/*----------------------------------------------------------------------------*/
- (void)viewDidLoad {
    [super viewDidLoad];

    _contacts = [[self favoriteContacts] mutableCopy];
    [self setFavoriteContacts:nil];
}


/*----------------------------------------------------------------------------*/
#pragma mark - UICollectionViewDataSource
/*----------------------------------------------------------------------------*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_contacts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = [indexPath indexAtPosition:1];
    ECFavorite * contact = [_contacts objectAtIndex:idx];
    ECFavoriteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    [cell setInformationsWithNumber:contact];
    
    if (![[cell gestureRecognizers] count]) {
        UILongPressGestureRecognizer * gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeFavorite:)];
        [cell addGestureRecognizer:gr];
    }
    
    return cell;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UICollectionViewDelegate
/*----------------------------------------------------------------------------*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECFavoriteCell * cell = (ECFavoriteCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ECFavorite * number = [cell number];
    
    [_joiner joinContactWithKind:[number kind] address:[number contactNumber] andViewController:self];
}


/*----------------------------------------------------------------------------*/
#pragma mark - UICollectionViewFlowLayoutDelegate
/*----------------------------------------------------------------------------*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 5, (self.collectionView.frame.size.height - 84.0f) / 4, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 17.0f;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UIGestureRecognizerDelegate
/*----------------------------------------------------------------------------*/
- (void)removeFavorite:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[self collectionView]];
        NSIndexPath * path = [[self collectionView] indexPathForItemAtPoint:location];
        
        ECFavoriteCell * cell = (ECFavoriteCell *)[[self collectionView] cellForItemAtIndexPath:path];
        ECFavorite * number = [cell number];
        [[ECFavoritesHandler sharedInstance] toogleContact:[number contact] number:[number contactNumber] ofKind:[number kind]];
        [[ECFavoritesHandler sharedInstance] saveModifications];
        [self.collectionView performBatchUpdates:^{
            NSArray *selectedItemsIndexPaths = [NSArray arrayWithObject:path];
            [self deleteItemsFromDataSourceAtIndexPaths:selectedItemsIndexPaths];
            [[self collectionView] deleteItemsAtIndexPaths:selectedItemsIndexPaths];
        } completion:nil];
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - ECSettingsDelegate
/*----------------------------------------------------------------------------*/
- (void)updatedSettings {
    [_contacts sortUsingSelector:@selector(compare:)];
    [[self collectionView] reloadData];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Changing current ViewController
/*----------------------------------------------------------------------------*/
- (IBAction)goBackToContacts {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)displaySettings:(id)sender {
    ECNavigationBar * nv = (ECNavigationBar *)[[self navigationController] navigationBar];
    [nv displaySettingsOnNavigationController:self.navigationController andDelegate:self];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc private methods
/*----------------------------------------------------------------------------*/
- (void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath  in itemPaths) {
        [indexSet addIndex:itemPath.row];
    }
    [_contacts removeObjectsAtIndexes:indexSet];
}

@end