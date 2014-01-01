//
//  CreateChlng1ViewController.m
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import "FJSwitch.h"
#import "CreateChlng1ViewController.h"
#import "CrateDscrStep2ViewController.h"
#import "GCPlaceholderTextView.h"
#import "UIImageView+WebCache.h"

@implementation CreateChlng1ViewController
@synthesize txtFieldChanlangeName;
@synthesize txtViewTags;
@synthesize lblLocation;
@synthesize btnLocation;
@synthesize mutArrDraftChallenge;
@synthesize buttonIndex;

UIImagePickerController *imgController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (FJSwitch *) createFJSwitch:(UIImage *)switchImage frame:(CGRect)frame onWidth:(CGFloat)onWidth offWidth:(CGFloat)offWidth {
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

-(IBAction)switchValueChanged:(id)sender
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
    // Create swith for location
    
    UIImage *switchImage = [UIImage imageNamed:@"switch"];
    
    [self createFJSwitch:switchImage frame:CGRectMake(47, 216, 64, 27) onWidth:35 offWidth:35];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //All #Tags and search #tags array
    
    mutArrAllTags           = [[NSMutableArray alloc]init];
    mutArrSearchedTAgs      = [[NSMutableArray alloc]init];
    mutArrEventTagResponse  = [[NSMutableArray alloc]init];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,100.0,60.0)];
    backImg.userInteractionEnabled = YES;
    backImg.image = [UIImage imageNamed:@"popoverImage.png"];
    
    popOverViewHasTags = [[UIView alloc]initWithFrame:CGRectMake(90.0,66.0,100.0,60.0)];
    popOverViewHasTags.userInteractionEnabled = YES;
    
    // Table View for show followers for mention suggetion in comment
    tblViewHashTags = [[UITableView alloc]initWithFrame:CGRectMake(2.0,2.0,96.0,50.0)];
    tblViewHashTags.layer.cornerRadius = 4.0;
    
    [popOverViewHasTags addSubview:backImg];
    [backImg addSubview:tblViewHashTags];
    [self.view addSubview:popOverViewHasTags];
    popOverViewHasTags.hidden = YES;
    
    tblViewHashTags.delegate = self;
    tblViewHashTags.dataSource = self;
    
    lblLocation.font  = [UIFont fontWithName:@"DynoBold" size:12];
    lblTextCount.font = [UIFont fontWithName:@"DynoBold" size:12];
    txtViewTags.font = [UIFont fontWithName:@"DynoRegular" size:14];
    txtFieldChanlangeName.font = [UIFont fontWithName:@"DynoRegular" size:14];
    
    [self.txtViewTags setPlaceholderColor:[UIColor lightGrayColor]];
    [self.txtViewTags setPlaceholder:@"Use #hashtags in your description so other users can find your challenge"];
    // Do any additional setup after loading the view from its nib.
    
    objCreateChallengeModel = [[CreateChaalengeModel alloc]init];
    
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
    
    //Location Button;
    btnLocation.tag=0;
    
    [self getAllHashTags];
    
    // Check whether coming from draft or not
    
    if(self.mutArrDraftChallenge != nil){
        
        txtFieldChanlangeName.text = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"challengeName"];
        lblLocation.text           = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"locationName"];
        txtViewTags.text           = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"tags"];
        PFFile *imageFile          = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"teaserfile"];
        
        // Check whether teaser is Video or Image
        if ([[imageFile url] rangeOfString:@".mov"].location == NSNotFound && [[imageFile url] rangeOfString:@".mp4"].location == NSNotFound){
            
            //Teaser is an Image
            btnTeaser.imageView.image = [UIImage imageNamed:@"noImage.png"];
            
            selectedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]]];
                        
            [btnTeaser setImage:selectedImage forState:UIControlStateNormal];
            [btnTeaser setImage:selectedImage forState:UIControlStateHighlighted];
            
        }else{
            
            PFFile *fileThumbImage = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"VideoThumbImage"];
            
            thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[fileThumbImage url]]]];
            
            vedioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]];
            
            [btnTeaser setImage:thumbnail forState:UIControlStateNormal];
            [btnTeaser setImage:thumbnail forState:UIControlStateHighlighted];
        }
        
        if([[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"location"] != nil){
            PFGeoPoint *points = [[self.mutArrDraftChallenge objectAtIndex:buttonIndex] objectForKey:@"location"];
            objCreateChallengeModel.strLatitude = [NSString stringWithFormat:@"%f",[points latitude]];
            objCreateChallengeModel.strLongitude = [NSString stringWithFormat:@"%f",[points longitude]];
        }
    }
}

