//
//  SaveImageViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveImageViewController.h"


@interface SaveImageViewController ()

- (NSArray *)getAlbumNames;
- (BOOL)isCompletelyFilled;
- (void)resignAllResponders;
- (void)saveImageToDB:(NSString *)imageID;
- (void)uploadImage;
@end

@implementation SaveImageViewController
@synthesize image,txtAlbum,albumID,parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isUploading = NO;
    shouldAddLocation = YES;
    selectedLocation = 0;
    if ([Utility getLocationCountyAndState])
    {
        txtLocation.text = [Utility getLocationCountyAndState];
        txtLocation.text = [txtLocation.text stringByReplacingOccurrencesOfString:@";" withString:@","];
        shouldAddLocation = NO;
        [btnAddLoc setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [btnAddLoc setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateHighlighted];
    }
	// Do any additional setup after loading the view.
    
    
    albumPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"Select Album" targetViewController:self doneAction:@selector(albumSelected) pickerDidSelectAction:nil];
    
    locationPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"Select Location" targetViewController:self doneAction:@selector(locationPickerDismissed) pickerDidSelectAction:@selector(stateDidSelect)];
    [locationPicker setNumOfComponents:2];
    stateArray = [Utility getAllStatesList];
    if ([Utility getLocationState] && [stateArray containsObject:[Utility getLocationState]])
    {
        countiesArray = [Utility getAllCountiesListOfState:[Utility getLocationState]];
        selectedLocation = [stateArray indexOfObject:[Utility getLocationState]];
    }
    else {
        countiesArray = [Utility getAllCountiesListOfState:[stateArray objectAtIndex:0]];
    }
    [locationPicker setItems:stateArray inComponent:0];
    [locationPicker setItems:countiesArray inComponent:1];
    [txtLocation setInputView:locationPicker];
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Save Image"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    
    [self.navigationItem setHidesBackButton:YES];
    [self createAlbums];
    if (albumArray)
        RELEASE_SAFELY(albumArray);
    albumArray = [[[DAL sharedInstance]getAllAlbumNamesAndID:[Utility userID]] retain];
    [albumPicker setItems:[self getAlbumNames] inComponent:0];
    [txtAlbum setInputView:albumPicker];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)] autorelease];
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [titleView removeFromSuperview];
}


- (void)viewDidUnload
{
    RELEASE_SAFELY(titleView);
    RELEASE_SAFELY(txtAlbum);
    RELEASE_SAFELY(locationPicker);
    [txtCaption release];
    txtCaption = nil;
    [txtLocation release];
    txtLocation = nil;
    [swShareOnTwitter release];
    swShareOnTwitter = nil;
    [swShareOnFB release];
    swShareOnFB = nil;
    [swShareViaEmail release];
    swShareViaEmail = nil;
    [btnAddLoc release];
    btnAddLoc = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    parentController = nil;
    RELEASE_SAFELY(albumArray);
    RELEASE_SAFELY(albumID);
    RELEASE_SAFELY(albumPicker);
    RELEASE_SAFELY(uploadImageRequest);
    RELEASE_SAFELY(locationPicker);
    [txtCaption release];
    RELEASE_SAFELY(txtAlbum);
    [txtLocation release];
    [swShareOnTwitter release];
    [swShareOnFB release];
    [swShareViaEmail release];
    [btnAddLoc release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)saveImage
{
    [self resignAllResponders];
    if ([self isCompletelyFilled] && !isUploading)
    {
        isUploading = YES;
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Uploading Image..."];
        [self performSelectorInBackground:@selector(uploadImage) withObject:nil];
    }
}

- (void)uploadImage
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[Utility stringFromImage:image limit:1500000] forKey:KWEB_SERVICE_IMAGE];
    [dict setObject:txtCaption.text forKey:KWEB_SERVICE_IMAGE_TITLE];
    [dict setObject:@"0" forKey:KWEB_SERVICE_ALBUM_ID];
    [dict setObject:txtAlbum.text forKey:KWEB_SERVICE_ALBUM_DESCRIPTION];
    if (![txtLocation.text isEmptyString])
    {
        txtLocation.text = [txtLocation.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
        [dict setObject:txtLocation.text forKey:KWEB_SERVICE_IMAGE_LOCATION];
    }
    if (uploadImageRequest)
    {
        [uploadImageRequest setDelegate:nil];
        RELEASE_SAFELY(uploadImageRequest);
    }
    uploadImageRequest = [[WebServices alloc]init];
    [uploadImageRequest setDelegate:self];
    [uploadImageRequest uploadImage:dict];
    RELEASE_SAFELY(dict);
    
    [pool drain];
}


