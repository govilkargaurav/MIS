//
//  SettingsViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "SettingsViewController.h"
#import "GlobalClass.h"
#import "SVWebViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize titleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO (@"7.0"))
    {
        mainView.frame=CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y+64,mainView.frame.size.width, mainView.frame.size.height);
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    strTitleViewCalling = DRAW_RECT_DONT_NEED;
    /* To add Title View on Navigation Bar */
    CGRect Frame = CGRectMake(0, 0, 320, 44);
    titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"Settings"];
    [self.navigationController.navigationBar addSubview:titleView];
    /**************************************************************/
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark BUTTON ACTION
- (IBAction)aboutUsButtonAction:(id)sender
{
    AboutUsViewController *aboutUsViewController=[[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
    
}
-(IBAction)feedBackButtonAction:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"contact@appsyndrome.com"]];
        [mailViewController setSubject:@"Feedback"];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}
- (IBAction)privacypolicyAction:(id)sender
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://www.apple.com/au/privacy/"];
    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma -mark MFMAILCOMPOSER DELEGATE
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
