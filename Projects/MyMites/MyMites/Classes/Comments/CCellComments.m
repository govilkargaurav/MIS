//
//  CCellComments.m
//  MyMites
//
//  Created by Apple-Openxcell on 10/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "CCellComments.h"
#import <QuartzCore/QuartzCore.h>

@implementation CCellComments

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        d = dVal;
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
    CALayer *l=[imglogo layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor colorWithRed:174.0/255.0 green:191.0/255.0 blue:52.0/255.0 alpha:1.0] CGColor];
    l.backgroundColor=[[UIColor clearColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
    
    NSString *strImgurl =[self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vImage"]]];
    if (![strImgurl isEqualToString:@""]) 
    {
        x=[[ImageViewURL alloc] init];
        x.imgV=imglogo;
        x.strUrl=[NSURL URLWithString:[d valueForKey:@"vImage"]];
    }
    lblName.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vFullName"]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *DateCreat = [dateFormatter1 dateFromString:[d valueForKey:@"tDateTime"]];
    
    dateFormatter1.dateFormat = @"dd MMMM yyyy";
    NSString *strDate = [dateFormatter1 stringFromDate:DateCreat];
    lblDate.text = [NSString stringWithFormat:@"%@",strDate];
    lblDesc.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vReview"]];
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