-(void)viewDidUnload{
    
    [self setTxtFieldChanlangeName:nil];
    [self setTxtViewTags:nil];
    [self setBtnLocation:nil];
    [self setLblLocation:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Button actions

- (IBAction)btnAddTeaserPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Teaser"
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

#pragma Mark locatio switch value change

-(IBAction)locationSwitchValueChange:(id)sender{

    UISwitch *switchButton = (UISwitch *)sender; 
    if(switchButton.on == YES){
        AddLocationView *addLocationVC = [[AddLocationView alloc]initWithNibName:@"AddLocationView" bundle:nil];
        addLocationVC.delegate = self;
        addLocationVC.title=@"Add a location";
        
        [self.navigationController pushViewController:addLocationVC animated:YES];
    }else{
        lblLocation.text=@"Add a location";
    }
}

- (IBAction)btnNextPressed:(id)sender{
    
    if([self validationForCreateChallenge]){
        
        objCreateChallengeModel.strChallengeName      = txtFieldChanlangeName.text;
        objCreateChallengeModel.strChallengeTags      = txtViewTags.text;
        objCreateChallengeModel.thumbNail = thumbnail;
        // Array for keep the hash tags used in the challenge
        NSMutableArray *mutArrhashTagsForChallenge = [[NSMutableArray alloc]init];
        [mutArrhashTagsForChallenge removeAllObjects];
        NSString * aString = txtViewTags.text;
        NSScanner *scanner = [NSScanner scannerWithString:aString];
        [scanner scanUpToString:@"#" intoString:nil]; // Scan all characters before #
        while(![scanner isAtEnd]){
            NSString *substring = nil;
            [scanner scanString:@"#" intoString:nil]; // Scan the # character
            if([scanner scanUpToString:@" " intoString:&substring]) {
                if([mutArrhashTagsForChallenge containsObject:substring]){
                    
                }else{
                    [mutArrhashTagsForChallenge addObject:substring];
                }
                // Check wheateher follower arr have the name
            }
            [scanner scanUpToString:@"#" intoString:nil]; // Scan all characters before next #
        }
        
        objCreateChallengeModel.mutArrChallengeHashTags = [mutArrhashTagsForChallenge copy];
        
        if([lblLocation.text isEqualToString:@"Add a location"]){
            // No location selected by the user
        }else{
            objCreateChallengeModel.strChallengeLocation  = lblLocation.text;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(640,960));
        [selectedImage drawInRect: CGRectMake(0,0,640,960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();   
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        if (!vedioData){
            objCreateChallengeModel.teaserDataImage = [imageData mutableCopy];
        }
        else{
            objCreateChallengeModel.teaserDataVideo = [vedioData mutableCopy];
        }
        
        CrateDscrStep2ViewController *createDscr2VC = [[CrateDscrStep2ViewController alloc]initWithNibName:@"CrateDscrStep2ViewController" bundle:nil];
        createDscr2VC.title = @"Step 2";
        
        // Pass the draft pfobject to next view to delete it from draft table 
        if(self.mutArrDraftChallenge != nil){
            createDscr2VC.PFObjDraftChallenge = [self.mutArrDraftChallenge objectAtIndex:buttonIndex];
        }
        
        createDscr2VC.objCreateChallengeModel = objCreateChallengeModel;
        [self.navigationController pushViewController:createDscr2VC animated:YES];
    }else{
        // Blank field validation hanleded in the validationForCreateChallenge methods
    }
    
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark- textview Delegate method

//TextView Delegate Method
-(void)textViewDidBeginEditing:(UITextView *)textView{
}

-(void)textViewDidEndEditing:(UITextView *)textView{
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
   
    if(newLength < 160){
        
        // Set charactor counter for description
        
        lblTextCount.text = [NSString stringWithFormat:@"%d/160",newLength];
        
        if ([text isEqualToString:@"\n"]){
            [textView resignFirstResponder];
            return NO;
        }else{
            
            NSString *strSearchText = [textView.text stringByAppendingFormat:@"%@",text];
            
            if([textView.text length] == 1 && [strSearchText length] == 1){
                popOverViewHasTags.hidden = YES;
                return YES;
            }
            
            if([strSearchText rangeOfString:@"#"].location == NSNotFound){
                // String does not contain # symbol
                
            }else{
                popOverViewHasTags.hidden = YES;
                
                NSRange rangNew = [strSearchText rangeOfString: @"#"];
                
                NSString *strAfterSearchSymbol = [strSearchText substringFromIndex:rangNew.location];
                
                if([strAfterSearchSymbol isEqualToString:@"#"]){
                    // We got the first # in our comment string
                }else{
                    if ([mutArrAllTags count] > 0){
                        [mutArrSearchedTAgs removeAllObjects];
                        
                        NSArray *arrCommentString = [strAfterSearchSymbol componentsSeparatedByString:@"#"];
                        
                        strAfterSearchSymbol = [arrCommentString lastObject];
                        
                        for(NSString *strHashTag in mutArrAllTags){
                            
                            NSString *strS;
                            strS = [[NSString alloc]initWithString:strHashTag];
                            
                            NSRange range = [[strS lowercaseString] rangeOfString:[strAfterSearchSymbol lowercaseString]];
                            
                            if(range.location != NSNotFound){
                                if(range.location == 1){
                                    
                                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                                    [dict setObject:strS forKey:@"name"];
                                    [mutArrSearchedTAgs addObject:dict];
                                }
                            }else{
                                popOverViewHasTags.hidden = YES;
                                [tblViewHashTags reloadData];
                            }
                        }
                        if([mutArrSearchedTAgs count] > 0){
                            popOverViewHasTags.hidden = NO;
                            [tblViewHashTags reloadData];
                        }
                    }
                }
            }
            
        }
        
    }else{
        [textView resignFirstResponder];
        
        if(newLength > 162){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"You have exceded the maximum character limit. Please keep you description in 160 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark UIimage Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [btnTeaser setImage:selectedImage forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if ([mediaType isEqualToString:@"public.movie"]){
         
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        vedioData = [NSData dataWithContentsOfURL:videoURL];
        
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [btnTeaser setImage:thumbnail forState:UIControlStateNormal];
        
        //[self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ActionSheet Delegate
//Action sheet for Image Capturing
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex1 {
    //For Camera
    if (buttonIndex1 == 0)
    {
        
        BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        
        // If there is a camera, then display the world throught the viewfinder
        if(camera)
        {
            imgController = [[UIImagePickerController alloc] init];
            imgController.allowsEditing = YES;
            imgController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imgController.delegate=self;
            imgController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",@"public.image", nil];
            imgController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //[self presentModalViewController:imgController animated:YES];
            
            [self presentViewController:imgController animated:TRUE completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag=111;
            [alert show];

        }

    }
    //For Library
    else if (buttonIndex1 == 1)
    {

        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        imgPicker.allowsEditing = YES;
        imgPicker.videoMaximumDuration = 6.0;
        
       // [self presentModalViewController:imgPicker animated:YES];
        
        [self presentViewController:imgPicker animated:TRUE completion:nil];
    }
    else if(buttonIndex1==2){
      //  selectedImage=nil;
      //  [btnTeaser setImage:selectedImage forState:UIControlStateNormal];
    }
}

#pragma mark Upload image and vedio

-(void)uploadImageOnServer
{
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [selectedImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    if (!vedioData) {
        [self uploadImage:imageData];
    }
    else
    {
        [self uploadImage:vedioData];
    }
    
}

- (void)uploadImage:(NSData *)imageData
{
    // Save PFFile
    if (!vedioData) {
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //Hide determinate HUD
                
                [activitie setObject:imageFile forKey:@"userPhotoAndVedio"];
                [activitie save];
                [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                        CrateDscrStep2ViewController *createDscr2VC=[[CrateDscrStep2ViewController alloc]initWithNibName:@"CrateDscrStep2ViewController" bundle:nil];
                        createDscr2VC.title=@"Step 2";
                        [self.navigationController pushViewController:createDscr2VC animated:YES];
                    }
                    else{
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    
                    }
                }];
            }
            
        } ];
    }
    
    else
    {
        PFFile *vediofile = [PFFile fileWithName:@"vedio.mp4" data:imageData];
        [vediofile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //Hide determinate HUD
                
                [activitie setObject:vediofile forKey:@"userPhotoAndVedio"];
                [activitie save];
                [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                        CrateDscrStep2ViewController *createDscr2VC=[[CrateDscrStep2ViewController alloc]initWithNibName:@"CrateDscrStep2ViewController" bundle:nil];
                        createDscr2VC.title=@"Step 2";
                        [self.navigationController pushViewController:createDscr2VC animated:YES];
                    }
                    else{
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    }
                }];
            }
            
        }];
    }

    
}
#pragma Mark Validation Method For Create Challenge 

-(BOOL)validationForCreateChallenge{
    
    if ([[txtFieldChanlangeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter challenge name.")       
        return NO;
    }else if([[txtViewTags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter tag for challenge.")
        return NO;
    }else if (btnTeaser.currentImage==Nil){
        DisplayAlertWithTitle(@"FitTag", @"Please select teaser")
        return NO;
    }else if(1){
        
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

#pragma Mark AddLocation Delegate methods

-(void)addLocationInPrevioseView:(NSMutableDictionary *)dictLocationInfo{
   
    lblLocation.text = [self removeNull:[NSString stringWithFormat:@"%@,%@",[dictLocationInfo objectForKey:@"name"],[self removeNull:[[dictLocationInfo objectForKey:@"location"] objectForKey:@"city"]]]];
    
    if([[lblLocation.text substringFromIndex:[lblLocation.text length]-1] isEqualToString:@","]){
        lblLocation.text = [lblLocation.text substringToIndex:[lblLocation.text length]-1];
    }else{
        // Don't get comma at the last of string
    }
    
    NSDictionary *dictLatLong = [dictLocationInfo objectForKey:@"location"];
    
    objCreateChallengeModel.strLatitude = [dictLatLong objectForKey:@"lat"];
    objCreateChallengeModel.strLongitude = [dictLatLong objectForKey:@"lng"];
}

#pragma mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mutArrSearchedTAgs count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"DynoRegular" size:14];
    cell.textLabel.text = [[mutArrSearchedTAgs objectAtIndex:indexPath.row]objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arrTxtFieldComment = [[txtViewTags.text componentsSeparatedByString:@"#"] mutableCopy];
    
    [arrTxtFieldComment replaceObjectAtIndex:[arrTxtFieldComment count]-1 withObject:[  [[mutArrSearchedTAgs objectAtIndex:indexPath.row]objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    
    txtViewTags.text = [arrTxtFieldComment componentsJoinedByString:@"#"];
}

#pragma mark Get all Hash Tags

-(void)getAllHashTags{
    @try {
        PFQuery *query = [PFQuery queryWithClassName:@"tblEventTag"];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                PFQuery *postQuery = [PFQuery queryWithClassName:@"tblEventTag"];
                [postQuery includeKey:@"userId"];
                [postQuery setLimit:count];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error){
                        mutArrEventTagResponse = [objects mutableCopy];
                        
                        //Save results and update the table
                        for(int i = 0; i < [mutArrEventTagResponse count];i++){
                            PFObject *pfAllTags = [mutArrEventTagResponse objectAtIndex:i];
                            
                            NSArray *arrTagTitle = [[pfAllTags objectForKey:@"tagTitle"] componentsSeparatedByString:@" "];
                            // Keep the uniqe value in the tag array
                            for (int j = 0; j < [arrTagTitle count]; j++){
                                if([mutArrAllTags containsObject:[[arrTagTitle objectAtIndex:j]lowercaseString]]){
                                    // Do not add the string if already exist
                                }else{
                                    if([[[arrTagTitle objectAtIndex:j]lowercaseString] length]>0)
                                        [mutArrAllTags addObject:[[arrTagTitle objectAtIndex:j]lowercaseString]];
                                }
                            }
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                }];
            } else {
                
            }
        }];
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark rotate Image

-(UIImage *)scaleAndRotateImage:(UIImage *)image{
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),
                                  CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform =
            CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform =
            CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0,
                                                                 width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
