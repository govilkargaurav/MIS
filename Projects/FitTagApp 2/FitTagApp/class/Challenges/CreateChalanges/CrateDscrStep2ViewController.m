//
//  CrateDscrStep2ViewController.m
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CrateDscrStep2ViewController.h"
#import "ChlngFrndStep3ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMEdia.h>
#import "addEquipmentViewController.h"
#import "TimeLineViewController.h"
#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
CGFloat animatedDistance;

@implementation CrateDscrStep2ViewController
@synthesize btnImageFromLibrary;
@synthesize objCreateChallengeModel;
@synthesize PFObjDraftChallenge;
@synthesize inputToolbar;
UIImagePickerController *imgPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    textIndexInSteps = -1;
    isDraftChallenge = NO;
    
    appdelegateRefrence  = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    
    [txtViewAddText setPlaceholder:@"Write a description for this step..."];
    
    [tblViewChallengeStep bringSubviewToFront:imgDisplayView];
    
    //Make view corner radious as rounded
    imgDisplayView.layer.cornerRadius = 5;
    imgDisplayView.layer.masksToBounds = YES;
    
    imgDisplayView.layer.borderWidth = 3.0;
    imgDisplayView.layer.borderColor = [UIColor blackColor].CGColor;
    
    imgViewStep.layer.cornerRadius = 5;
    imgViewStep.layer.masksToBounds = YES;
    txtViewComment.layer.cornerRadius = 5;
    txtViewComment.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
    _arrayImageData = [[NSMutableArray alloc] init];
    mutArrChaalengeSteps = [[NSMutableArray alloc]init];
    clickedIndex = 0;
    addDeleteButtonAt = -1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(getChallengeDraftsImagesAndOtherData) withObject:nil];
    
    //navigation back Button- Arrow
    UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
}

