//
//  HomeViewController.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DDPageControl.h"
@interface HomeViewController : UIViewController<UIScrollViewDelegate>{

    BOOL pageControlBeingUsed;
    UIImageView *imageViewTitle;

}
@property (strong, nonatomic) IBOutlet UIButton *btnForGotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnDisclaimer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property(strong,nonatomic)DDPageControl *pageControll;
- (IBAction)btnSingUpPressed:(id)sender;
- (IBAction)btnLoginPressed:(id)sender;
- (IBAction)btnForgotPasswordPressed:(id)sender;
- (IBAction)btnDisclaminerPressed:(id)sender;

- (IBAction)changePage:(id)sender;
//- (void)previousPage;
//- (void)nextPage;
//-(void)loadScrollViewWithPage;
@end
