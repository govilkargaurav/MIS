//
//  TellAFriendViewController.m
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "TellAFriendViewController.h"
#import "FacebookShareViewController.h"
#import "TwitterShareViewController.h"

@interface TellAFriendViewController ()
{
    IBOutlet UIButton *btnTwitter;
    IBOutlet UIButton *btnFacebook;
    IBOutlet UIImageView *imgInvite;
}

@end

@implementation TellAFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)btnTwitterClicked:(id)sender
{
    TwitterShareViewController *obj=[[TwitterShareViewController alloc]initWithNibName:@"TwitterShareViewController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}
- (IBAction)btnFacebookClicked:(id)sender
{
    FacebookShareViewController *obj=[[FacebookShareViewController alloc]initWithNibName:@"FacebookShareViewController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}

#pragma mark - DEFAULT METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    btnTwitter = nil;
    btnFacebook = nil;
    imgInvite = nil;
    [super viewDidUnload];
}
@end
