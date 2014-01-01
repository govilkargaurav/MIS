//
//  HomeViewController.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SignUpStep2ViewController.h"
#import "SingUp1ViewConroller.h"
#import "TermsAndConditionsViewController.h"
@implementation HomeViewController
@synthesize scrollView;
@synthesize pageControll,btnDisclaimer,btnForGotPassword;

//@synthesize pageControl;
int kNumberOfPages=5;
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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.viewControllers = [[NSArray alloc]initWithObjects:self, nil];
    //self.title = @"#FitTag";
    
    [btnDisclaimer.titleLabel setFont:[UIFont fontWithName:@"DynoRegular" size:10]];
    [btnForGotPassword.titleLabel setFont:[UIFont fontWithName:@"DynoRegular" size:10]];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overviewblock"]];
    // Do any additional setup after loading the view from its nib.
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor greenColor], [UIColor blueColor],[UIColor magentaColor], nil];
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imgIntroScreen = [[UIImageView alloc]initWithFrame:frame];
        imgIntroScreen.image = [UIImage imageNamed:[NSString stringWithFormat:@"Slide_%d.png",i+1]];
        [self.scrollView addSubview:imgIntroScreen];
    }
    // programmatically add the page control
    pageControll = [[DDPageControl alloc] init] ;
    [pageControll setOffColor:[UIColor blackColor]];
    [pageControll setOnColor:[UIColor redColor]];
	[pageControll setCenter: CGPointMake(self.view.center.x, 275+64)];
	[pageControll setNumberOfPages: kNumberOfPages];
	[pageControll setCurrentPage: 0] ;
	[pageControll addTarget: self action: @selector(changePage:) forControlEvents: UIControlEventValueChanged] ;
    [self.view addSubview:pageControll];
    kNumberOfPages = [colors count];
    pageControll.numberOfPages = kNumberOfPages;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * colors.count, self.scrollView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton=YES;
    UIImage *image = [UIImage imageNamed:@"#FitTag.png"];
    imageViewTitle = [[UIImageView alloc] initWithImage:image];
    imageViewTitle.frame = CGRectMake(80,5,157,36);
    
    [self.navigationController.navigationBar addSubview:imageViewTitle];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [imageViewTitle removeFromSuperview];
}

-(void)viewDidUnload{
    [self setScrollView:nil];
    [self setPageControll:nil];
    [self setBtnForGotPassword:nil];
    [self setBtnDisclaimer:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma Mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControll.currentPage = page;
   // self.pageControl.currentPage=page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
}

#pragma Mark - Button Action Methods

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControll.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
}

- (IBAction)btnSingUpPressed:(id)sender {
    
     SingUp1ViewConroller *singup1ViewController=[[SingUp1ViewConroller alloc]initWithNibName:@"SingUp1ViewConroller" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO];
    singup1ViewController.title=@"Step 1";
    [self.navigationController pushViewController:singup1ViewController animated:YES];

}
- (IBAction)btnLoginPressed:(id)sender {
    
    LoginViewController *loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO];
    loginViewController.title=@"Login";
    [self.navigationController pushViewController:loginViewController animated:YES];

}

- (IBAction)btnForgotPasswordPressed:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:@"please enter email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show]; 

}

- (IBAction)btnDisclaminerPressed:(id)sender {
  
    TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
    objTemp.strSetting_Name=@"Disclaimer";
    objTemp.title=@"Disclaimer";
    [self.navigationController pushViewController:objTemp animated:TRUE];
}
//Alertview Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
    if(buttonIndex==1){
      
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading...";

        //[PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
        [PFUser requestPasswordResetForEmailInBackground:[[alertView textFieldAtIndex:0] text] block:^(BOOL succeeded, NSError *error) {
              [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            if(succeeded){
                 DisplayLocalizedAlert(@"Password Reset Mail Successfully sent"); 
            }else{
              
                DisplayLocalizedAlert(@"This Email is not associate with user"); 
            
            }
        }];
            
    }
         
}

@end
