//
//  CCellRatings.m
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "CCellRatings.h"

@implementation CCellRatings

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
    lblName.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vFullname"]];
    lblRating.text = [NSString stringWithFormat:@"Average Rating %@/5",[d valueForKey:@"avg_rating"]];
    txtComment.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vComment"]];
    
    CostRating.starImage = [UIImage imageNamed:@"star1.png"];
    CostRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    CostRating.maxRating = 5.0;
    CostRating.horizontalMargin = 5.0;
    CostRating.userInteractionEnabled = NO;
    CostRating.rating = [[[d valueForKey:@"rateings"] valueForKey:@"cost"] floatValue];
    CostRating.displayMode = EDStarRatingDisplayHalf;
    
    ProRating.starImage = [UIImage imageNamed:@"star1.png"];
    ProRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    ProRating.maxRating = 5.0;
    ProRating.horizontalMargin = 5.0;
    ProRating.userInteractionEnabled = NO;
    ProRating.rating = [[[d valueForKey:@"rateings"] valueForKey:@"prof"] floatValue];
    ProRating.displayMode = EDStarRatingDisplayHalf;
    
    QuaRating.starImage = [UIImage imageNamed:@"star1.png"];
    QuaRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    QuaRating.maxRating = 5.0;
    QuaRating.horizontalMargin = 5.0;
    QuaRating.userInteractionEnabled = NO;
    QuaRating.rating = [[[d valueForKey:@"rateings"] valueForKey:@"quality"] floatValue];
    QuaRating.displayMode = EDStarRatingDisplayHalf;
    
    OverallRating.starImage = [UIImage imageNamed:@"star1.png"];
    OverallRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    OverallRating.maxRating = 5.0;
    OverallRating.horizontalMargin = 5.0;
    OverallRating.userInteractionEnabled = NO;
    OverallRating.rating = [[[d valueForKey:@"rateings"] valueForKey:@"overall"] floatValue];
    OverallRating.displayMode = EDStarRatingDisplayHalf;
    // Do any additional setup after loading the view from its nib.
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
