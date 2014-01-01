//
//  DatabaseBean.m
//  Coloplast iPAD
//
//  Created by freedom passion on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseBean.h"

@implementation DatabaseBean
@synthesize propertyID;
@synthesize addressStr;
@synthesize cityStr;
@synthesize zipStr;
@synthesize stateStr;
@synthesize latitudeStr;
@synthesize longitudeStr;
@synthesize borrowerFirstName;
@synthesize borrowerName;
@synthesize trusteeFirstNameStr;
@synthesize truseeId;
@synthesize AuctionId;
@synthesize AuctionDateTime;
@synthesize AuctionNote;
@synthesize bidderlastName;
@synthesize bidderFirstName;
@synthesize biddermiddleName;
@synthesize maxBidStr;
@synthesize openingbidStr;
@synthesize statusStr;
@synthesize updatedbyStr;
@synthesize updatedateStr;
@synthesize bidderidStr;
@synthesize wonpriceStr;
@synthesize legalDescription;
@synthesize countyID;
@synthesize auctionNumber;
@synthesize crierName;
@synthesize settleStatus;
@synthesize loanDate;
@synthesize loanAmount;
@synthesize checkAmount;
@synthesize checkNumber;

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
