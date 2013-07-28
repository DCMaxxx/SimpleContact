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

@end

@implementation ECTutorialViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSMutableDictionary * view1 = [@{@"image": @"tutorial-1.png",
                                       @"description": @"description 1"} mutableCopy];
        NSMutableDictionary * view2 = [@{@"image": @"tutorial-2.png",
                                       @"description": @"description 2"} mutableCopy];
        NSMutableDictionary * view3 = [@{@"image": @"tutorial-3.png",
                                       @"description": @"description 2"} mutableCopy];
        NSMutableDictionary * view4 = [@{@"image": @"tutorial-4.png",
                                       @"description": @"description 2"} mutableCopy];
        NSMutableDictionary * view5 = [@{@"image": @"tutorial-5.png",
                                       @"description": @"description 2"} mutableCopy];
        _tutorialView = @[view1, view2, view3, view4, view5];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _pageControl.currentPage = 0;
	[_pageControl setNumberOfPages:[_tutorialView count]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [_tutorialView count], _scrollView.frame.size.height);
    for (NSUInteger i =0; i < [_tutorialView count]; i++) {
        [self loadScrollViewWithPage:i];
    }
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= [_tutorialView count])
        return;
    
    NSMutableDictionary * infos = [_tutorialView objectAtIndex:page];
    CGRect frame = CGRectMake(_scrollView.frame.size.width * page, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);

    if (![infos objectForKey:@"view"]) {
        UIImage * image = [UIImage imageNamed:[infos objectForKey:@"image"]];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:image];
        [self.scrollView addSubview:imageView];
        [infos setObject:imageView forKey:@"view"];
    }
}

- (IBAction)pageChanged:(id)sender {
    int page = ((UIPageControl *)sender).currentPage;
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
        
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)tappedOnScrollView:(UITapGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (_pageControl.currentPage == [_tutorialView count] - 1)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
@end