-(void)getChallengeDraftsImagesAndOtherData{
    if(self.PFObjDraftChallenge != nil){
        
        NSMutableArray *mutArrStepsDraftImages = [[self.PFObjDraftChallenge objectForKey:@"myArray"] mutableCopy];
        
        NSMutableArray *mutArrdraftsDetail = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [mutArrStepsDraftImages count]; i++){
            NSDictionary *dictStep = [mutArrStepsDraftImages objectAtIndex:i];
            PFFile *imageFile = [dictStep objectForKey:@"image"];
            
            if(imageFile != nil){
                
                NSMutableDictionary *dictDraft = [[NSMutableDictionary alloc]init];
                
                if ([[imageFile url] rangeOfString:@".mov"].location == NSNotFound && [[imageFile url] rangeOfString:@".mp4"].location == NSNotFound) {
                    
                    //Step is an Image
                    [mutArrdraftsDetail addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]]]];
                    
                    // Form the array as we are sending on server
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]];
                    
                    [dictDraft setObject:imageData forKey:@"image"];
                    [dictDraft setObject:[dictStep objectForKey:@"text"] forKey:@"text"];
                    [_arrayImageData addObject:dictDraft];
                    
                }else{
                    
                    [mutArrdraftsDetail addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]]]];
                    
                    //Step is video
                    vedioData = [[NSMutableData alloc]init];
                    vedioData = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:[imageFile url]]];
                    [dictDraft setObject:vedioData forKey:@"vedio"];
                    [_arrayImageData addObject:dictDraft];
                    [dictDraft setObject:[dictStep objectForKey:@"text"] forKey:@"text"];
                }
                
            }else{
                PFFile *textImagefile = [dictStep objectForKey:@"textImage"];
                
                [mutArrdraftsDetail addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[textImagefile url]]]]];
                
                [appdelegateRefrence.mutDictStepsText setObject:[dictStep objectForKey:@"onlyText"] forKey:[NSString stringWithFormat:@"%d",i]];
                
                NSMutableDictionary *dictDraft = [[NSMutableDictionary alloc]init];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[textImagefile url]]];
                
                [dictDraft setObject:@"noImage" forKey:@"onlyText"];
                [dictDraft setObject:[dictStep objectForKey:@"text"] forKey:@"text"];
                [dictDraft setObject:imageData forKey:@"textImage"];
                [_arrayImageData addObject:dictDraft];
            }
        }
        
        if([mutArrdraftsDetail count] > 0){
            if([mutArrChaalengeSteps count] == 1){
                [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
                [mutArrChaalengeSteps addObject:[mutArrdraftsDetail objectAtIndex:0]];
                [mutArrdraftsDetail removeAllObjects];
            }else{
                mutArrChaalengeSteps = [mutArrdraftsDetail mutableCopy];
                [mutArrChaalengeSteps insertObject:[UIImage imageNamed:@"trasparent.png"] atIndex:0];
                [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
                [mutArrdraftsDetail removeAllObjects];
            }
            //_arrayImageData = [appdelegateRefrence.mutArryChallengeImageData mutableCopy];
            [mutArrdraftsDetail removeAllObjects];
        }else{
            [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
            [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
        }
    }else{
        [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
        [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
    }
    
    dictData = [[NSMutableDictionary alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tblViewChallengeStep reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    
	[super viewWillAppear:animated];
    
    if ([UIScreen mainScreen].bounds.size.height == 568.0) {
        
        [btnNext setFrame:CGRectMake(17, 393, 286, 38)];
    }else{
        [btnNext setFrame:CGRectMake(17, 393, 286, 38)];
    }
    
	/* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [tblViewChallengeStep reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidUnload{
    [self setBtnImageFromLibrary:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark - Button Action Events

- (IBAction)btnStep1Pressed:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Image,Video or Text" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Video"];
    [actionSheet addButtonWithTitle:@"Photo"];
    [actionSheet addButtonWithTitle:@"Text"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.destructiveButtonIndex = 3;
    [actionSheet showInView:self.view.window];
}

- (IBAction)btnEquipmentPressed:(id)sender{
    
    addEquipmentViewController *addEquipmentVC = [[addEquipmentViewController alloc]initWithNibName:@"addEquipmentViewController" bundle:nil];
    
    if (self.PFObjDraftChallenge) {
        
    }
    else{
        if([objCreateChallengeModel.arrEquipment count] != 0){
            addEquipmentVC.mutArrPreviouseAddedEquipment = objCreateChallengeModel.arrEquipment;
        }else{
            // User is navigating first time in the view
        }
    }
    
    
    
    addEquipmentVC.delegate = self;
    addEquipmentVC.title = @"Equipment";
    [self.navigationController pushViewController:addEquipmentVC animated:YES];
}

-(IBAction)btnDescriptionPressed:(id)sender{
    
}

-(IBAction)btnNextPressed:(id)sender{
    
    isDraftChallenge = NO;
    
    // Check if user is going to save draft challenge then delete it from parse
    if(self.PFObjDraftChallenge != nil){
        [self.PFObjDraftChallenge deleteInBackground];
    }
    
    // Add the new tags
    
    PFObject *challengeTags = [PFObject objectWithClassName:@"tblEventTag"];
    [challengeTags setObject:[PFUser currentUser] forKey:@"userId"];
    [challengeTags setObject:[NSString stringWithFormat:@"#%@",[self.objCreateChallengeModel.mutArrChallengeHashTags componentsJoinedByString:@" #"]] forKey:@"tagTitle"];
    
    //Set ACL permissions for added security
    PFACL *activitieACLtags = [PFACL ACLWithUser:[PFUser currentUser]];
    [activitieACLtags setPublicReadAccess:YES];
    [challengeTags setACL:activitieACLtags];
    
    [challengeTags saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            // Success fully save new tags
        }else{
            // Failed to save tags
        }
    }];
    
    activitie = [PFObject objectWithClassName:@"Challenge"];
    [activitie setObject:self.objCreateChallengeModel.strChallengeName  forKey:@"challengeName"];
    [activitie setObject:self.objCreateChallengeModel.strChallengeTags forKey:@"tags"];
    [activitie setObject:[PFUser currentUser] forKey:@"userId"];
    [activitie setObject:self.objCreateChallengeModel.mutArrChallengeHashTags forKey:@"challengeHashTags"];
    
    if(self.objCreateChallengeModel.strChallengeLocation != nil)
        [activitie setObject:self.objCreateChallengeModel.strChallengeLocation forKey:@"locationName"];
    
    // Check whether user selected equipment or not
    if([self.objCreateChallengeModel.arrEquipment count] > 0)
        [activitie setObject:[self.objCreateChallengeModel.arrEquipment componentsJoinedByString:@","] forKey:@"equipments"];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[self.objCreateChallengeModel.strLatitude doubleValue] longitude:[self.objCreateChallengeModel.strLongitude doubleValue]];
    [activitie setObject:point forKey:@"location"];
    
    //Set ACL permissions for added security
    PFACL *activitieACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [activitieACL setPublicReadAccess:YES];
    [activitie setACL:activitieACL];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Uploading...";
    
    [self performSelectorInBackground:@selector(uploadImageOnServer) withObject:nil];
    [self performSelectorInBackground:@selector(uploadMultipleImage) withObject:nil];
}

#pragma mark uploadImage

-(void)uploadImageOnServer{
    
    if(objCreateChallengeModel.teaserDataImage){
        [self uploadImage:objCreateChallengeModel.teaserDataImage TeaserVedio:nil];
    }else{
        NSData *imageData = UIImageJPEGRepresentation(objCreateChallengeModel.thumbNail, 0.05f);
        [self uploadTeaserThumImage:imageData];
        [self uploadImage:nil TeaserVedio:objCreateChallengeModel.teaserDataVideo];
    }
}

#pragma mark upload Media image

-(void)uploadTeaserThumImage :(NSData *)thumbImageData{
    
    // Save challenge as draft
    if(isDraftChallenge){
        PFFile *teaserImageFile = [PFFile fileWithName:@"teaserImage.jpg" data:thumbImageData];
        [teaserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error){
                //Hide determinate HUD
                [activitie setObject:teaserImageFile forKey:@"VideoThumbImage"];
                [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        //[MBProgressHUD hideHUDForView:self.view animated:YES];
                    }else{
                        
                    }
                }];
            }
        }];
    }
}

-(void)uploadImage:(NSData *)teaserImageDate TeaserVedio:(NSData *)teaserVediaDate{
    
    if(isDraftChallenge){
        // Save challenge as draft
        if (teaserImageDate){
            PFFile *teaserImageFile=[PFFile fileWithName:@"teaserImage.jpg" data:teaserImageDate];
            [teaserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //Hide determinate HUD
                    [activitie setObject:teaserImageFile forKey:@"teaserfile"];
                    [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        if (!error) {
                            //[MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                        else{
                            
                        }
                    }];
                }
                
            }];
        }else if(teaserVediaDate){
            
            PFFile *vedioTeaserfile = [PFFile fileWithName:@"vedioTeaser.mp4" data:teaserVediaDate];
            [vedioTeaserfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //Hide determinate HUD
                    
                    [activitie setObject:vedioTeaserfile forKey:@"teaserfile"];
                    //[activitie save];
                    [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error){
                            //[MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                        }
                        else{
                            
                        }
                    }];
                }
            }];
        }
    }
    
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    
    if([self.title isEqualToString:@"Step 2"]){
        if([mutArrChaalengeSteps count] > 0){
            appdelegateRefrence.mutArryChallengeStepsData = [[NSMutableArray alloc]initWithArray:[mutArrChaalengeSteps mutableCopy]];
            appdelegateRefrence.mutArryChallengeImageData = [[NSMutableArray alloc]initWithArray:[_arrayImageData mutableCopy]];
            
            if([[self.PFObjDraftChallenge objectForKey:@"challengeName"] isEqualToString:objCreateChallengeModel.strChallengeName]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"Do you want to save this challenge in draft"  delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
                alert.tag = 1000;
                [alert show];
            }
        }
        
    }else{
        // [self btnRemoveAnimatedViewForAddText:nil];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             tblViewChallengeStep.alpha = 1.0;
                             txtViewAddText.text = @"";
                             //self.navigationController.navigationBarHidden = NO;
                             self.title = @"Step 2";
                             btnNext.enabled = YES;
                             btnNext.alpha = 1.0;
                             [textAddView setFrame:CGRectMake(15.0, 780.0, 280.0, 300.0)];
                         }
                         completion:^(BOOL finished){
                             txtViewAddText.text = @"";
                         }];
    }
}

#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 1000){
        switch (buttonIndex){
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            case 1:
                [self saveChallengeAsDraft];
                break;
            default:
                break;
        }
    }else{
        if (!alertView.cancelButtonIndex) {
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
            
        }
    }
}

-(void)opeImagePickerConntroller{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    
    imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imgPicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
    
    imgPicker.allowsEditing = NO;
    
    [self presentViewController:imgPicker animated:TRUE completion:nil];
}

#pragma Mark UIImagePicker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *ImgView;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    dictData = [[NSMutableDictionary alloc]init];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *imgMediaImage = [info objectForKey:UIImagePickerControllerEditedImage];
        ImgView = imgMediaImage;
        if(clickedIndex+1 < [mutArrChaalengeSteps count]){
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:imgMediaImage];
        }else{
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:imgMediaImage];
            [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
        }
        
        [tblViewChallengeStep reloadData];
        
        NSData *imageData = UIImageJPEGRepresentation(imgMediaImage, 0.05f);
        
        [dictData setObject:imageData forKey:@"image"];
        [dictData setObject:@"" forKey:@"text"];
        
        [_arrayImageData addObject:dictData];
    }
    
    else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        vedioData = [[NSMutableData alloc]init];
        vedioData = [NSMutableData dataWithContentsOfURL:videoURL];
        [dictData setObject:vedioData forKey:@"vedio"];
        vedioData = nil;
        
        [_arrayImageData addObject:dictData];
        [dictData setObject:@"" forKey:@"text"];
        
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        ImgView = thumbnail;
        CGImageRelease(imageRef);
        
        if(clickedIndex+1 < [mutArrChaalengeSteps count]){
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:thumbnail];
        }else{
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:thumbnail];
            [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    imgViewStep.image = ImgView;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         tblViewChallengeStep.alpha=0.0;
                         btnNext.enabled = NO;
                         btnNext.alpha = 0.0;
                         
                         txtViewComment.frame=CGRectMake(5.0, 255.0, 224.0, 39.0);
                         [imgDisplayView setFrame:CGRectMake(8.0, 70.0, 304.0, 305.0)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

#pragma mark UploadImage

-(void)uploadMultipleImage{
    
    if(isDraftChallenge){
        
        NSMutableArray *arrImageFiles = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [_arrayImageData count]; i++) {
            NSDictionary *dictactorName = [_arrayImageData objectAtIndex:i];
            NSString *actorName = [[dictactorName allKeys] objectAtIndex:0];
            if ([actorName isEqualToString:@"image"]) {
                PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:[dictactorName objectForKey:@"image"]];
                [imageFile save];
                NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
                [dictStepDataAndText setObject:imageFile forKey:@"image"];
                [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
                [arrImageFiles addObject:dictStepDataAndText];
            }
            else if([actorName isEqualToString:@"onlyText"])
            {
                NSString *strNoImage = [dictactorName objectForKey:@"onlyText"];
                PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:[dictactorName objectForKey:@"textImage"]];
                [imageFile save];
                NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
                [dictStepDataAndText setObject:strNoImage forKey:@"onlyText"];
                [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
                [dictStepDataAndText setObject:imageFile forKey:@"textImage"];
                [arrImageFiles addObject:dictStepDataAndText];

            }else{
                PFFile *videoFile = [PFFile fileWithName:@"video.mp4" data:[dictactorName objectForKey:@"vedio"]];
                [videoFile save];
                NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
                [dictStepDataAndText setObject:videoFile forKey:@"image"];
                [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
                [arrImageFiles addObject:dictStepDataAndText];
            }
        }
        
        [activitie setObject:arrImageFiles forKey:@"myArray"];
        
        // Saving challenge into draft for future use
        [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(!error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSArray *array = [self.navigationController viewControllers];
                for(int i=0;i<array.count;i++){
                    if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                        [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                        break;
                    }
                }
            }
            else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
        }];
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Sending user to step third for save the challenge on server
        
        ChlngFrndStep3ViewController *chlngfrnd3VC = [[ChlngFrndStep3ViewController alloc]initWithNibName:@"ChlngFrndStep3ViewController" bundle:nil];
        chlngfrnd3VC.title = @"Step 3";
        chlngfrnd3VC.pfObjchallengeInfop = activitie;
        chlngfrnd3VC._arrayImageData = _arrayImageData;
        chlngfrnd3VC.objCreateChallengeModel = self.objCreateChallengeModel;
        chlngfrnd3VC.challengeName = self.objCreateChallengeModel.strChallengeName;
        [self.navigationController pushViewController:chlngfrnd3VC animated:YES];
    }
}

-(void)imagePickerControllerCustomCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerCustomLibrary:(id)sender{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
    imgPicker.allowsEditing = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self presentViewController:imgPicker animated:TRUE completion:nil];
}

-(void)customVideoCapture:(id)sender{
    UIBarButtonItem *barItemButton=(UIBarButtonItem*)sender;
    if([sender tag] == 0){
        [imgPicker startVideoCapture];
        [barItemButton setStyle:UIBarButtonSystemItemStop];
        [sender setTag:1];
    }else{
        
        [barItemButton setStyle:UIBarButtonSystemItemPlay];
        [imgPicker stopVideoCapture];
        [sender setTag:0];
    }
}

#pragma mark sendEquipment custom deleagte
-(void)sendEquipmentListToParentView:(NSMutableArray *)mutArrEqpList{
    self.objCreateChallengeModel.arrEquipment = [mutArrEqpList copy];
}

-(void)deleteEquipmentFromModelClass:(NSString *)equpmentName{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithArray:self.objCreateChallengeModel.arrEquipment];
    [mutArr removeObject:equpmentName];
    self.objCreateChallengeModel.arrEquipment = [mutArr copy];
    
}

#pragma Mark UIAction Sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            imgPickerController = [[UIImagePickerController alloc]init];
            imgPickerController.delegate = self;
            imgPickerController.allowsEditing = YES;
            imgPickerController.videoMaximumDuration = 6.0;
            imgPickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
            //[self presentModalViewController:imgPickerController animated:YES];
            
            [self presentViewController:imgPickerController animated:TRUE completion:nil];
            break;
        }
        case 1:{
            imgPickerController = [[UIImagePickerController alloc]init];
            imgPickerController.delegate = self;
            imgPickerController.allowsEditing = YES;
            imgPickerController.videoMaximumDuration = 6.0;
            imgPickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
            //[self presentModalViewController:imgPickerController animated:YES];
            
            [self presentViewController:imgPickerController animated:TRUE completion:nil];
            break;
        }
        case 2:{
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
                imgPickerController = [[UIImagePickerController alloc]init];
                imgPickerController.delegate = self;
                imgPickerController.allowsEditing = YES;
                imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgPickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie",nil];
                [self presentViewController:imgPickerController animated:TRUE completion:nil];
            }else{
                DisplayAlertWithTitle(@"FitTag", @"Your device dosen't support camera.")
            }
            
            break;
        }
        case 3:{
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationCurveEaseOut
                             animations:^{
                                 tblViewChallengeStep.alpha = 0.0;
                                 self.title = @"Add Description";
                                 btnNext.enabled = NO;
                                 btnNext.alpha = 0.0;
                                 txtViewAddText.backgroundColor = [UIColor clearColor];
                                 [textAddView setFrame:CGRectMake(0.0, 70.0, 320.0, 248.0)];
                                 
                             }
                             completion:^(BOOL finished){
                                 // [txtViewAddText becomeFirstResponder];
                             }];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight;
    }
	self.inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = YES;
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height;
    }
	self.inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = NO;
    
}

-(void)inputButtonPressed:(NSString *)inputText
{
    /* Called when toolbar button is pressed */
}

#pragma TableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([mutArrChaalengeSteps count]) {
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([mutArrChaalengeSteps count] > 0){
        if(abs([mutArrChaalengeSteps  count]%4)!= 4){
            return abs(([mutArrChaalengeSteps count]/4)+1);
        }else{
            return abs([mutArrChaalengeSteps count]/4);
        }
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *_cell;
    [[NSBundle mainBundle] loadNibNamed:@"CustomCellDetailView" owner:self options:nil];
    _cell = customTableCell;
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    int limit = 4;
    if ([mutArrChaalengeSteps count]<((indexPath.row+1)*4)) {
        limit = ([mutArrChaalengeSteps count])%4;
    }
    
    nameLabel2.font = [UIFont fontWithName:@"DynoRegular" size:8];
    nameLabel3.font = [UIFont fontWithName:@"DynoRegular" size:8];
    nameLabel4.font = [UIFont fontWithName:@"DynoRegular" size:8];
    
    for (int i = 0; i < limit; i++){
        
        switch (i) {
            case 0:
            {
                imageView1.hidden=FALSE;
                nameLabel1.hidden=FALSE;
                imageBG1.hidden=FALSE;
                
                btnprofile1.tag = ((indexPath.row*4)+i);
                
                [btnprofile1 addTarget:self action:@selector(profileViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                // setImage border
                imageView1.layer.borderColor = [UIColor grayColor].CGColor;
                imageView1.layer.borderWidth = 1.0;
                
                if(((indexPath.row*4)+i) != 0){
                    nameLabel1.font = [UIFont fontWithName:@"DynoRegular" size:8];
                    // Long presse gesture for delete the step image
                    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(addDeleteButton:)];
                    lpgr.minimumPressDuration = 1.0; //seconds
                    [btnprofile1 addGestureRecognizer:lpgr];
                    
                    nameLabel1.text = [NSString stringWithFormat:@"Step %d",((indexPath.row*4)+i)];
                    
                    btnDelete1.tag = ((indexPath.row*4)+i);
                    
                    [btnDelete1 addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if(addDeleteButtonAt == ((indexPath.row*4)+i)){
                        [btnDelete1 setImage:[UIImage imageNamed:@"deleteUser.png"] forState:UIControlStateNormal];
                    }
                    // setImage border
                    imageView1.layer.borderColor = [UIColor grayColor].CGColor;
                    imageView1.layer.borderWidth = 1.0;
                    
                    imageView1.tag   = ((indexPath.row*4)+i)+1000;
                    imageView1.image = [mutArrChaalengeSteps objectAtIndex:((indexPath.row*4)+i)];
                }else{
                    imageView1.image = [UIImage imageNamed:@"EquipmentThumb.png"];
                }
            }
                break;
            case 1:
            {
                imageView2.hidden = FALSE;
                nameLabel2.hidden = FALSE;
                imageBG2.hidden   = FALSE;
                
                // Long presse gesture for delete the step image
                UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(addDeleteButton:)];
                lpgr.minimumPressDuration = 1.0; //seconds
                [btnprofile2 addGestureRecognizer:lpgr];
                
                nameLabel2.text = [NSString stringWithFormat:@"Step %d",((indexPath.row*4)+i)];
                
                btnprofile2.tag = ((indexPath.row*4)+i);
                
                [btnprofile2 addTarget:self action:@selector(profileViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                btnDelete2.tag = ((indexPath.row*4)+i);
                
                [btnDelete2 addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                
                // setImage border
                imageView2.layer.borderColor = [UIColor grayColor].CGColor;
                imageView2.layer.borderWidth = 1.0;
                
                imageView2.tag = ((indexPath.row*4)+i)+1000;
                
                if(addDeleteButtonAt == ((indexPath.row*4)+i)){
                    [btnDelete2 setImage:[UIImage imageNamed:@"deleteUser.png"] forState:UIControlStateNormal];
                }
                imageView2.image = [mutArrChaalengeSteps objectAtIndex:((indexPath.row*4)+i)];
                
            }
                break;
            case 2:
            {
                imageView3.hidden=FALSE;
                nameLabel3.hidden=FALSE;
                imageBG3.hidden=FALSE;
                
                // Long presse gesture for delete the step image
                UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(addDeleteButton:)];
                lpgr.minimumPressDuration = 1.0; //seconds
                [btnprofile3 addGestureRecognizer:lpgr];
                
                
                nameLabel3.text = [NSString stringWithFormat:@"Step %d",((indexPath.row*4)+i)];
                
                btnprofile3.tag = ((indexPath.row*4)+i);
                
                [btnprofile3 addTarget:self action:@selector(profileViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                btnDelete3.tag = ((indexPath.row*4)+i);
                
                [btnDelete3 addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                imageView3.tag = ((indexPath.row*4)+i)+1000;
                
                // setImage border
                imageView3.layer.borderColor = [UIColor grayColor].CGColor;
                imageView3.layer.borderWidth = 1.0;
                
                if(addDeleteButtonAt == ((indexPath.row*4)+i)){
                    [btnDelete3 setImage:[UIImage imageNamed:@"deleteUser.png"] forState:UIControlStateNormal];
                }
                imageView3.image = [mutArrChaalengeSteps objectAtIndex:((indexPath.row*4)+i)];
                
            }
                break;
            case 3:
            {
                imageView4.hidden=FALSE;
                nameLabel4.hidden=FALSE;
                imageBG4.hidden=FALSE;
                
                // Long presse gesture for delete the step image
                UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(addDeleteButton:)];
                lpgr.minimumPressDuration = 1.0; //seconds
                [btnprofile4 addGestureRecognizer:lpgr];
                
                
                nameLabel4.text = [NSString stringWithFormat:@"Step %d",((indexPath.row*4)+i)];
                
                btnprofile4.tag = ((indexPath.row*4)+i);
                
                [btnprofile4 addTarget:self action:@selector(profileViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                btnDelete4.tag = ((indexPath.row*4)+i);
                imageView4.tag = ((indexPath.row*4)+i)+1000;
                [btnDelete4 addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                
                // setImage border
                imageView4.layer.borderColor = [UIColor grayColor].CGColor;
                imageView4.layer.borderWidth = 1.0;
                
                if(addDeleteButtonAt == ((indexPath.row*4)+i)){
                    [btnDelete4 setImage:[UIImage imageNamed:@"deleteUser.png"] forState:UIControlStateNormal];
                }
                imageView4.image = [mutArrChaalengeSteps objectAtIndex:((indexPath.row*4)+i)];
            }
                break;
        }
    }
    return _cell;
}

#pragma mark long press gesture

-(void)addDeleteButton:(id)sender{
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    int btnTag = gesture.view.tag;
    addDeleteButtonAt = btnTag;
    
    // Cancel button for remove close button fro Image
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone addTarget:self action:@selector(removeDeleteButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setFrame:CGRectMake(0, 0, 50, 30)];
    [btnDone setImage:[UIImage imageNamed:@"btnSmallCancel.png"] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [view addSubview:btnDone];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-13;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    
    [tblViewChallengeStep reloadData];
}

-(void)removeDeleteButtonCliked:(id)sender{
    addDeleteButtonAt = -1;
    self.navigationItem.rightBarButtonItem = nil;
    [tblViewChallengeStep reloadData];
}

#pragma Mark
#pragma Mark joined User profile Detail

-(void)profileViewButtonClick:(id)sender{
    UIButton *btnSender = (UIButton *)sender;
    clickedIndex = btnSender.tag;
    
    if(btnSender.tag == 0){
        addEquipmentViewController *addEquipmentVC = [[addEquipmentViewController alloc]initWithNibName:@"addEquipmentViewController" bundle:nil];
        if (self.PFObjDraftChallenge) {
            if ([objCreateChallengeModel.arrEquipment count] > [[[self.PFObjDraftChallenge objectForKey:@"equipments" ] componentsSeparatedByString:@","] count]) {
                addEquipmentVC.mutArrPreviouseAddedEquipment = objCreateChallengeModel.arrEquipment;
            }else{
                addEquipmentVC.mutArrPreviouseAddedEquipment =(NSMutableArray *)
                [[self.PFObjDraftChallenge objectForKey:@"equipments" ] componentsSeparatedByString:@","];
            }
        }
        else{
            if([objCreateChallengeModel.arrEquipment count] != 0){
                addEquipmentVC.mutArrPreviouseAddedEquipment = objCreateChallengeModel.arrEquipment;
            }else{
                
            }
        }
        addEquipmentVC.delegate = self;
        addEquipmentVC.title = @"Equipment";
        [self.navigationController pushViewController:addEquipmentVC animated:YES];
        
    }else{
        UIImageView *imgView = (UIImageView *) [tblViewChallengeStep viewWithTag:btnSender.tag+1000];
        
        if ([UIImagePNGRepresentation(imgView.image) isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"trasparent.png"])]){
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Image,Video or Text" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            
            [actionSheet addButtonWithTitle:@"Video"];
            [actionSheet addButtonWithTitle:@"Library"];
            [actionSheet addButtonWithTitle:@"Camera"];
            [actionSheet addButtonWithTitle:@"Text"];
            [actionSheet addButtonWithTitle:@"Cancel"];
            actionSheet.destructiveButtonIndex = 4;
            [actionSheet showInView:self.view.window];
            
        }else{
            NSArray *allTextStepsKeys = [[NSArray alloc]initWithArray:[appdelegateRefrence.mutDictStepsText allKeys]];
            
            if([allTextStepsKeys containsObject:[NSString stringWithFormat:@"%d",clickedIndex]]){
                txtViewAddText.text = txtViewComment.text = [[_arrayImageData objectAtIndex:clickedIndex-1]objectForKey:@"text"];
                
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationCurveEaseOut
                                 animations:^{
                                     tblViewChallengeStep.alpha = 0.0;
                                     self.title = @"Add Description";
                                     btnNext.enabled = NO;
                                     btnNext.alpha = 0.0;
                                     txtViewAddText.backgroundColor = [UIColor clearColor];
                                     [textAddView setFrame:CGRectMake(0.0, 70.0, 320.0, 248.0)];
                                 }
                                 completion:^(BOOL finished){
                                     // [txtViewAddText becomeFirstResponder];
                                 }];
                
            }else{
                imgViewStep.image = imgView.image;
                txtViewComment.text = [[_arrayImageData objectAtIndex:clickedIndex-1]objectForKey:@"text"];
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationCurveEaseOut
                                 animations:^{
                                     tblViewChallengeStep.alpha=0.0;
                                     btnNext.enabled = NO;
                                     btnNext.alpha = 0.0;
                                     
                                     txtViewComment.frame=CGRectMake(5.0, 255.0, 224.0, 39.0);
                                     [imgDisplayView setFrame:CGRectMake(8.0, 70.0, 304.0, 305.0)];
                                     
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            }
            
        }
    }
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

#pragma mark
#pragma mark Delete image from grid view

-(void)deleteImage:(id)sender{
    
    if([mutArrChaalengeSteps count] == 2){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"You can't delete this as we need at least one image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        UIButton *btnSender = (UIButton *)sender;
        addDeleteButtonAt = -1;
        [mutArrChaalengeSteps removeObjectAtIndex:btnSender.tag];
        self.navigationItem.rightBarButtonItem = nil;
        [tblViewChallengeStep reloadData];
    }
}

- (IBAction)btnRemoveAnimatedView:(id)sender{
    
    if([txtViewComment isFirstResponder]){
        [txtViewComment resignFirstResponder];
    }
    
    [[_arrayImageData objectAtIndex:clickedIndex-1]removeObjectForKey:@"text"];
    [[_arrayImageData objectAtIndex:clickedIndex-1]setObject:txtViewComment.text forKey:@"text"];
    
    txtViewComment.text = @"";
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         tblViewChallengeStep.alpha = 1.0;
                         btnNext.enabled = YES;
                         btnNext.alpha = 1.0;
                         
                         [imgDisplayView setFrame:CGRectMake(15.0, 780.0, 280.0, 300.0)];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)btnRemoveAnimatedViewForAddText:(id)sender{
    if ([txtViewAddText.text isEqualToString:@""]) {
        DisplayLocalizedAlert(@"Please write a description for this step")
    }
    else{
        txtViewAddText.backgroundColor = [UIColor whiteColor];
        
        if([txtViewAddText isFirstResponder]){
            [txtViewAddText resignFirstResponder];
            sleep(0.5);
        }
        
        UIGraphicsBeginImageContext(txtViewAddText.bounds.size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(c,0,0);
        [txtViewAddText.layer renderInContext:c];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        if(clickedIndex+1 < [mutArrChaalengeSteps count]){
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:newImage];
        }else{
            [mutArrChaalengeSteps replaceObjectAtIndex:clickedIndex withObject:newImage];
            [mutArrChaalengeSteps addObject:[UIImage imageNamed:@"trasparent.png"]];
        }
        
        [tblViewChallengeStep reloadData];
        
        NSData *imageData = UIImageJPEGRepresentation(newImage,0.05f);
        
        NSMutableDictionary *dictDataImage = [[NSMutableDictionary alloc]init];
        
        [dictDataImage setObject:@"noImage" forKey:@"onlyText"];
        [dictDataImage setObject:txtViewAddText.text forKey:@"text"];
        [dictDataImage setObject:imageData forKey:@"textImage"];
        
        [appdelegateRefrence.mutDictStepsText setObject:txtViewAddText.text forKey:[NSString stringWithFormat:@"%d",clickedIndex]];
        
        [_arrayImageData addObject:dictDataImage];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             tblViewChallengeStep.alpha = 1.0;
                             txtViewAddText.text = @"";
                             //self.navigationController.navigationBarHidden = NO;
                             self.title = @"Step 2";
                             btnNext.enabled = YES;
                             btnNext.alpha = 1.0;
                             [textAddView setFrame:CGRectMake(15.0, 780.0, 280.0, 300.0)];
                         }
                         completion:^(BOOL finished){
                             txtViewAddText.text = @"";
                         }];
    }
}

-(IBAction)btnCancelViewForAddText:(id)sender{
    
    if([txtViewAddText isFirstResponder]){
        [txtViewAddText resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         txtViewAddText.text = @"";
                         tblViewChallengeStep.alpha = 1.0;
                         //self.navigationController.navigationBarHidden = NO;
                         self.title = @"Step 2";
                         btnNext.enabled = YES;
                         btnNext.alpha = 1.0;
                         [textAddView setFrame:CGRectMake(15.0, 780.0, 280.0, 300.0)];
                     }
                     completion:^(BOOL finished){
                         txtViewAddText.text = @"";
                     }];
}

#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
/*-(void)textViewDidBeginEditing:(UITextView *)textView{
 CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
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
 
 -(void)textViewDidEndEditing:(UITextView *)textView{
 
 CGRect viewFrame = self.view.frame;
 viewFrame.origin.y += animatedDistance;
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
 [self.view setFrame:viewFrame];
 [UIView commitAnimations];
 }*/

#pragma mark- textview Delegate method

//TextView Delegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(newLength < 160){
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }else{
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark save in Draft

-(void)saveChallengeAsDraft{
    // Save the draft challenge on the parse
    isDraftChallenge = YES;
    
    activitie = [PFObject objectWithClassName:@"ChallengeDrafts"];
    [activitie setObject:self.objCreateChallengeModel.strChallengeName  forKey:@"challengeName"];
    [activitie setObject:self.objCreateChallengeModel.strChallengeTags forKey:@"tags"];
    [activitie setObject:[PFUser currentUser] forKey:@"userId"];
    [activitie setObject:self.objCreateChallengeModel.mutArrChallengeHashTags forKey:@"challengeHashTags"];
    
    if(self.objCreateChallengeModel.strChallengeLocation != nil)
        [activitie setObject:self.objCreateChallengeModel.strChallengeLocation forKey:@"locationName"];
    
    // Check whether user selected equipment or not
    if([self.objCreateChallengeModel.arrEquipment count] > 0)
        [activitie setObject:[self.objCreateChallengeModel.arrEquipment componentsJoinedByString:@","] forKey:@"equipments"];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[self.objCreateChallengeModel.strLatitude doubleValue] longitude:[self.objCreateChallengeModel.strLongitude doubleValue]];
    [activitie setObject:point forKey:@"location"];
    
    //Set ACL permissions for added security
    PFACL *activitieACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [activitieACL setPublicReadAccess:YES];
    [activitie setACL:activitieACL];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Saving...";
    
    [self performSelectorInBackground:@selector(uploadImageOnServer) withObject:nil];
    [self performSelectorInBackground:@selector(uploadMultipleImage) withObject:nil];
}

@end
