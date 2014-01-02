//
//  SubscribeViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 5/7/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "SubscribeViewController.h"
#import "AppDelegate.h"
#import "SubclassInAppHelper.h"

@implementation SubscribeViewController

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)CloseSubscriptionBarButton
{
    if([AppDel.popOverSubscriptionObj isPopoverVisible])
    {
        [AppDel.popOverSubscriptionObj dismissPopoverAnimated:YES];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Subscription";
        
    UIBarButtonItem* barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CloseSubscriptionBarButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonCancel;
    
    [AppDel doshowHUD];
    NSString *strURL;
    strURL = [NSString stringWithFormat:@"%@c=package&func=getallpackage",WebURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
    {
        
        NSError *err;
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
        dictPackegData = [[NSDictionary alloc]initWithDictionary:dictData];
        AppDel.arPackageList = [[NSArray alloc] initWithArray:[dictData valueForKey:@"list"]];
        
        // Add Button Dynamically
        int yAxix = 0;
        
        for(int M=0;M<[[dictData valueForKey:@"list"] count];M++)
        {
            UIButton *btnSubScriptionPlan = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSubScriptionPlan setBackgroundImage:[UIImage imageNamed:@"BtnSubscription.png"] forState:UIControlStateNormal];
            [btnSubScriptionPlan setTitle:[NSString stringWithFormat:@"%@ %@",[[[dictData valueForKey:@"list"] objectAtIndex:M]valueForKey:@"vDuration"],[[[dictData valueForKey:@"list"] objectAtIndex:M]valueForKey:@"vType"]] forState:UIControlStateNormal];
            [btnSubScriptionPlan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnSubScriptionPlan setTag:M];
            [btnSubScriptionPlan setFrame:CGRectMake(57, yAxix, 360, 40)];
            [btnSubScriptionPlan addTarget:self action:@selector(ClickBtnSubscribe:) forControlEvents:UIControlEventTouchUpInside];
            [scl_Sub addSubview:btnSubScriptionPlan];
            yAxix = yAxix + 60;
        }
        
        /*UIButton *btnRestore = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRestore setBackgroundImage:[UIImage imageNamed:@"BtnSubscription.png"] forState:UIControlStateNormal];
        [btnRestore setTitle:@"Restore" forState:UIControlStateNormal];
        [btnRestore setFrame:CGRectMake(57, yAxix, 360, 40)];
        [btnRestore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnRestore addTarget:self action:@selector(ClickBtnRestore:) forControlEvents:UIControlEventTouchUpInside];
        [scl_Sub addSubview:btnRestore];
        yAxix = yAxix + 60;*/
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"BtnSubscription.png"] forState:UIControlStateNormal];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel setFrame:CGRectMake(57, yAxix, 360, 40)];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(ClickBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [scl_Sub addSubview:btnCancel];
        yAxix = yAxix + 20;
        
        scl_Sub.contentSize = CGSizeMake(482, yAxix);
        [AppDel dohideHUD];
    }];
    
    // InApp Purchase
    /*AppDel._priceFormatter = [[NSNumberFormatter alloc] init];
    [AppDel._priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [AppDel._priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];*/

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(482, 462);	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - IBAction Methods
-(IBAction)ClickBtnCancel:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeSubscribe" object:nil];
}
/*-(IBAction)ClickBtnRestore:(id)sender
{
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"])
    {
        [AppDel doshowHUD];
        [SubclassInAppHelper sharedInstance];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
}*/

-(IBAction)ClickBtnSubscribe:(id)sender
{
    if ([AppDel.downloadingArray count] > 0)
    {
        DisplayAlertWithTitle(App_Name, @"Download in progress. Please complete or cancel all downloads.");
    }
    else
    {
                
        if([[[[ NSUserDefaults standardUserDefaults ] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"])
        {
            DisplayAlertWithTitle(App_Name, @"Your subscription has been activated!");
        }
        else
        {
            if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"] )
            {
                PromoCodeViewController *objPromoCodeViewController = [[PromoCodeViewController alloc]initWithNibName:@"PromoCodeViewController" bundle:nil];
                objPromoCodeViewController.atIndex = [sender tag];
                objPromoCodeViewController.dictPackegData = [dictPackegData copy];
                //objPromoCodeViewController.contentSizeForViewInPopover = CGSizeMake(482, 222);
                [self.navigationController pushViewController:objPromoCodeViewController animated:YES];
            }
            else{
                UIAlertView *alertLogin = [[UIAlertView alloc]initWithTitle:App_Name message:@"Please Sign In for subscribe" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertLogin show];
            }
        }
    }
}


#pragma mark - UIAlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if([alertView tag] == 3)
    {
        if(buttonIndex == 1){
            alertEnterPromoCode = [[UIAlertView alloc]initWithTitle:App_Name message:@"Enter promo code" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alertEnterPromoCode setTag:5];
            [alertEnterPromoCode show];
        }
    }
    else if([alertView tag] == 5){
        
        if(buttonIndex == 1)
        {            
        }
    }
}

#pragma mark - Reload Product From Apple
- (void)reload
{
    [AppDel dohideHUD];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
	return YES;
}
@end
