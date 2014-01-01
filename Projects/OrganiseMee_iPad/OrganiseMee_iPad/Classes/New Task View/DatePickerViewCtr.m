//
//  DatePickerViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "DatePickerViewCtr.h"

@interface DatePickerViewCtr ()

@end

@implementation DatePickerViewCtr
@synthesize _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDeckControllerDidCloseRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    NSArray *vList = [self.navigationController viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i)
    {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"TempRightViewCtr"])
        {
            [self.navigationController popToViewController:view animated:YES];
            break;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)CanclePressedDate:(id)sender
{
	[self CallPopViewCtr];
}
-(IBAction)DonePressedDate:(id)sender
{    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *strDateFormate = [[NSUserDefaults standardUserDefaults] stringForKey:@"DateSetting"];
    if ([strDateFormate intValue] == 0)
    {
        [df setDateFormat:@"dd.MM.yyyy"];
    }
    else
    {
        [df setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *strDate=[NSString stringWithFormat:@"%@",[df stringFromDate:DatepickerView.date]];
    
    
    [df setDateFormat:@"yyyy-MM-dd"];
    [_delegate Done:strDate str:[df stringFromDate:DatepickerView.date]];
    [self CallPopViewCtr];
}
-(IBAction)DeleteExistingDate:(id)sender
{
    [_delegate DeleteExisteingDate];
    [self CallPopViewCtr];
}
-(void)CallPopViewCtr
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
