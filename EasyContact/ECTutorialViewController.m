//
//  ECTutorialViewController.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 28/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "ECTutorialViewController.h"


@interface ECTutorialViewController ()

@property (strong, nonatomic) NSArray * tutorialView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) BOOL loadedImages;

- (IBAction)pageChanged:(id)sender;
- (IBAction)tappedOnScrollView:(UITapGestureRecognizer *)sender;

@end

static NSUInteger const NbImages = 5;


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation ECTutorialViewController

/*----------------------------------------------------------------------------*/
#pragma mark - UIViewController
/*----------------------------------------------------------------------------*/
- (void)viewDidLoad {
    [super viewDidLoad];

	[_pageControl setNumberOfPages:NbImages];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_loadedImages)
        return ;
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame) * NbImages,
                                           CGRectGetHeight(_scrollView.frame))];
    for (NSUInteger i =0; i < NbImages; i++) {
        CGRect frame = CGRectMake(CGRectGetWidth(_scrollView.frame) * i, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        NSString * imageName = [NSString stringWithFormat:@"tutorial-%u.png", i];
        UIImage * image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:image];
        [_scrollView addSubview:imageView];
    }
    _loadedImages = YES;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UIScrollViewDelegate
/*----------------------------------------------------------------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    int page = floor(([_scrollView contentOffset].x - pageWidth / 2) / pageWidth) + 1;
    [_pageControl setCurrentPage:page];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Changing UIView, UIViewController
/*----------------------------------------------------------------------------*/
- (IBAction)pageChanged:(UIPageControl *)sender {
    int page = [sender currentPage];
    
    CGRect frame = [_scrollView frame];
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;

    [_scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)tappedOnScrollView:(UITapGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if ([_pageControl currentPage] == NbImages - 1)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
