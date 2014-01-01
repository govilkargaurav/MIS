//
//  EditProfileViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#define AlertTagAvatar 999

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize scrollView;
@synthesize txtEmail;
@synthesize txtName;
@synthesize txtPassword;
@synthesize txtBio;
@synthesize txtPreference;
@synthesize txtPhone;
@synthesize avatar;
@synthesize lblEmail;
@synthesize userProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imagePickerOpened = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [scrollView setContentSize:CGSizeMake(320, 367)];
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Edit Profile"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    
    [self.navigationItem setHidesBackButton:YES];
    
    prefPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"Select Preference" targetViewController:self doneAction:@selector(prefSelected) pickerDidSelectAction:nil];
    prefArray = [[NSArray alloc] initWithObjects:@"BigGame",@"SmallGame",@"FreshWater",@"SaltWater",@"Exotic",@"Others", nil];
    [prefPicker setItems:prefArray inComponent:0];
    [txtPreference setInputView:prefPicker];
    [avatar.imageView getWhiteBorderImage];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveProfile)] autorelease];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
    [self.navigationController.navigationBar addSubview:titleView];
    if (!imagePickerOpened)
    {
        if (userProfile)
            RELEASE_SAFELY(userProfile);
        userProfile = [[[DAL sharedInstance] getProfileByID:[[NSUserDefaults standardUserDefaults]objectForKey:PROFILE_USER_ID_KEY]] retain];
        if (userProfile)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [txtEmail setText:userProfile.email];
            [txtBio setText:userProfile.bio];
            [txtName setText:userProfile.name];
            [txtPassword setText:@"******"];
            [txtPhone setText:userProfile.phone];
            if ([txtPhone.text length]==10)
            {
                NSString *areaCode = [txtPhone.text substringToIndex:3];
                NSString *remCode = [txtPhone.text substringFromIndex:3];
                NSString *subAreaCode = [remCode substringToIndex:3];
                NSString *remNum = [remCode substringFromIndex:3];
                txtPhone.text = [NSString stringWithFormat:@"(%@)%@-%@",areaCode,subAreaCode,remNum];
                
            }
            [txtPreference setText:userProfile.preference];
            if ([userProfile.picture length]>0)
            {
                UIImage *image = [UIImage imageWithData:userProfile.picture];
                [avatar setImage:image forState:UIControlStateNormal];
                [avatar setImage:image forState:UIControlStateSelected];
            }
            else {
                UIImage *image = [UIImage imageNamed:@"avatar.png"];
                [avatar setImage:image forState:UIControlStateNormal];
                [avatar setImage:image forState:UIControlStateSelected];
            }
            if ([userProfile.account_type integerValue]>0)
            {
                lblEmail.text = @"ID";
                [txtPassword setUserInteractionEnabled:NO];
                [txtEmail setUserInteractionEnabled:NO];
            }
            else {
                lblEmail.text = @"Email";
                [txtPassword setUserInteractionEnabled:YES];
                [txtEmail setUserInteractionEnabled:YES];
            }   
        }
        else {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSaveProfile) name:NOTIFICATION_PROFILE_SAVED object:nil];
            [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        }
    }
    imagePickerOpened = NO;

}

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setTxtName:nil];
    [self setTxtPassword:nil];
    [self setTxtBio:nil];
    [self setTxtPreference:nil];
    [self setTxtPhone:nil];
    [self setAvatar:nil];
    [self setScrollView:nil];
    [self setLblEmail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    RELEASE_SAFELY(profileImage);
    if (updateProfileRequest)
    {
        [updateProfileRequest setDelegate:nil];
        RELEASE_SAFELY(updateProfileRequest);
    }
    RELEASE_SAFELY(userProfile);
    RELEASE_SAFELY(prefPicker);
    RELEASE_SAFELY(prefArray);
    RELEASE_SAFELY(titleView);
    [txtEmail release];
    [txtName release];
    [txtPassword release];
    [txtBio release];
    [txtPreference release];
    [txtPhone release];
    [avatar release];
    [scrollView release];
    [lblEmail release];
    [super dealloc];
}
- (IBAction)disappearKeyboard:(id)sender 
{
    [txtBio resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtPreference resignFirstResponder];
}

- (IBAction)selectPhoto:(id)sender 
{
    [self disappearKeyboard:nil];
    BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Select Avatar" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo",@"Library", nil];
    [alert setTag:AlertTagAvatar];
    [alert show];
    RELEASE_SAFELY(alert);
}

#pragma mark 
#pragma text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(320, 520)];
    [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(320, 367)];
    if (textField == txtPhone)
    {
        if ([txtPhone.text length]==10)
        {
            NSString *areaCode = [txtPhone.text substringToIndex:3];
            NSString *remCode = [txtPhone.text substringFromIndex:3];
            NSString *subAreaCode = [remCode substringToIndex:3];
            NSString *remNum = [remCode substringFromIndex:3];
            txtPhone.text = [NSString stringWithFormat:@"(%@)%@-%@",areaCode,subAreaCode,remNum];

        }
    }
}


