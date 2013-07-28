//
//  ECTutorialViewController.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 28/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECTutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)pageChanged:(id)sender;
- (IBAction)tappedOnScrollView:(UITapGestureRecognizer *)sender;

@end