- (void)albumSelected
{
    NSString *albumSelected = [albumPicker getSelectedItemInComponent:0];
    [txtAlbum setText:albumSelected];
    NSInteger row = [albumPicker getSelectedIndexInComponent:0];
    NSDictionary *albumDict = [albumArray objectAtIndex:row];
    self.albumID = [albumDict objectForKey:ALBUM_ID_KEY];
    [self resignAllResponders];
}

# pragma mark
# pragma UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (NSArray *)getAlbumNames
{
    NSMutableArray *albumNames = nil;
    if ([albumArray count])
    {
        DLog(@"%@",[albumArray description]);
        albumNames = [NSMutableArray array];
        for (NSDictionary *dict in albumArray) {
            [albumNames addObject:[dict objectForKey:ALBUM_NAME_KEY]];
        }
    }
    return albumNames;
}


- (BOOL)isCompletelyFilled
{
    BOOL isCompletelyFilled = YES;
    NSString *message = nil;
    if ([txtAlbum.text isEmptyString] || [self.albumID isEmptyString]) {
        isCompletelyFilled = NO;
        message = @"Please select a album";
    }
    if (message)
    {
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Save Image" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        RELEASE_SAFELY(alert);
    }
    return isCompletelyFilled;
}

# pragma mark - Request Wrraper Delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    isUploading = NO;
    [loadingActivityIndicator removeFromSuperview];
    DLog(@"%@",response);
    if (uploadImageRequest)
    {
        [uploadImageRequest setDelegate:nil];
        RELEASE_SAFELY(uploadImageRequest);
    }
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] count]>0 && [[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_UPLOAD_IMAGE])
    {
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            BlackAlertView *alert = [[[BlackAlertView alloc]initWithTitle:@"Save Image" message:@"Image uploaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
            NSString *imgID = [[jsonDict objectForKey:@"data"] objectForKey:@"imageid"];
            [self saveImageToDB:imgID];
            [parentController gotoPreviousViewController];
        }
        
    }
    else {
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        BlackAlertView *alert = [[[BlackAlertView alloc]initWithTitle:@"Save Image" message:@"Image uploader had some problems with server connection. Please visit your profile to see if your image is posted successfully or not, to avoid dupliction of image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        [parentController gotoPreviousViewController];
        
    }

    
}

- (void)resignAllResponders
{
    [txtAlbum resignFirstResponder];
    [txtCaption resignFirstResponder];
    [txtLocation resignFirstResponder];
}

- (void)saveImageToDB:(NSString *)imageID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:imageID forKey:PICTURE_ID_KEY];
    [dict setObject:[NSData dataFromBase64String:[Utility stringFromImage:image limit:1500000]] forKey:PICTURE_IMAGE_KEY];
    if (albumID)
        [dict setObject:albumID forKey:ALBUM_ID_KEY];
    [dict setObject:[Utility userID] forKey:PROFILE_USER_ID_KEY];
    [dict setObject:txtCaption.text forKey:PICTURE_CAPTION_KEY];
    [dict setObject:[Utility getImageURL:imageID] forKey:PICTURE_IMAGE_URL_KEY];
    if (![txtLocation.text isEmptyString])
    {
        NSString *location = [txtLocation.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
        [dict setObject:location forKey:PICTURE_LOCATION_KEY];
    }
    [[DAL sharedInstance] createImageWithParams:dict];
    RELEASE_SAFELY(dict);
}



- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createAlbums
{
    [Utility createAlbum:[Utility userID]];
    if (albumArray)
        RELEASE_SAFELY(albumArray);
    albumArray = [[[DAL sharedInstance]getAllAlbumNamesAndID:[Utility userID]] retain];
}

#pragma mark
#pragma LocaionPicker fnctions

- (IBAction)showLocationPicker:(id)sender 
{
    if (shouldAddLocation)
    {
        [locationPicker showActionSheetWithSelectedRow:selectedLocation];
    }   
    else {
        txtLocation.text = @"";
        [btnAddLoc setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btnAddLoc setImage:[UIImage imageNamed:@"add"] forState:UIControlStateHighlighted];
        shouldAddLocation = YES;
    }
}

- (void)stateDidSelect
{
    selectedLocation = [locationPicker getSelectedIndexInComponent:0];
    countiesArray = [Utility getAllCountiesListOfState:[stateArray objectAtIndex:selectedLocation]];
    [locationPicker setItems:countiesArray inComponent:1];
}

- (void)locationPickerDismissed
{
    selectedLocation = [locationPicker getSelectedIndexInComponent:0];
    [txtLocation setText:[NSString stringWithFormat:@"%@,%@",[locationPicker getSelectedItemInComponent:1],[locationPicker getSelectedItemInComponent:0]]];
    [btnAddLoc setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [btnAddLoc setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateHighlighted];
    shouldAddLocation = NO;
}




@end
