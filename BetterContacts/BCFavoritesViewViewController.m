//
//  BCFavoritesViewViewController.m
//  BetterContacts
//
//  Created by Maxime de Chalendar on 12/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "BCFavoritesViewViewController.h"
#import "BCFavoriteCell.h"
#import "BCContact.h"

#import "RNBlurModalView.h"

@interface BCFavoritesViewViewController ()

@property (strong, nonatomic) NSMutableArray * contacts;

@end

@implementation BCFavoritesViewViewController

@synthesize contacts = _contacts;

#pragma - mark Init
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}


#pragma - mark UIViewController delegate
- (void)viewDidLoad
{
    [super viewDidLoad];

    _contacts = [[self favoriteContacts] mutableCopy];
    [self setFavoriteContacts:nil];
}


#pragma - mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_contacts count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = [indexPath indexAtPosition:1];
    BCContact * contact = [_contacts objectAtIndex:idx];
    BCFavoriteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    [[cell contactPicture] setImage:[contact picture]];
    
    [[cell contactName] setText:[contact firstName]];
    return cell;
}


#pragma - mark UICollectionViewFlowLayoutDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 5, 15, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 17.0f;
}


#pragma - mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RNBlurModalView * modal = [[RNBlurModalView alloc] initWithTitle:@"Selected contact" message:@"Hey yeah !"];
    [modal show];
}


#pragma - mark Misc functions
- (IBAction)goBackToContacts {
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