- (void)saveProfile
{
    [self disappearKeyboard:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"ORIGINAL_AVTAR"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@"1323" forKey:@"ORIGINAL_AVTAR221"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@"55" forKey:@"ORIGINAL_AVTAR12"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving..."];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:txtBio.text forKey:KWEB_SERVICE_BIO];
    [dict setObject:txtEmail.text forKey:KWEB_SERVICE_EMAIL];
    [dict setObject:txtName.text forKey:KWEB_SERVICE_NAME];
    if (![txtPassword.text isEqualToString:@"******"] && [userProfile.account_type intValue]==AccountTypeNormal)
        [dict setObject:txtPassword.text forKey:KWEB_SERVICE_PASSKEY];
    [dict setObject:txtPhone.text forKey:KWEB_SERVICE_PHONE];
    [dict setObject:txtPreference.text forKey:KWEB_SERVICE_PREFERENCE];
    
    if (profileImage){
        [dict setObject:[Utility stringFromImage:profileImage limit:500000] forKey:KWEB_SERVICE_AVATAR];
        [dict setObject:[NSString base64StringFromData:UIImagePNGRepresentation(profileImage)] forKey:KWEB_SERVICE_AVATARBIG];
    }
    
    if (updateProfileRequest)
    {
        [updateProfileRequest setDelegate:nil];
        RELEASE_SAFELY(updateProfileRequest);
    }
    updateProfileRequest = [[WebServices alloc]init];
    [updateProfileRequest setDelegate:self];
    [updateProfileRequest updateUserProfile:dict];
    RELEASE_SAFELY(dict);
}

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    [loadingActivityIndicator removeFromSuperview];
    if (updateProfileRequest)
    {
        [updateProfileRequest setDelegate:nil];
        RELEASE_SAFELY(updateProfileRequest);
    }
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if (jsonDict && [jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] count]>0)
    {
        if ([[jsonDict objectForKey:@"data"]objectForKey:@"success"])
        {
            BlackAlertView *alert = [[[BlackAlertView alloc]initWithTitle:@"Update Profile" message:@"Successfully updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
            if (profileImage)
            {
                RELEASE_SAFELY(profileImage);
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        }
    }
    else {
        [Utility showServerError];
    }
    
}


#pragma mark
#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == AlertTagAvatar)
    {
        imagePickerOpened = YES;
        if (buttonIndex == 1)
        {
            if([UIImagePickerController isSourceTypeAvailable:
                UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker= [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [picker setShowsCameraControls:YES];
                [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
        }
        else if (buttonIndex == 2)
        {
            if([UIImagePickerController isSourceTypeAvailable:
                UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker= [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
        }
    }
    
}


# pragma mark
#pragma uiImage Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:LOAD_PROFILE_IMAGE_FROM_SERVER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (profileImage)
        RELEASE_SAFELY(profileImage);
    profileImage = [[image fixOrientation] retain];
    
    [avatar setImage:image forState:UIControlStateNormal];
    [avatar setImage:image forState:UIControlStateSelected];
   	[picker dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)didSaveProfile
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (userProfile)
        RELEASE_SAFELY(userProfile);
    userProfile = [[[DAL sharedInstance] getProfileByID:[Utility userID]] retain];
    if (userProfile)
    {
        [txtEmail setText:userProfile.email];
        [txtBio setText:userProfile.bio];
        [txtName setText:userProfile.name];
        [txtPassword setText:@"******"];
        [txtPhone setText:userProfile.phone];
        if ([txtPhone.text length]==10)
        {
            NSString *areaCode = [txtPhone.text substringToIndex:3];
            NSString *remCode = [txtPhone.text substringFromIndex:3];
            NSString *subAreaCode = [remCode substringToIndex:3];
            NSString *remNum = [remCode substringFromIndex:3];
            txtPhone.text = [NSString stringWithFormat:@"(%@)%@-%@",areaCode,subAreaCode,remNum];
            
        }
        [txtPreference setText:userProfile.preference];
        if ([userProfile.picture length]>0)
        {
            UIImage *image = [UIImage imageWithData:userProfile.picture];
            [avatar setImage:image forState:UIControlStateNormal];
            [avatar setImage:image forState:UIControlStateSelected];
        }
        else {
            UIImage *image = [UIImage imageNamed:@"avatar.png"];
            [avatar setImage:image forState:UIControlStateNormal];
            [avatar setImage:image forState:UIControlStateSelected];
        }
        if ([userProfile.account_type integerValue]>0)
        {
            lblEmail.text = @"ID";
            [txtPassword setUserInteractionEnabled:NO];
        }
        else {
            lblEmail.text = @"Email";
            [txtPassword setUserInteractionEnabled:YES];
        }
    }

}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prefSelected
{
    txtPreference.text = [prefPicker getSelectedItemInComponent:0];
    [self disappearKeyboard:nil];
}

@end
