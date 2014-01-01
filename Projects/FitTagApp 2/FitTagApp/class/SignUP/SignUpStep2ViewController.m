//
//  SignUpStep2ViewController.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SignUpStep2ViewController.h"
#import "SignUp3FindFriendViewController.h"
#import "GCPlaceholderTextView.h"
#import "SignUpTagSelectViewController.h"

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

@implementation SignUpStep2ViewController
@synthesize txtWebSite;
@synthesize btnProfileImage;
@synthesize txtViewBio;
@synthesize selectedImage,lblText;
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

- (void)viewDidLoad
{
//    for(UIView* view in self.navigationController.navigationBar.subviews)
//    {
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            [view removeFromSuperview];
//        }
//        
//    }
//    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setBackgroundColor:[UIColor blackColor]];
//    
//    UILabel * nav_title = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 25)];
//    nav_title.font = [UIFont fontWithName:@"DynoBold" size:21];
//    nav_title.textColor = [UIColor whiteColor];
//    nav_title.textAlignment=UITextAlignmentCenter;
//    nav_title.adjustsFontSizeToFitWidth = YES;
//    nav_title.text = @"Step 2";
//    self.title = @"";
//    nav_title.backgroundColor = [UIColor clearColor];
//    [bar addSubview:nav_title];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.txtViewBio setPlaceholderColor:[UIColor lightGrayColor]];
    [self.txtViewBio setTextColor:[UIColor blackColor]];
    [self.txtViewBio setPlaceholder:@"Short biography limit 160 charatcters"];
//     self.txtViewBio.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"biotxtviewbg"]];
    
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
    
    [txtViewBio setFont:[UIFont fontWithName:@"DynoRegular" size:14]];

    [txtWebSite setFont:[UIFont fontWithName:@"DynoRegular" size:14]];

    [lblText setFont:[UIFont fontWithName:@"DynoRegular" size:14]];

    
}

- (void)viewDidUnload
{
    [self setBtnProfileImage:nil];
    [self setTxtViewBio:nil];
    [self setTxtWebSite:nil];
    [self setLblText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma Mark- Button Pressed Events
- (IBAction)btnProfileImagPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Image"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    [actionSheet addButtonWithTitle:@"Camera"];
    [actionSheet addButtonWithTitle:@"Gallery"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    
    actionSheet.destructiveButtonIndex = 2;

    [actionSheet showInView:self.view.window];
}

- (IBAction)btnSkipPressed:(id)sender {
//    SignUpTagSelectViewController *signupTagSelVC=[[SignUpTagSelectViewController alloc]initWithNibName:@"SignUpTagSelectViewController" bundle:nil];
//    signupTagSelVC.title=@"Step 3";
//    [self.navigationController pushViewController:signupTagSelVC animated:YES];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading...";
    
    PFUser *user=[PFUser currentUser];
    [user setObject:[txtViewBio text] forKey:@"BIO"];
    [user setObject:[txtWebSite text] forKey:@"webSite"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            [self convertImageToData];
            SignUpTagSelectViewController *signupTagSelVC=[[SignUpTagSelectViewController alloc]initWithNibName:@"SignUpTagSelectViewController" bundle:nil];
            signupTagSelVC.title=@"Step 3";
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            [self.navigationController pushViewController:signupTagSelVC animated:YES];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            
            DisplayAlertWithTitle(@"FitTag",[[error userInfo] objectForKey:@"error"])
        }
    }];
}

- (IBAction)btnSavePressed:(id)sender {
    if([self validation]){
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"Loading...";
            
            PFUser *user=[PFUser currentUser];
            [user setObject:[txtViewBio text] forKey:@"BIO"];
            [user setObject:[txtWebSite text] forKey:@"webSite"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (!error) {
                    [self convertImageToData];
                    SignUpTagSelectViewController *signupTagSelVC=[[SignUpTagSelectViewController alloc]initWithNibName:@"SignUpTagSelectViewController" bundle:nil];
                    signupTagSelVC.title=@"Step 3";
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    [self.navigationController pushViewController:signupTagSelVC animated:YES];
                    
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    
                    DisplayAlertWithTitle(@"FitTag",[[error userInfo] objectForKey:@"error"])
                }
            }];
        
    }
    
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
            //[self presentModalViewController:imgController animated:YES];
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
      //  [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:TRUE completion:nil];
    }
    else if(buttonIndex==2){
       // selectedImage=nil;
        
       // [self.btnProfileImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
    
} 

#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==txtWebSite) {
        [txtWebSite resignFirstResponder];
    }
    return NO;
}   
- (void)textFieldDidBeginEditing:(UITextField *)textField{
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
    
    if(textField==txtWebSite){
        if([txtWebSite.text length]==0){
            txtWebSite.text=@"http://";
        }
        
    
    }
    
    
} 
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    if(textField==txtWebSite){
        if([txtWebSite.text isEqualToString:@"http://"]){
            txtWebSite.text=@"";
        }
    
    
    }
}

#pragma mark- textview Delegate method

//TextView Delegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(newLength <160){
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
                       
            return NO; // or true, whetever you's like
            
        }
    }else{
        [textView resignFirstResponder];
          
    }
    return YES;
}
#pragma mark - ImagePicker Delegate

//Tells the delegate that the user cancelled the pick operation.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

//Tells the delegate that the user picked an image. (Deprecated in iOS 3.0. Use imagePickerController:didFinishPickingMediaWithInfo: instead.)

- (void) imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    selectedImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [btnProfileImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
    //[picker dismissModalViewControllerAnimated:TRUE];
    [picker dismissViewControllerAnimated:YES completion:nil];

    
}
#pragma mark Upload profile image on server
-(void)convertImageToData
{
    if (selectedImage==nil) {
        selectedImage=[UIImage imageNamed:@"noImage.png"];
    }
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [selectedImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    [self uploadImage:imageData];
}


- (void)uploadImage:(NSData *)imageData
{
   
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
        
    } ];
    

}

#pragma Mark Check valid URL

-(BOOL)validateUrl: (NSString  *)candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

-(bool)validation{
    if([[txtViewBio.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag", @"Please enter Biography.")
        return NO;
    }else if([txtWebSite.text length]>0){
            if(![self validateUrl:txtWebSite.text]){
                DisplayAlertWithTitle(@"FitTag", @"Please enter a valid URL in format \n http://www.yourwebsite.com")
                return NO;
            }
    }else{
        return YES;
    }
 return YES;
}
@end
