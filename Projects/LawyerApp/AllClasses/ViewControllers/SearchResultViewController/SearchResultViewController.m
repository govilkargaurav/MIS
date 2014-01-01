//
//  SearchResultViewController.m
//  LawyerApp
//
//  Created by Openxcell Game on 6/7/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "SearchResultViewController.h"
#import "JSONParsingAsync.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "DisplayMap.h"
#import "MapView.h"
#import "Place.h"

@interface SearchResultViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@end

@implementation SearchResultViewController
@synthesize appdelegate;
@synthesize headerViewSectionOne;
@synthesize headerViewSectionTwo;
@synthesize _strlawyerId=strlawyerId;
@synthesize _arrLawyerInfo=arrLawyerInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];
    // Do any additional setup after loading the view from its nib.
    segmentControl.selectedSegmentIndex=0;
    
    if (IS_IPHONE_5) {
        segmentControl.frame = CGRectMake(49, 522, 222, 30);
    }else{
        segmentControl.frame = CGRectMake(49, 450, 222, 30);
    }

}
#pragma mark- 
#pragma mark Segment Control

-(IBAction)selectSegment:(id)sender{
    
    segmentControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentControl.selectedSegmentIndex;
    segmentControl.selectedSegmentIndex=selectedSegment;
    if(selectedSegment==1){
        
        segmentControl.selectedSegmentIndex=1;
        viewFirm.frame  = CGRectMake(0, 0, 320, 450);
        [self.tblView addSubview:viewFirm];
        [self LawyerFirm:nil];
        
    }else{
        [viewFirm removeFromSuperview];
        segmentControl.selectedSegmentIndex=0;
        [self setlabelForLawyers:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    APP_DELEGATE;
    INTERNET_NOT_AVAILABLE
    
    [_queue addOperationWithBlock:^{
       
        id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=lawyer_detail&lawyer_id=%@",WEBSERVICE_HEADER,strlawyerId]];
        NSDictionary *jsonDictionary;
        NSArray *jsonArray;
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            jsonArray = (NSArray *)jsonObject;
        }else if([jsonObject isKindOfClass:[NSDictionary class]]){
            jsonDictionary = (NSDictionary *)jsonObject;
        }
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            arrLawyerInfo = [[NSMutableArray alloc] init];
            arrLawyerInfo = [[jsonDictionary valueForKey:@"user_info"] mutableCopy];
            [self setlabelForLawyers:nil];
            [self.tblView reloadData];
        }];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 
#pragma mark UITabelView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 90;
    }else{
        
        return 72;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
    if (section==0) {
        
        return headerViewSectionOne;
    }else{
        
        return headerViewSectionTwo;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return 100;
    }else{
        
        return 75;
    }
    
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (arrLawyerInfo==nil) {
        
        return cell;
    }
        if (indexPath.section==0) {
            
            UILabel *lblCell=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 22)];
            lblCell.font=[UIFont fontWithName:@"Arial" size:18.0];
            lblCell.textColor=[UIColor brownColor];
            lblCell.backgroundColor=[UIColor clearColor];
            lblCell.text=@"Areas of Practice";
            [cell.contentView addSubview:lblCell];
            
            UILabel *lblCell2=[[UILabel alloc] initWithFrame:CGRectMake(10, 36, 250, 50)];
            lblCell2.font=[UIFont fontWithName:@"Arial" size:14.0];
            lblCell2.textColor=[UIColor brownColor];
            lblCell2.backgroundColor=[UIColor clearColor];
            if ([[arrLawyerInfo valueForKey:@"area_of_law"] isEqualToString:@""]) {
                lblCell2.text=@"Information Not Available";
            }else{
                lblCell2.text=[arrLawyerInfo valueForKey:@"area_of_law"];
            }
            [cell.contentView addSubview:lblCell2];
            
        }else{
            
            if (indexPath.row==0) {
                
                UILabel *lblCellEducation=[[UILabel alloc] initWithFrame:CGRectMake(10,5, 100, 22)];
                lblCellEducation.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEducation.textColor=[UIColor brownColor];
                lblCellEducation.backgroundColor=[UIColor clearColor];
                lblCellEducation.text=@"Education :";
                [cell.contentView addSubview:lblCellEducation];
                
                UILabel *lblCellEmail=[[UILabel alloc] initWithFrame:CGRectMake(10, 27, 100, 22)];
                lblCellEmail.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEmail.textColor=[UIColor brownColor];
                lblCellEmail.backgroundColor=[UIColor clearColor];
                lblCellEmail.text=@"Email :";
                [cell.contentView addSubview:lblCellEmail];
                
                UILabel *lblCellphone=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 22)];
                lblCellphone.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellphone.textColor=[UIColor brownColor];
                lblCellphone.backgroundColor=[UIColor clearColor];
                lblCellphone.text=@"Phone :";
                [cell.contentView addSubview:lblCellphone];
                
                UILabel *lblCellEducationvalue=[[UILabel alloc] initWithFrame:CGRectMake(90,5, 250, 22)];
                lblCellEducationvalue.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEducationvalue.textColor=[UIColor blackColor];
                lblCellEducationvalue.backgroundColor=[UIColor clearColor];
                lblCellEducationvalue.text=[[[arrLawyerInfo valueForKey:@"vEducation"] RemoveNull] infoNotAvailable];
                [cell.contentView addSubview:lblCellEducationvalue];
                
                UIButton *btncellEmailValue = [UIButton buttonWithType:UIButtonTypeCustom];
                btncellEmailValue.frame = CGRectMake(90, 27, 250, 22);
                [btncellEmailValue setTitle:[[[arrLawyerInfo valueForKey:@"vEmail"] RemoveNull] infoNotAvailable] forState:UIControlStateNormal];
                [btncellEmailValue setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btncellEmailValue setBackgroundColor:[UIColor clearColor]];
                btncellEmailValue.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                [btncellEmailValue addTarget:self action:@selector(btnClickSendMail:) forControlEvents:UIControlEventTouchUpInside];
                [btncellEmailValue setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [cell.contentView addSubview:btncellEmailValue];
                                
                UIButton *btnCellphoneValue = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCellphoneValue.frame = CGRectMake(90 , 50, 250, 22);
                [btnCellphoneValue setTitle:[[[arrLawyerInfo valueForKey:@"vPhone"] RemoveNull] infoNotAvailable] forState:UIControlStateNormal];
                [btnCellphoneValue setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btnCellphoneValue setBackgroundColor:[UIColor clearColor]];
                btnCellphoneValue.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                [btnCellphoneValue addTarget:self action:@selector(makeAcall:) forControlEvents:UIControlEventTouchUpInside];
                [btnCellphoneValue setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [cell.contentView addSubview:btnCellphoneValue];
                
            }else{
                
                UILabel *lblCellEducation=[[UILabel alloc] initWithFrame:CGRectMake(10,5, 100, 22)];
                lblCellEducation.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEducation.textColor=[UIColor brownColor];
                lblCellEducation.backgroundColor=[UIColor clearColor];
                lblCellEducation.text=@"State :";
                [cell.contentView addSubview:lblCellEducation];
                
                UILabel *lblCellEmail=[[UILabel alloc] initWithFrame:CGRectMake(10, 27, 100, 22)];
                lblCellEmail.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEmail.textColor=[UIColor brownColor];
                lblCellEmail.backgroundColor=[UIColor clearColor];
                lblCellEmail.text=@"Price :";
                [cell.contentView addSubview:lblCellEmail];
                
                UILabel *lblCellphone=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 22)];
                lblCellphone.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellphone.textColor=[UIColor brownColor];
                lblCellphone.backgroundColor=[UIColor clearColor];
                lblCellphone.text=@"Website :";
                [cell.contentView addSubview:lblCellphone];
                
                UILabel *lblCellEducationSate=[[UILabel alloc] initWithFrame:CGRectMake(90,5, 250, 22)];
                lblCellEducationSate.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellEducationSate.textColor=[UIColor blackColor];
                lblCellEducationSate.backgroundColor=[UIColor clearColor];
                lblCellEducationSate.text=[[[arrLawyerInfo valueForKey:@"iStateName"] RemoveNull] infoNotAvailable];
                [cell.contentView addSubview:lblCellEducationSate];
                
                UILabel *lblCellEmailPrice=[[UILabel alloc] initWithFrame:CGRectMake(90, 27, 250, 22)];
                lblCellEmailPrice.font=[UIFont fontWithName:@"American Typewriter" size:14.0];
                lblCellEmailPrice.textColor=[UIColor blackColor];
                lblCellEmailPrice.backgroundColor=[UIColor clearColor];
                lblCellEmailPrice.text=[[[arrLawyerInfo valueForKey:@"vPrice"] RemoveNull] infoNotAvailable];
                [cell.contentView addSubview:lblCellEmailPrice];
                
                NSLog(@"%@",[[[arrLawyerInfo valueForKey:@"vWebsite"] RemoveNull] infoNotAvailable]);
                NSAttributedString* attrStr2 =[[NSAttributedString alloc] initWithString:[[[arrLawyerInfo valueForKey:@"vWebsite"] RemoveNull] infoNotAvailable] attributes: @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
                UILabel *lblCellwebsite=[[UILabel alloc] initWithFrame:CGRectMake(90, 50, 250, 22)];
                lblCellwebsite.font=[UIFont fontWithName:@"Arial" size:14.0];
                lblCellwebsite.textColor=[UIColor blackColor];
                lblCellwebsite.backgroundColor=[UIColor clearColor];
                lblCellwebsite.attributedText = attrStr2;
                [cell.contentView addSubview:lblCellwebsite];
            }
        }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark- 
