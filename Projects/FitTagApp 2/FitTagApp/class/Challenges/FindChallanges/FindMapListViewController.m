//
//  FindMapListViewController.m
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FindMapListViewController.h"
#import "FindMapViewController.h"
#import "MapListCell.h"
#import "FindChallengesViewConroller.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation FindMapListViewController
@synthesize tblMapList;
@synthesize mutArrayNearChlng;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.

}
#pragma mark - View lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    
    //navigation back Button- Arrow
    UIButton *btnMap=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnMap addTarget:self action:@selector(btnMapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnMap setFrame:CGRectMake(0, 0, 40, 44)];
    [btnMap setImage:[UIImage imageNamed:@"headerMap"] forState:UIControlStateNormal];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40,44)];
    [view addSubview:btnMap];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-11;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    [self sortArrayByDistance];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidUnload{
    [self setTblMapList:nil];
    [super viewDidUnload];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark
#pragma mark Sort Array Accroding Challenge Distance 
-(void)sortArrayByDistance{
    // User's location
    @try {
        
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        // Create a query for places
        PFQuery *query = [PFQuery queryWithClassName:@"Challenge"];
        // Interested in locations near user.
        [query whereKey:@"location" nearGeoPoint:point];
        // Limit what could be a lot of points.
        //  query.limit = 10;
        // Final list of objects
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                mutArrayNearChlng=[objects mutableCopy];
                [tblMapList reloadData];
            }
            
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
    
}
#pragma Mark- TableView Delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mutArrayNearChlng count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    MapListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MapListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell.imgUsrProfile.layer setBorderWidth:1.0];
        [cell.imgUsrProfile.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.imgUsrProfile.layer setCornerRadius:5.0];
        //cell.imgProfileView.layer.masksToBou
        cell.imgUsrProfile.clipsToBounds=YES;
        cell.lblTitle.font=[UIFont fontWithName:@"DynoBold" size:18];
        cell.lblSubTitle.font=[UIFont fontWithName:@"DynoRegular" size:14];
        
        }
    PFObject   *objChallengeInfo=[mutArrayNearChlng objectAtIndex:indexPath.row];
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    [cell.imgUsrProfile setImageURL:[NSURL URLWithString:[teaserImage url]] ];
    cell.lblTitle.text= cell.lblTitle.text=[objChallengeInfo objectForKey:@"challengeName"];
    cell.lblSubTitle.text=[objChallengeInfo objectForKey:@"locationName"];    
    PFGeoPoint *chlngGeoLocation =[objChallengeInfo objectForKey:@"location"]; 
    
    CLLocation *chlngLocation=[[CLLocation alloc] initWithLatitude:chlngGeoLocation.latitude longitude:chlngGeoLocation.longitude];
    CLLocationDistance miles = ([chlngLocation distanceFromLocation:currentLocation])* 0.000621371192;
//    if(chlngLocation.coordinate.latitude == 0.0){
//       cell.lblSubTitle.text = [objChallengeInfo objectForKey:@"locationName"];
//        //cell.lblSubTitle.text=@"Location not available";
//    }else{
//      
//    }
      cell.lblSubTitle.text=[NSString stringWithFormat:@"%.2f miles",miles];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //cell.lblTitle.text=@"30 min killer workout";
    //cell.lblSubTitle.text=@"1.5 miles";
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.delegate  backWithListSelection:[mutArrayNearChlng objectAtIndex:indexPath.row] indexNo:indexPath.row];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];

    
}
#pragma mark
#pragma mark Button Actions
-(IBAction)btnMapPressed:(id)sender{

//    FindMapViewController *findMapViewController = [[FindMapViewController alloc] initWithNibName:@"FindMapViewController" bundle:[NSBundle mainBundle]];
//    findMapViewController.title=@"Map";
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:0.80];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
//                           forView:self.navigationController.view cache:NO];
//    
//    [self.navigationController pushViewController:findMapViewController animated:YES];
//    [UIView commitAnimations];

    [self.delegate  backWithListSelection:nil indexNo:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];

}
-(IBAction)btnHeaderbackPressed:(id)sender{

    // [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    NSArray *array = [self.navigationController viewControllers];
    for(int i=0;i<array.count;i++){
        if([[array objectAtIndex:i] isKindOfClass:[FindChallengesViewConroller class]]){
            
            [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
            break;
        }
        
        
    }

}
@end
