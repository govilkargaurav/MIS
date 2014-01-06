//
//  KeypadVC.m
//  T&L
//
//  Created by apple apple on 6/23/12.
//  Copyright (c) 2012 bvhkh. All rights reserved.
//

#import "KeypadVC.h"
#import "QuestionAssessorViewController.h"
#import "NavigationController.h"
#import "GlobleClass.h"
#import "SignatureViewController.h"
@implementation KeypadVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)Cancelbtn:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     aryImages = [[NSMutableArray alloc] initWithObjects:btnPin1,btnPin2,btnPin3,btnPin4,btnPin5, nil];
     aryPinCode = [[NSMutableArray alloc]init];
//    NavigationController *navScreenController  = [[NavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
//    [self.view addSubview:navScreenController.view];
//    [navScreenController setFocusButton:1];

    // Do any additional setup after loading the view from its nib.
}

-(IBAction)Keyboardbtn:(id)sender
{
    //    UIButton *btnClick = (UIButton*)sender;
    //    [btnClick setSelected:YES];
    
    if([aryPinCode count]<5)
    {
        [aryPinCode addObject:[NSString stringWithFormat:@"%d",[sender tag]]];
        [[aryImages objectAtIndex:[aryPinCode count]-1] setImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
        if([aryPinCode count]==5)
        {
            NSString *str_Pin = [aryPinCode componentsJoinedByString:@""];
            NSString *strAssPin = [[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"];
            
            if([strAssPin isEqualToString:str_Pin])
            {
                [self.navigationController viewWillAppear:YES];
                [self.navigationController popViewControllerAnimated:NO];
                //QuestionAssessorViewController *QAview=[[QuestionAssessorViewController alloc] initWithNibName:@"QuestionAssessorViewController" bundle:nil];
                //[self.navigationController pushViewController:QAview animated:YES];
            }
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Please enter correct pin number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [alertView show];
            }
        }
    }  
}

-(IBAction)btnPinClear:(id)sender
{
    if([aryPinCode count]>=1)
    {
        [aryPinCode removeLastObject];
        [[aryImages objectAtIndex:[aryPinCode count]] setImage:nil forState:UIControlStateNormal];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)login:(id)sender
{
    //[self.navigationController viewWillAppear:YES];
    //[self.navigationController popViewControllerAnimated:NO];
    
    /*
    
    if ([navigationString isEqualToString:@"1"]) {
        
        SignatureViewController *controller=[[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:nil];
        navigationString=@"0";
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else
    {   
        //ParticipatnsContinue = @"YES";
        
        
        QuestionAssessorViewController *QAview=[[QuestionAssessorViewController alloc] initWithNibName:@"QuestionAssessorViewController" bundle:nil];
        [self.navigationController pushViewController:QAview animated:YES];
        
    }
    */
}

@end