#pragma mark Make a Call
-(void)makeAcall:(id)sender{
    
    NSString *strTelNumber = [NSString stringWithFormat:@"tel:%@",[sender titleForState:UIControlStateNormal]];
    if ([UIApplication instancesRespondToSelector:@selector(canOpenURL:)]) {
        NSURL *aURL = [NSURL URLWithString:strTelNumber];
        if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
            [[UIApplication sharedApplication] openURL:aURL];
        }
    }
}


#pragma mark-
#pragma mark SEND EMAIL
-(void)btnClickSendMail:(id)sender{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        NSString *subject=@"";
        NSString *mailBody=@"";
        NSString *strEmailId = [sender titleForState:UIControlStateNormal];
        NSArray *recipients=[[NSArray alloc] initWithObjects:strEmailId, nil];
        
        [emailController setSubject:subject];
        [emailController setMessageBody:mailBody isHTML:YES];
        [emailController setToRecipients:recipients];
        
        // [self presentModalViewController:emailController animated:YES];
        [self presentViewController:emailController animated:TRUE completion:nil];
    }
}

#pragma mark-Mail Controller Delegate Method
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    // Notifies users about errors associated with the interface
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            break;
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 
#pragma mark SET LABELS FOR LAWYER

-(void)setlabelForLawyers:(id)sender{
    
    [userImageView setImageWithURL:[arrLawyerInfo valueForKey:@"vProfilePic"] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageProgressiveDownload];
    lblFullName.text = [[[NSString stringWithFormat:@"%@ %@",[arrLawyerInfo valueForKey:@"vFirstName"],[arrLawyerInfo valueForKey:@"vLastName"]] RemoveNull] infoNotAvailable];
    lblAddress.text = [[[NSString stringWithFormat:@"%@ %@",[arrLawyerInfo valueForKey:@"vAddress1"],[arrLawyerInfo valueForKey:@"vAddress2"]] RemoveNull] infoNotAvailable];
    lblCity.text = [[[arrLawyerInfo valueForKey:@"vCity"] RemoveNull] infoNotAvailable];
    lblCountryName.text = [[[arrLawyerInfo valueForKey:@"country_name"] RemoveNull] infoNotAvailable];
    lblofficeStartTime.text = [[[arrLawyerInfo valueForKey:@"dOfficeStartTime"] RemoveNull] infoNotAvailable];
    lblofficeEndTime.text = [[[arrLawyerInfo valueForKey:@"dOfficeEndTime"] RemoveNull] infoNotAvailable];
}

