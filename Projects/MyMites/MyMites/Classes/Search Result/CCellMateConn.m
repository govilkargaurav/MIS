//
//  CCellMateConn.m
//  MyMites
//
//  Created by apple on 10/29/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "CCellMateConn.h"

@implementation CCellMateConn


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal name:(NSString *)strName
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		d = dVal;
        strNamePass = strName;
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
    NSString *strImgurl =[self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vImage"]]];
    if (![strImgurl isEqualToString:@""]) 
    {
        x=[[ImageViewURL alloc] init];
        x.imgV=imgProfile;
        x.strUrl=[NSURL URLWithString:[d valueForKey:@"vImage"]];
    }
    
    lblName.text = [self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vFullName"]]];
    lblDesignation.text = [self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vOccupation"]]];
    lblState.text = [self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vLocation"]]];
    
    if ([[d valueForKey:@"vReview"] isEqualToString:@"NO_COMMENTS"])
    {
        lblComment.text = [NSString stringWithFormat:@"%@ has left no comment for %@",[d valueForKey:@"vFullName"],strNamePass];
    }
    else
    {
        lblComment.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vReview"]];
    }
    
    CGSize stringSize = [self text:lblComment.text];
    if (stringSize.height > 36)
    {
        lblComment.frame = CGRectMake(82, 76, 217, 36);
    }
    else
    {
        lblComment.frame = CGRectMake(82, 76, 217, stringSize.height);
    }
    
    btnViewProfile.tag = [[d valueForKey:@"iMateID"] intValue];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Self Methods

-(CGSize)text:(NSString*)strTextContent
{
    CGSize constraintSize;
    constraintSize.width = 217.0f;
    constraintSize.height = MAXFLOAT;
    CGSize stringSize1 =[strTextContent sizeWithFont: [UIFont boldSystemFontOfSize: 12] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    return stringSize1;
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
