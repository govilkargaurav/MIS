//
//  EditProfileViewController.m
//  FitTag
//
//  Created by apple on 3/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import "FJSwitch.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditProfileViewController
@synthesize txtfieldUserName;
@synthesize txtViewBiography;

@synthesize txtFiledWebsit;
@synthesize btnProfileImage;
@synthesize selectedImage;
@synthesize lblLocation;
@synthesize switchLocation;
@synthesize strLat,strLongi,strLocationName;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

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

#pragma mark switch methods

-(FJSwitch *) createFJSwitch:(UIImage *)switchImage frame:(CGRect)frame onWidth:(CGFloat)onWidth offWidth:(CGFloat)offWidth {
    FJSwitch *fjSwitch = [[FJSwitch alloc] initWithImage:switchImage
                                                   frame:frame
                                                 onWidth:onWidth
                                                offWidth:offWidth];
    [fjSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    fjSwitch.layer.cornerRadius = 4.0;
    fjSwitch.layer.masksToBounds = YES;
    [fjSwitch setOn:NO animated:NO];
    [self.view addSubview:fjSwitch];
    
    return fjSwitch;
}

- (IBAction)switchValueChanged:(id)sender
{
    FJSwitch *fjSwitch = (FJSwitch *)sender;
    if(fjSwitch.isOn){
        [self performSelector:@selector(pushToAddLocationView) withObject:nil afterDelay:0.5];
    }else{
        lblLocation.text = @"Add a location";
    }
}

-(void)pushToAddLocationView{
    
    AddLocationView *addLocationVC = [[AddLocationView alloc]initWithNibName:@"AddLocationView" bundle:nil];
    addLocationVC.delegate = self;
    addLocationVC.title = @"Add a location";
    [self.navigationController pushViewController:addLocationVC animated:YES];
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    
    [super viewDidLoad];

    // Custom swith for add location
    UIImage *switchImage = [UIImage imageNamed:@"switch"];
    [self createFJSwitch:switchImage frame:CGRectMake(46,120,64,27) onWidth:35 offWidth:35];
        
    // Do any additional setup after loading the view from its nib.
    [self.txtViewBiography setPlaceholderColor:[UIColor lightGrayColor]];
    [self.txtViewBiography setTextColor:[UIColor blackColor]];
    [self.txtViewBiography setPlaceholder:@"Short biography limit 160 charatcters"];
    [self loadCurrentUserDetail];
    
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

    //Done Button
    
    UIButton *btnBarSave=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBarSave addTarget:self action:@selector(btnSavePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnBarSave setFrame:CGRectMake(0, 0, 52, 30)];
    [btnBarSave setImage:[UIImage imageNamed:@"btnSmallDone"] forState:UIControlStateNormal];
    [btnBarSave setImage: [UIImage imageNamed:@"btnSmallDoneSel"] forState:UIControlStateHighlighted];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52, 30)];
    [view addSubview:btnBarSave];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-11;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];

    strLocationName=nil;
    
    txtfieldUserName.font = [UIFont fontWithName:@"DynoRegular" size:14];
    txtFiledWebsit.font = [UIFont fontWithName:@"DynoRegular" size:14];
    txtViewBiography.font = [UIFont fontWithName:@"DynoRegular" size:14];
    lblLocation.font = [UIFont fontWithName:@"DynoBold" size:12];
}

