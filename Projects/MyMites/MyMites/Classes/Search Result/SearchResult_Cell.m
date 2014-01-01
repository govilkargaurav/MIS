//
//  SearchResult_Cell.m
//  MyMites
//
//  Created by Apple-Openxcell on 9/8/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "SearchResult_Cell.h"
#import "JSFavStarControl.h"

@implementation SearchResult_Cell


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
    NSString *strImgurl =[self removeNull:[NSString stringWithFormat:@"%@",[d valueForKey:@"vImage"]]];
    if (![strImgurl isEqualToString:@""]) 
    {
        x=[[ImageViewURL alloc] init];
        x.imgV=imgProfile;
        x.strUrl=[NSURL URLWithString:[d valueForKey:@"vImage"]];
    }
    
    if ([[self removeNull:[d valueForKey:@"vFirst"]] length] == 0 && [[self removeNull:[d valueForKey:@"vLast"]] length] == 0)
    {
        lblName.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vBusiness"]];
    }
    else
    {
        lblName.text = [NSString stringWithFormat:@"%@ %@",[d valueForKey:@"vFirst"],[d valueForKey:@"vLast"]];
    }
    lblDesignation.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vOccupation"]];
    
    NSString *strAdd1 = [self removeNull:[d valueForKey:@"vAddress1"]];
    NSString *strAdd2 = [self removeNull:[d valueForKey:@"vAddress2"]];
    
    if ([strAdd1 length] == 0 && [strAdd2 length] == 0)
    {
        lblState.text = @"---";
    }
    else if ([strAdd2 length] > 0)
    {
         lblState.text = [NSString stringWithFormat:@"%@,%@",strAdd1,strAdd2];
    }
    else
    {
        lblState.text = [NSString stringWithFormat:@"%@",strAdd1];
    }
    
    lblConnNo.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"mutualFriendCount"]];
    
    lblmobileno.text = [self removeNull:[d valueForKey:@"vMobile"]];
    if ([lblmobileno.text length] == 0)
    {
        btnmobileno.userInteractionEnabled = NO;
        lblmobileno.text = @"---";
    }
    lblLandNo.text = [self removeNull:[d valueForKey:@"vPhone"]];
    if ([lblLandNo.text length] == 0)
    {
        btnlanno.userInteractionEnabled = NO;
        lblLandNo.text = @"---";
    }
    
    if ([[self removeNull:[d valueForKey:@"vWebsite"]] length] == 0)
    {
        btnWebSite.userInteractionEnabled = NO;
        lblwebSite.text = @"---";
    }
    
    
    NSString *strRatingCount;
    if ([[d valueForKey:@"fRating"] isEqualToString:@"no rating found"])
    {
        strRatingCount = @"0";
    }
    else
    {
        strRatingCount = [d valueForKey:@"fRating"];
    }
    lblRating.text = [NSString stringWithFormat:@"%@/5",strRatingCount];
    
    
    if ([lblConnNo.text intValue] == 0 || [lblConnNo.text intValue] == 1)
    {
        if ([lblConnNo.text intValue] == 0)
            btnMateConn.userInteractionEnabled = NO;
        else
            btnMateConn.userInteractionEnabled = YES;
        lblS.hidden = YES;
    }
    else
    {
        btnMateConn.userInteractionEnabled = YES;
        lblS.hidden = NO;
    }
    btnConnect.tag = [[d valueForKey:@"iUserID"] intValue];
    btnMateConn.tag = i;
    btnlanno.tag = i;
    btnmobileno.tag = i;
    btnEmail.tag = i;
    
    starRating.starImage = [UIImage imageNamed:@"star1.png"];
    starRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    starRating.maxRating = 5.0;
    starRating.horizontalMargin = 0.0;
    starRating.userInteractionEnabled = NO;
    starRating.rating = [strRatingCount floatValue];
    starRating.displayMode = EDStarRatingDisplayHalf;
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

