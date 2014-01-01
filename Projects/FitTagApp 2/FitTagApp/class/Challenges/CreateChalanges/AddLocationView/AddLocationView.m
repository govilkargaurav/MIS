//
//  AddLocationView.m
//  FitTag
//
//  Created by Shivam on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddLocationView.h"
#import "AddEquipmentCell.h"
#import "TagCustomCell.h"
#import "AddLocationCustomCell.h"

@implementation AddLocationView

@synthesize tblViewNearByLocations;
@synthesize delegate;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark - View lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //navigation back Button- Arrow

    appdelegateRefrence = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
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
    //Done Button
    
    UIButton *btnBarLocation=[UIButton buttonWithType:UIButtonTypeCustom];
    //[btnBarDone addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnBarLocation setFrame:CGRectMake(0, 0, 52, 30)];
    [btnBarLocation setImage:[UIImage imageNamed:@"headerLocation"] forState:UIControlStateNormal];
    [btnBarLocation setImage: [UIImage imageNamed:@"headerLocation"] forState:UIControlStateHighlighted];
   // UIBarButtonItem *rightDoneButton = [[UIBarButtonItem alloc] initWithCustomView:btnBarLocation ];
    [btnBarLocation addTarget:self action:@selector(refereshNearByLocationList) forControlEvents:UIControlEventTouchUpInside];
   
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52, 30)];
    [view addSubview:btnBarLocation];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-16;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    
    tblViewNearByLocations.dataSource = self;
    tblViewNearByLocations.delegate   = self;
    isSearching = NO;
    
    // Initialize the location manager for getting current location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = 10.0;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    mutArrSearchDisplay         = [[NSMutableArray alloc]init];
    mutArrNearByLocationList    = [[NSMutableArray alloc]init];
    mutArrLocationsAddedByUser  = [[NSMutableArray alloc]init];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading...";
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma Mark Get NearBy Locations
-(void)addNewCustomLocationInNearByPlaces{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//    
//    txtfldAddNewLocation = [[UITextField alloc]initWithFrame:CGRectMake(10.0,20.0,260.0,30.0)];
//    txtfldAddNewLocation.delegate = self;
//    
//    [txtfldAddNewLocation setFont:[UIFont systemFontOfSize:17]];
//    //txtfldEquipment.frame = CGRectMake(14, 90, 255, 30);
//    [txtfldAddNewLocation setBorderStyle:UITextBorderStyleRoundedRect];
//    [txtfldAddNewLocation setAutocorrectionType:UITextAutocorrectionTypeNo];
//    txtfldAddNewLocation.placeholder = @"Add New Location";
//    [txtfldAddNewLocation becomeFirstResponder];
//    [alert addSubview:txtfldAddNewLocation];
//    
//    [alert show];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fittag" message:@"Add new location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    txtfldAddNewLocation = [alert textFieldAtIndex:0];
    txtfldAddNewLocation.delegate = self;
    
    [txtfldAddNewLocation setFont:[UIFont systemFontOfSize:17]];
    [txtfldAddNewLocation setBorderStyle:UITextBorderStyleRoundedRect];
    [txtfldAddNewLocation setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtfldAddNewLocation.placeholder = @"Add Location";
    [txtfldAddNewLocation becomeFirstResponder];
    [alert addSubview:txtfldAddNewLocation];
    [alert show];
}
-(void)addCustomLocation{
    
    if([[txtfldAddNewLocation.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length ] > 0){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *mutDictAddLocation = [[NSMutableDictionary alloc]init];
        
        [mutDictAddLocation setObject:txtfldAddNewLocation.text forKey:@"name"];
        [mutDictAddLocation setObject:@"" forKey:@"address"];
        
        NSMutableDictionary *dictLocationInfo = [[NSMutableDictionary alloc]init];
        
        [dictLocationInfo setObject:[dictLatLong objectForKey:@"latitude"] forKey:@"lat"];
        [dictLocationInfo setObject:[dictLatLong objectForKey:@"longitude"] forKey:@"lng"];
        
        [mutDictAddLocation setObject:dictLocationInfo forKey:@"location"];
        
        [mutArrNearByLocationList insertObject: mutDictAddLocation atIndex:1];
        [mutArrLocationsAddedByUser addObject:mutDictAddLocation];
        
        // Add the custom location on parse server for further use
        
        PFObject *customLocation = [PFObject objectWithClassName:@"customLocation"];
        [customLocation setObject:dictLocationInfo forKey:@"location"];
        [customLocation setObject:txtfldAddNewLocation.text forKey:@"name"];
        
        //Set ACL permissions for added security
        PFACL *activitieACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [activitieACL setPublicReadAccess:YES];
        [customLocation setACL:activitieACL];
        [customLocation saveInBackgroundWithBlock:^(BOOL success, NSError *errCustomLocation){
            if(!errCustomLocation){
                // Custom location has been added successfully on parse server
                [tblViewNearByLocations reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                DisplayAlertWithTitle(@"Fittag", @"We are unable to add your loaction on server, Please try again.")
            }
        }];
    }
}
-(void)refereshNearByLocationList{
    isSearching = NO;
    txtfldSearchLocation.text = @"";
    if([txtfldSearchLocation isFirstResponder])
        [txtfldSearchLocation resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getNearByLocations];
}
-(void)getNearByLocations{
    @try {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSString *theDate = [dateFormat stringFromDate:[NSDate date]];
        
        NSString *strUrlNearBy = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&client_id=%@&client_secret=%@&v=%@",[NSString stringWithFormat:@"%g,%g",[[dictLatLong objectForKey:@"latitude"]doubleValue],[[dictLatLong objectForKey:@"longitude"]doubleValue]],@"PLIYVJZU1N5SKB2L30CFEDOCIQYZVU5LK2RHBBMBE4CB1RP4",@"5XAWATO35HLW0S1JUAO2H4QFQXTCSLFC1231WZ3VSKDAQ1KA",theDate];
        
        NSURL *UrlNearBy = [NSURL URLWithString:[strUrlNearBy stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *responceData = [NSData dataWithContentsOfURL:UrlNearBy];
        
        NSError *error;
        
        NSDictionary *dictPlaces = [NSJSONSerialization JSONObjectWithData:responceData options:NSJSONWritingPrettyPrinted error:&error];
        
        if(!error){
            
            if([[[dictPlaces objectForKey:@"meta"] objectForKey:@"code"] intValue] == 200){
                NSDictionary *dictResponse = [dictPlaces objectForKey:@"response"];
                NSArray *arrVenue = [[NSArray alloc]initWithArray:[dictResponse objectForKey:@"venues"]];
                
                if([arrVenue count] > 1){
                    [mutArrNearByLocationList removeAllObjects];
                    mutArrNearByLocationList = [arrVenue mutableCopy];
                    NSMutableDictionary *mutDictAddLocation = [[NSMutableDictionary alloc]init];
                    
                    [mutDictAddLocation setObject:@"Add New Location" forKey:@"name"];
                    [mutDictAddLocation setObject:@"" forKey:@"address"];
                    
                    [mutArrNearByLocationList insertObject:mutDictAddLocation atIndex:0];
                    
                    for (int i = 0; i < [mutArrLocationsAddedByUser count]; i++){
                        [mutArrNearByLocationList addObject:[mutArrLocationsAddedByUser objectAtIndex:i]];
                    }
                    
                    // Getting the custom location created by app users
                    
                    PFQuery *getCustomLocation = [PFQuery queryWithClassName:@"customLocation"];
                    NSMutableArray *mutArrParseCustomLocation = [[NSMutableArray alloc]initWithArray:[getCustomLocation findObjects]];
                    
                    for(int j = 0;j < [mutArrParseCustomLocation count];j++){
                        [mutArrNearByLocationList addObject:[mutArrParseCustomLocation objectAtIndex:j]];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [tblViewNearByLocations reloadData];
                }
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
    
   
}
#pragma mark
#pragma mark UIAlertView Deleagte
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex){
        case 0:
            [self addCustomLocation];
            break;
        case 1:
            break;
        default:
            break;
    }
}
#pragma Mark CLLOcationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    dictLatLong = [[NSMutableDictionary alloc]init];
    [dictLatLong setObject:[NSString stringWithFormat:@"%g",newLocation.coordinate.latitude ] forKey:@"latitude"];
    [dictLatLong setObject:[NSString stringWithFormat:@"%g",newLocation.coordinate.longitude] forKey:@"longitude"];
    
    [self performSelectorInBackground:@selector(getNearByLocations) withObject:nil];
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DisplayAlertWithTitle(@"FitTag",@"There is some problem occur in location services please try again");
}
#pragma Mark- TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isSearching)
        return [mutArrSearchDisplay count];
    else
        return [mutArrNearByLocationList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UserCell";
    AddLocationCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddLocationCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(isSearching){
        cell.lblLocatioName.text = [NSString stringWithFormat:@"%@,%@",[self removeNull: [[mutArrSearchDisplay objectAtIndex:indexPath.row] objectForKey:@"name"] ],[appdelegateRefrence removeNull:[[[mutArrSearchDisplay objectAtIndex:indexPath.row] objectForKey:@"location"]objectForKey:@"city"] ]];
        
        if([[cell.lblLocatioName.text substringFromIndex:[ cell.lblLocatioName.text length]-1] isEqualToString:@","]){
            cell.lblLocatioName.text = [cell.lblLocatioName.text substringToIndex:[ cell.lblLocatioName.text length]-1];
        }else{
            // Don't get comma at the last of string
        }
    }else{
        if([[[mutArrNearByLocationList objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Add New Location"]){
            cell.lblLocatioName.text = [[mutArrNearByLocationList objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else{
            cell.lblLocatioName.text = [NSString stringWithFormat:@"%@,%@",[[mutArrNearByLocationList objectAtIndex:indexPath.row] objectForKey:@"name"],[appdelegateRefrence removeNull:[[[mutArrNearByLocationList objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"city"] ]];
            
            if([[cell.lblLocatioName.text substringFromIndex:[ cell.lblLocatioName.text length]-1] isEqualToString:@","]){
                cell.lblLocatioName.text = [cell.lblLocatioName.text substringToIndex:[ cell.lblLocatioName.text length]-1];
            }else{
                // Don't get comma at the last of string
            }
        }
    }
    
    if([[[mutArrNearByLocationList objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Add New Location"] && !isSearching){
        cell.btnAddNewLocation.hidden  = NO;
        cell.btnAddNewLocation.enabled = YES;
        [cell.btnAddNewLocation addTarget:self action:@selector(addNewCustomLocationInNearByPlaces) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.btnAddNewLocation.hidden  = YES;
        cell.btnAddNewLocation.enabled = NO;    
    }
        cell.lblLocationAddress.font=[UIFont fontWithName:@"DynoRegular" size:17];
        cell.lblLocatioName.font=[UIFont fontWithName:@"DynoRegular" size:17];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
#pragma Mark- TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Checking whether searching or not
    if(isSearching){
        [self.delegate addLocationInPrevioseView:[mutArrSearchDisplay objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if(indexPath.row == 0){
            // User clicked on first row which is for add new location. Do nothing 
        }else{
            [self.delegate addLocationInPrevioseView:[mutArrNearByLocationList objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma Mark
#pragma Mark UItextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(txtfldAddNewLocation == textField)
        return YES;
    
    NSString *strSearchText = [textField.text stringByAppendingFormat:@"%@",string];
    
    if([textField.text length] == 1 && [strSearchText length] == 1){
        isSearching = NO;
        [tblViewNearByLocations reloadData];
        return YES;
    }
    
    if ([mutArrNearByLocationList count] > 0){
        isSearching = YES;
        [mutArrSearchDisplay removeAllObjects];
        
        //for(NSDictionary *strEventTag in mutArrNearByLocationList)
        for(NSDictionary *dictVenue in mutArrNearByLocationList){
            
            if ([string isEqualToString:@""]){
                NSString *strSearchText = [[NSString alloc]initWithString:[textField.text substringWithRange:NSMakeRange(0, textField.text.length-1)]];
                if (strSearchText.length==0) {
                    [mutArrSearchDisplay removeAllObjects];
                }else{
                    NSString *strS = [[NSString alloc]initWithString:[dictVenue objectForKey:@"name"]];
                    
                    NSRange range = [[strS lowercaseString] rangeOfString:[strSearchText lowercaseString]];
                    if(range.location != NSNotFound) {            
                        if(range.location== 0){
                            
                            if([[dictVenue objectForKey:@"name"] isEqualToString:@"Add New Location"]){
                                // Do not add the add new string in the array
                            }else{
                                [mutArrSearchDisplay addObject:dictVenue];
                            }
                        }            
                    }        
                    if ([mutArrSearchDisplay count]>0) {
                        //tblViewEventTagSearch.hidden=NO;
                    }
                }
            }else if ([string isEqualToString:@"\n"]){
                
            }else{
                NSString *strS = [[NSString alloc]initWithString:[dictVenue objectForKey:@"name"]];
                
                NSString *strSearchText = [textField.text stringByAppendingString:string];
                NSRange range = [[strS lowercaseString] rangeOfString:[strSearchText lowercaseString]];
                
                if(range.location != NSNotFound) {            
                    if(range.location== 0){
                       
                        if([[dictVenue objectForKey:@"name"] isEqualToString:@"Add New Location"]){
                            
                        }else{
                           // NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            //[dict setObject:[dictVenue objectForKey:@"name"] forKey:@"name"];
                           // [dict setObject:[self removeNull:[dictVenue objectForKey:@"address"]] forKey:@"address"];
                            
                            [mutArrSearchDisplay addObject:dictVenue];
                        }
                    }            
                }
                
                if ([mutArrSearchDisplay count] > 0){
                    //tblViewEventTagSearch.hidden = NO;
                }else{
                    
                }
            }
        }
        [tblViewNearByLocations reloadData];
    }
    return YES;
}
#pragma mark Remove Null
-(NSString *)removeNull:(NSString *)str{
    
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str){
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
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
