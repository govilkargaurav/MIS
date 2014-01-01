//
//  CCellAddMate.m
//  MyMites
//
//  Created by Apple-Openxcell on 10/4/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "CCellAddMate.h"

@implementation CCellAddMate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal indexpathval:(int)indexpath
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		d = dVal;
        i = indexpath;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *strImgurl =[self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vImage"]]];
    if (![strImgurl isEqualToString:@""]) 
    {
        x=[[ImageViewURL alloc] init];
        x.imgV=imgProfile;
        x.strUrl=[NSURL URLWithString:[d valueForKey:@"vImage"]];
    }
    NSString *strFullname  = [self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"fullname"]]];
    strFullname = [strFullname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strFullname length] == 0)
    {
        lblName.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vBusiness"]];
    }
    else
    {
        lblName.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"fullname"]];
    }
    lblCity.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vCity"]];
    lblOccu.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vOccupation"]];
    btnAddMate.tag = i;
    
    if ([[d valueForKey:@"mate_satus"] isEqualToString:@"Not connected"])
    {
        [btnAddMate setTitle:@"Add Mate" forState:UIControlStateNormal];
    }
    else if ([[d valueForKey:@"mate_satus"] isEqualToString:@"Mate"])
    {
        [btnAddMate setTitle:@"Connected" forState:UIControlStateNormal];
    }
    else if ([[d valueForKey:@"mate_satus"] isEqualToString:@"Pending"])
    {
        [btnAddMate setTitle:@"Pending" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Remove NULL

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