- (void)viewDidUnload{
    
    [self setTxtfieldUserName:nil];
    [self setTxtViewBiography:nil];
    [self setTxtFiledWebsit:nil];
    [self setBtnProfileImage:nil];
    [self setBtnProfileImage:nil];
    [self setLblLocation:nil];
    [self setSwitchLocation:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Button Action Methods
- (IBAction)btnProfileImagePressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Image"delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Camera"];
    [actionSheet addButtonWithTitle:@"Gallery"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.destructiveButtonIndex = 2;
    [actionSheet showInView:self.view.window];

}

-(IBAction)btnSavePressed:(id)sender{
    [txtfieldUserName resignFirstResponder];
    [txtFiledWebsit resignFirstResponder];
    [txtViewBiography resignFirstResponder];
    if([self validation]){
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading...";
        
        PFUser *user=[PFUser currentUser];
        [user setObject:[[txtfieldUserName text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"username"];
        [user setObject:[txtViewBiography text] forKey:@"BIO"];
        [user setObject:[txtFiledWebsit text] forKey:@"webSite"];
        if(strLocationName!=nil){
            
            [user setObject:strLocationName forKey:@"locationName"];
            
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[strLat doubleValue] longitude:[strLongi doubleValue]];

            if(point != nil){
                [user setObject:point forKey:@"location"];
            }
        }
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                
                if(selectedImage!=nil)
                    [self convertImageToData];
                [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                [self btnHeaderbackPressed:nil];
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                
                DisplayAlertWithTitle(@"FitTag",[[error userInfo] objectForKey:@"error"])
            }
        }];
    }
}
#pragma mark-Own methods;
-(void)loadCurrentUserDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            [txtfieldUserName setText:[[PFUser currentUser]objectForKey:@"username" ]];
            //Get userProfile Image
            PFFile *uesrProfileImage = [[PFUser currentUser] objectForKey:@"userPhoto"];
            [btnProfileImage setImageURL:[NSURL URLWithString:[uesrProfileImage url]]];
            
            [txtViewBiography setText:[[PFUser currentUser]objectForKey:@"BIO" ]];
            [txtFiledWebsit setText:[[PFUser currentUser]objectForKey:@"webSite" ]];
            strLocationName = [[PFUser currentUser]objectForKey:@"locationName"];
            if(strLocationName != nil){
                [lblLocation setText:[[PFUser currentUser]objectForKey:@"locationName"]];
                [switchLocation setOn:YES];
                PFGeoPoint *point = [[PFUser currentUser]objectForKey:@"location"];
                strLat = [NSString stringWithFormat:@"%f",[point latitude]];
                strLongi = [NSString stringWithFormat:@"%f",[point longitude]];
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark- textview Delegate method

//TextView Delegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(newLength <160){
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }else{
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==txtFiledWebsit) {
        [txtFiledWebsit resignFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==txtFiledWebsit){
        CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat midline = textFieldRect.origin.y + 1.0  *textFieldRect.size.height;
        CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
        CGFloat heightFraction = numerator / denominator;
        animatedDistance = floor(162.0 * heightFraction);
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
    if(textField==txtFiledWebsit){
        if([txtFiledWebsit.text length]==0){
            txtFiledWebsit.text=@"http://";
        }

    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField==txtFiledWebsit){
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        if([txtFiledWebsit.text isEqualToString:@"http://"]){
            txtFiledWebsit.text=@"";
        }
    }
}

#pragma Mark locatio switch value change

-(void)locationSwitchValueChange:(id)sender{
    
    UISwitch *switchButton = (UISwitch *)sender; 
    if(switchButton.on == YES){
        AddLocationView *addLocationVC = [[AddLocationView alloc]initWithNibName:@"AddLocationView" bundle:nil];
        addLocationVC.delegate = self;
        addLocationVC.title = @"Add a Location";
        strLocationName=nil;
        [self.navigationController pushViewController:addLocationVC animated:YES];
    }else{
        lblLocation.text=@"Add a Location";
        strLocationName=nil;
    }
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Mark AddLocation Delegate methods

-(void)addLocationInPrevioseView:(NSMutableDictionary *)dictLocationInfo{
    lblLocation.text = [dictLocationInfo objectForKey:@"name"];
    NSDictionary *dictLatLong = [dictLocationInfo objectForKey:@"location"];

    strLocationName=[dictLocationInfo objectForKey:@"name"];
    strLat=[dictLatLong objectForKey:@"lat"];
    strLongi=[dictLatLong objectForKey:@"lng"];
}

#pragma mark ActionSheet Delegate
//Action sheet for Image Capturing

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //For Camera
    if (buttonIndex == 0)
    {
        BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        
        // If there is a camera, then display the world throught the viewfinder
        if(camera)
        { 
            UIImagePickerController  *imgController = [[UIImagePickerController alloc] init];
            imgController.allowsEditing = YES;
            imgController.sourceType =  UIImagePickerControllerSourceTypeCamera;   
            imgController.delegate=self;
           // [self presentModalViewController:imgController animated:YES];
            
            [self presentViewController:imgController animated:TRUE completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    //For Library
    else if (buttonIndex == 1)
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
       // [self presentModalViewController:imagePicker animated:YES];
        
        [self presentViewController:imagePicker animated:TRUE completion:nil];
    }
    else if(buttonIndex==2){
       // [self.btnProfileImage setImage:selectedImage forState:UIControlStateNormal];
    }
}

#pragma mark - ImagePicker Delegate

//Tells the delegate that the user cancelled the pick operation.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Tells the delegate that the user picked an image. (Deprecated in iOS 3.0. Use imagePickerController:didFinishPickingMediaWithInfo: instead.)

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    selectedImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [btnProfileImage setImage:selectedImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Upload profile image on server
-(void)convertImageToData{
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [selectedImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    [self uploadImage:imageData];
}


-(void)uploadImage:(NSData *)imageData{
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            [user setObject:imageFile forKey:@"userPhoto"];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                }
                else{
                    
                }
            }];
        }
    }];
}

#pragma Mark Check valid URL

-(BOOL)validateUrl: (NSString  *)candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

-(bool)validation{
    
    NSRange range = [[txtfieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] rangeOfString:@" "];
    
    if(range.length > 0){
        DisplayAlertWithTitle(@"FitTag", @"Space is not allowed in username.")
        return NO;
        
    }else if([[txtfieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag", @"Please enter username.")
        return NO;
    
    }else if([[txtViewBiography.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag", @"Please enter Biography.")
        return NO;
    }else if([txtFiledWebsit.text length]>0){
        if(![self validateUrl:txtFiledWebsit.text]){
            DisplayAlertWithTitle(@"FitTag", @"Please enter a valid URL in format \n http://www.yourwebsite.com")
            return NO;
        }
    }else{
        return YES;
    }
    return YES; 
}
@end