#pragma mark- 
#pragma mark Information of Lawyer Firm

-(void)LawyerFirm:(id)sender{
    
    userImageView.image=nil;
    lblFullName.text=@"";
    lblAddress.text=@"";
    NSString *strAboutFirm = [[[arrLawyerInfo valueForKey:@"tAboutFirm"] RemoveNull] infoNotAvailable];
    [wbView loadHTMLString:[strAboutFirm stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
    lblFirmAddress.text = [[[NSString stringWithFormat:@"%@ %@",[arrLawyerInfo valueForKey:@"vFirmAddress1"],[arrLawyerInfo valueForKey:@"vFirmAddress2"]] RemoveNull] infoNotAvailable];
    lblStatus.text = [[[arrLawyerInfo valueForKey:@"eStatus"] RemoveNull] infoNotAvailable];
    lblFirmCity.text = [[[arrLawyerInfo valueForKey:@"vFirmCity"] RemoveNull] infoNotAvailable];
    lblFirmName.text = [NSString stringWithFormat:@"Firm Name : %@",[[[arrLawyerInfo valueForKey:@"vFirmName"] RemoveNull] infoNotAvailable]];
    [ImageFirmLogo setImageWithURL:[arrLawyerInfo valueForKey:@"vFirmLogo"] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageProgressiveDownload];
    
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude =[[arrLawyerInfo valueForKey:@"vLat"] floatValue];
    region.center.longitude =[[arrLawyerInfo valueForKey:@"vLon"] floatValue];
    MKCoordinateSpan span;
    span.latitudeDelta = .01;
    span.longitudeDelta = .01;
    region.span = span;
    [mapView setRegion:region animated:YES];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    DisplayMap *ann = [[DisplayMap alloc] init];
    ann.title=[arrLawyerInfo valueForKey:@"vFirmAddress1"];
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
}

#pragma mark BackBtn

-(IBAction)backBtnPressed:(id)sender{    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)routefrom:(id)sender{

    MapView* mapViewRoot = [[MapView alloc] initWithFrame:CGRectMake(0,300,320,126)];
    [viewFirm addSubview:mapViewRoot];
    Place* home = [[Place alloc] init];
    home.name = @"Current Location";
    home.latitude =  locationManager.location.coordinate.latitude;
    home.longitude = locationManager.location.coordinate.longitude;
    Place* office = [[Place alloc] init];
    office.name = [arrLawyerInfo valueForKey:@"vFirmAddress1"];
    office.latitude = [[arrLawyerInfo valueForKey:@"vLat"] floatValue];
    office.longitude = [[arrLawyerInfo valueForKey:@"vLon"] floatValue];
    [mapViewRoot showRouteFrom:home to:office];

}


@end
