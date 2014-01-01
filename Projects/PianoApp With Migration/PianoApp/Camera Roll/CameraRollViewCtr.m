//
//  CameraRollViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraRollViewCtr.h"
#import "UIImage+KTCategory.h"
#import "GlobalMethods.h"
#import "AGIPCToolbarItem.h"

@implementation CameraRollViewCtr

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
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];

    [GlobalMethods SetViewShadow:ViewPrivacy];
    
    appdel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdel.strCallYesOrNo = @"Yes";
    
    [self PrivacyButtonHideShowOK:YES Layer:YES imgPrivacy:YES];
    
    [btnOk setImage:[UIImage imageNamed:@"OKButtonOrange.png"] forState:UIControlStateHighlighted];
    [btnOk setImage:[UIImage imageNamed:@"OKButtonWhite.png"] forState:UIControlStateNormal];
    
    searching = NO;
    
    for (UITextField *tf in imgvideosearchBar.subviews)
    {
        if ([tf isKindOfClass:[UITextField class]])
        {
            tf.font = [UIFont fontWithName:@"GillSans-Light" size:18.0];
        }
    }
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    __block CameraRollViewCtr *blockSelf = self;
    
    ipc = [[AGImagePickerController alloc] initWithDelegate:self];
    ipc.didFailBlock = ^(NSError *error) {
        //NSLog(@"Fail. Error: %@", error);
        
        if (error == nil) {
            // [blockSelf SetDelegateString];
            [blockSelf dismissModalViewControllerAnimated:YES];
        } else {
            
            // We need to wait for the view controller to appear first.
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //  [blockSelf SetDelegateString];
                [blockSelf dismissModalViewControllerAnimated:YES];
            });
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    };
    ipc.didFinishBlock = ^(NSArray *info) {
        
        [blockSelf SetDelegateString];
        [blockSelf dismissModalViewControllerAnimated:YES];
        [blockSelf PrivacyButtonHideShowOK:NO Layer:NO imgPrivacy:NO];
        [blockSelf performSelector:@selector(CallAfterSomeTimeMultiple:) withObject:info afterDelay:0.1];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    };
    // Do any additional setup after loading the view from its nib.
}
-(void)SetDelegateString
{
    appdel.strCallYesOrNo = @"No";
    lblNoPhoto.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([appdel.strCallYesOrNo isEqualToString:@"Yes"])
    {
        Yaxis=4;
        Xaxis=-75;
        TagLast = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [AppDel doshowHUD];
        [self performSelector:@selector(AfterDelayCalled) withObject:nil afterDelay:0.2];
    }
}
-(void)AfterDelayCalled
{
    ArryPhotoVideo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_cameraroll:@"SELECT * FROM tbl_cameraroll"]];
    [self performSelectorInBackground:@selector(callThumbnail:) withObject:ArryPhotoVideo];
    appdel.strCallYesOrNo = @"No";
}
-(void)callThumbnail:(NSMutableArray*)arryTempPhotoVideo
{
    @autoreleasepool
    {
        while ([Scl_Photo.subviews count] > 0) {
            
            [[[Scl_Photo subviews] objectAtIndex:0] removeFromSuperview];
        }
        if ([arryTempPhotoVideo count] == 0)
        {
            lblNoPhoto.hidden = NO;
        }
        else
        {
            lblNoPhoto.hidden = YES;
        }
        for (NSDictionary *DicPhotoVideo in arryTempPhotoVideo)
        {
            Xaxis=Xaxis+79;
            if (Xaxis > 260)
            {
                Xaxis=4;
                Yaxis=Yaxis+79;
            }
            
            NSArray *ArryPathString = [[DicPhotoVideo valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
            NSString *strImageName = [ArryPathString lastObject];
            NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
            
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
            UIButton *btnPicBig = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPicBig setFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
            
            dispatch_queue_t queue = dispatch_queue_create("GenerateThumb",NULL);
            dispatch_async(queue, ^{
                UIImage *thumbnail = [GlobalMethods imageAtPath:strAttachmentPath cache:appdel.DicCache ImageType:[DicPhotoVideo  valueForKey:@"type"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = thumbnail;
                });
            });
            
            [Scl_Photo addSubview:imgView];
            
            [btnPicBig setTag:TagLast];
            TagLast ++;
            [btnPicBig addTarget:self action:@selector(btnPicBigPressed:) forControlEvents:UIControlEventTouchUpInside];
            if ([[DicPhotoVideo  valueForKey:@"type"] isEqualToString:@"Video"])
            {
                UIImageView *imgVideoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Xaxis, Yaxis + 60, 75, 15)];
                [imgVideoIcon setContentMode:UIViewContentModeScaleToFill];
                [imgVideoIcon setImage:[UIImage imageNamed:@"videoicon.png"]];
                [Scl_Photo addSubview:imgVideoIcon];
                
                UILabel *lblVideoDuration = [[UILabel alloc] initWithFrame:CGRectMake(Xaxis, Yaxis + 60, 73, 15)];
                lblVideoDuration.backgroundColor = [UIColor clearColor];
                lblVideoDuration.textAlignment = UITextAlignmentRight;
                lblVideoDuration.font = [UIFont boldSystemFontOfSize:10.0f];
                lblVideoDuration.textColor = [UIColor whiteColor];
                lblVideoDuration.alpha = 1.0f;
                [Scl_Photo addSubview:lblVideoDuration];
                
                dispatch_queue_t queue = dispatch_queue_create("CountSeconds",NULL);
                dispatch_async(queue, ^{
                    NSURL *videoURL = [NSURL fileURLWithPath:strAttachmentPath];
                    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
                    
                    CMTime duration = playerItem.duration;
                    float seconds = CMTimeGetSeconds(duration);
                    NSInteger myInt = roundf(seconds);
                    
                    float hour1 = myInt/3600;
                    int hourleft1 = myInt % 3600;
                    float min1 = hourleft1/60;
                    float second1 = hourleft1 % 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (hour1 == 0)
                        {
                            lblVideoDuration.text = [NSString stringWithFormat:@"%02.0f:%02.0f",min1,second1];
                        }
                        else
                        {
                            lblVideoDuration.text = [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f",hour1,min1,second1];
                        }
                    });
                });
                
                
            }
            [Scl_Photo addSubview:btnPicBig];
            
            Scl_Photo.contentSize=CGSizeMake(320,Yaxis+79);
            
            CGPoint bottomOffset = CGPointMake(0, MAX(Scl_Photo.contentSize.height - Scl_Photo.bounds.size.height, 0));
            [Scl_Photo setContentOffset:bottomOffset animated:NO];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [AppDel dohideHUD];
    }
}
-(IBAction)btnPicBigPressed:(id)sender
{
    [imgvideosearchBar resignFirstResponder];
    
    PhotoScrollerViewctr *obj_PhotoScrollerViewctr = [[PhotoScrollerViewctr alloc]initWithNibName:@"PhotoScrollerViewctr" bundle:nil];
    appdel.strCallYesOrNo = @"No";
    obj_PhotoScrollerViewctr.indexclick = [sender tag];
    obj_PhotoScrollerViewctr.ArryImgsPass = ArryPhotoVideo;
    [self presentModalViewController:obj_PhotoScrollerViewctr animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // Show saved photos on top
        ipc.shouldShowSavedPhotosOnTop = YES;
        ipc.shouldChangeStatusBarStyle = YES;
        // ipc.selection = self.selectedPhotos;
        ipc.maximumNumberOfPhotosToBeSelected = 25;
        
        // Custom toolbar items
        /* AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Max 25 selection at a time" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
         return NO;
         }];*/
        AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
        /* AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"+ Select Odd" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
         return !(index % 2);
         }];*/
        AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
            return NO;
        }];
        ipc.toolbarItemsForManagingTheSelection = @[flexible, deselectAll];
        [self presentModalViewController:ipc animated:YES];
    }
    else if (buttonIndex == 1)
    {
        if (!imagePickerPhotoLibrary)
        {
            imagePickerPhotoLibrary = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePickerPhotoLibrary.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            }
            NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.movie",nil];
            [imagePickerPhotoLibrary setMediaTypes:mediaTypesAllowed];
            imagePickerPhotoLibrary.delegate = self;
            imagePickerPhotoLibrary.allowsEditing = NO;
            imagePickerPhotoLibrary.wantsFullScreenLayout=TRUE;
        }
        
        [self presentModalViewController:imagePickerPhotoLibrary animated:YES];
    }
    else if (buttonIndex == 2)
    {
        if (!imagePickerCamera)
        {
            imagePickerCamera = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerCamera.sourceType =  UIImagePickerControllerSourceTypeCamera;
            }
            NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.image",@"public.movie",nil];
            [imagePickerCamera setMediaTypes:mediaTypesAllowed];
            imagePickerCamera.delegate = self;
            imagePickerCamera.allowsEditing = NO;
            imagePickerCamera.wantsFullScreenLayout=TRUE;
        }
        [self presentModalViewController:imagePickerCamera animated:YES];
    }
    else if (buttonIndex == 3)
    {
         return;
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    appdel.strCallYesOrNo = @"No";

    [picker dismissModalViewControllerAnimated:YES];
    
    lblNoPhoto.hidden = YES;
    [self PrivacyButtonHideShowOK:NO Layer:NO imgPrivacy:NO];
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        NSTimeInterval ttime = [[NSDate date] timeIntervalSince1970];
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/ImageClue%f.png",documentsDirectory,ttime];
        NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
        [data1 writeToFile:pngFilePath atomically:NO];
        
        NSString *str_Insert_CameraRoll = [NSString stringWithFormat:@"insert into tbl_cameraroll(attachment,type,tag,desc) values('%@','%@','%@','%@')",pngFilePath,@"Image",@"",@""];
        [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_CameraRoll];
    }
    else
    {
        NSTimeInterval ttime = [[NSDate date] timeIntervalSince1970];
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        NSString *strVideoURL = [documentsDirectory stringByAppendingFormat:@"/videoclue%f.mov",ttime];
        [videoData writeToFile:strVideoURL atomically:NO];
        
        NSString *str_Insert_CameraRoll = [NSString stringWithFormat:@"insert into tbl_cameraroll(attachment,type,tag,desc) values('%@','%@','%@','%@')",strVideoURL,@"Video",@"",@""];
        [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_CameraRoll];
    }
    
    NSMutableArray *ArryAddPhotoVideo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_cameraroll:@"SELECT * FROM  tbl_cameraroll ORDER BY id DESC LIMIT 1"]];
    NSArray *ArryReverse = [[NSArray alloc] initWithArray:ArryAddPhotoVideo];
    ArryReverse = [[ArryReverse reverseObjectEnumerator]allObjects];
    ArryAddPhotoVideo = [ArryReverse mutableCopy];
    for (NSDictionary *DicPhotoVideo in ArryAddPhotoVideo)
    {
        [self performSelectorInBackground:@selector(LoadThumbnailFromArray:) withObject:DicPhotoVideo];
    }
}
-(void)PrivacyButtonHideShowOK:(BOOL)okValue Layer:(BOOL)layerValue imgPrivacy:(BOOL)imgPrivacyValue
{
    btnOk.hidden = okValue;
    btnLayer.hidden = layerValue;
    ViewPrivacy.hidden = imgPrivacyValue;
}

-(void)CallAfterSomeTimeMultiple:(NSArray*)DicInfo
{
    for(NSDictionary *dict in DicInfo)
    {
        NSTimeInterval ttime = [[NSDate date] timeIntervalSince1970];
        ALAsset *Asset = (ALAsset*)dict;
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/ImageClue%f.png",documentsDirectory,ttime];
        
        NSURL *ImageURL = [[Asset valueForProperty:ALAssetPropertyURLs]
                           valueForKey:[[[Asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        
        [assetLibrary assetForURL:ImageURL resultBlock:^(ALAsset *asset)
         {
             ALAssetRepresentation *rep = [asset defaultRepresentation];
             Byte *buffer = (Byte*)malloc(rep.size);
             NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
             NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
             [data writeToFile:pngFilePath atomically:NO];
             
             NSString *str_Insert_CameraRoll = [NSString stringWithFormat:@"insert into tbl_cameraroll(attachment,type,tag,desc) values('%@','%@','%@','%@')",pngFilePath,@"Image",@"",@""];
             [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_CameraRoll];
             
             NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM  tbl_cameraroll ORDER BY id DESC LIMIT 1"];
             NSMutableArray *ArryAddPhotoVideo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_cameraroll:strQuery]];
             NSArray *ArryReverse = [[NSArray alloc] initWithArray:ArryAddPhotoVideo];
             ArryReverse = [[ArryReverse reverseObjectEnumerator]allObjects];
             ArryAddPhotoVideo = [ArryReverse mutableCopy];
             for (NSDictionary *dicPhoto in ArryAddPhotoVideo)
             {
                 [self performSelectorInBackground:@selector(LoadThumbnailFromArray:) withObject:dicPhoto];
             }
         } failureBlock:^(NSError *err) {
             NSLog(@"Error: %@",[err localizedDescription]);
         }];
	}
    
}

-(void)LoadThumbnailFromArray:(NSDictionary*)DicLoad
{
    @autoreleasepool
    {
        
        [ArryPhotoVideo addObject:DicLoad];
        
        Xaxis=Xaxis+79;
        if (Xaxis > 260)
        {
            Xaxis=4;
            Yaxis=Yaxis+79;
        }
        
        NSArray *ArryPathString = [[DicLoad valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
        NSString *strImageName = [ArryPathString lastObject];
        NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
        UIButton *btnPicBig = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPicBig setFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
        
        dispatch_queue_t queue = dispatch_queue_create("GenerateThumb",NULL);
        dispatch_async(queue, ^{
            UIImage *thumbnail = [GlobalMethods imageAtPath:strAttachmentPath cache:appdel.DicCache ImageType:[DicLoad  valueForKey:@"type"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = thumbnail;
            });
        });
        
        [Scl_Photo addSubview:imgView];
        
        [btnPicBig setTag:TagLast];
        TagLast ++;
        [btnPicBig addTarget:self action:@selector(btnPicBigPressed:) forControlEvents:UIControlEventTouchUpInside];
        if ([[DicLoad  valueForKey:@"type"] isEqualToString:@"Video"])
        {
            UIImageView *imgVideoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Xaxis, Yaxis + 60, 75, 15)];
            [imgVideoIcon setContentMode:UIViewContentModeScaleToFill];
            [imgVideoIcon setImage:[UIImage imageNamed:@"videoicon.png"]];
            [Scl_Photo addSubview:imgVideoIcon];
            
            UILabel *lblVideoDuration = [[UILabel alloc] initWithFrame:CGRectMake(Xaxis, Yaxis + 60, 73, 15)];
            lblVideoDuration.backgroundColor = [UIColor clearColor];
            lblVideoDuration.textAlignment = UITextAlignmentRight;
            lblVideoDuration.font = [UIFont boldSystemFontOfSize:10.0f];
            lblVideoDuration.textColor = [UIColor whiteColor];
            lblVideoDuration.alpha = 1.0f;
            [Scl_Photo addSubview:lblVideoDuration];
            
            dispatch_queue_t queue = dispatch_queue_create("CountSeconds",NULL);
            dispatch_async(queue, ^{
                NSURL *videoURL = [NSURL fileURLWithPath:strAttachmentPath];
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
                
                CMTime duration = playerItem.duration;
                float seconds = CMTimeGetSeconds(duration);
                NSInteger myInt = roundf(seconds);
                
                float hour1 = myInt/3600;
                int hourleft1 = myInt % 3600;
                float min1 = hourleft1/60;
                float second1 = hourleft1 % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (hour1 == 0)
                    {
                        lblVideoDuration.text = [NSString stringWithFormat:@"%02.0f:%02.0f",min1,second1];
                    }
                    else
                    {
                        lblVideoDuration.text = [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f",hour1,min1,second1];
                    }
                });
            });
            
        }
        [Scl_Photo addSubview:btnPicBig];
        
        Scl_Photo.contentSize=CGSizeMake(320,Yaxis+79);
        
        CGPoint bottomOffset = CGPointMake(0, MAX(Scl_Photo.contentSize.height - Scl_Photo.bounds.size.height, 0));
        [Scl_Photo setContentOffset:bottomOffset animated:NO];
    }
}

-(IBAction)btnOKPressed:(id)sender
{
    [self PrivacyButtonHideShowOK:YES Layer:YES imgPrivacy:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    appdel.strCallYesOrNo = @"No";
    // Dismiss the image selection and close the program
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - AGImagePickerControllerDelegate methods

- (NSUInteger)agImagePickerController:(AGImagePickerController *)picker
         numberOfItemsPerRowForDevice:(AGDeviceType)deviceType
              andInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return 4;
}

- (BOOL)agImagePickerController:(AGImagePickerController *)picker shouldDisplaySelectionInformationInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode
{
    return (selectionMode == AGImagePickerControllerSelectionModeSingle ? NO : YES);
}

- (BOOL)agImagePickerController:(AGImagePickerController *)picker shouldShowToolbarForManagingTheSelectionInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode
{
    return (selectionMode == AGImagePickerControllerSelectionModeSingle ? NO : YES);
}

- (AGImagePickerControllerSelectionBehaviorType)selectionBehaviorInSingleSelectionModeForAGImagePickerController:(AGImagePickerController *)picker
{
    return AGImagePickerControllerSelectionBehaviorTypeRadio;
}

#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnAddPressed:(id)sender
{
    if ([imgvideosearchBar.text length] == 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Choose photo from library",@"Choose video from library",@"Take from camera",@"Cancel", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        sheet.destructiveButtonIndex = 3;
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
}


#pragma mark - SearchBar Delegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
    //Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat width = Scl_Photo.frame.size.width;
	CGFloat height = Scl_Photo.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 88, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController3 = self;
	
	[self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    
	searching = YES;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
    if ([ArryPhotoVideo count] > 0)
    {
        [ArryPhotoVideo removeAllObjects];
    }
	
	if([searchText length] > 0) {
		searching = YES;
		[self searchTableView];
	}
	else {
		searching = NO;
        [self searchTableView];
        [self doneSearching_Clicked];
	}
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
    [ovController.view removeFromSuperview];
	ovController = nil;
	[imgvideosearchBar resignFirstResponder];
}

- (void) searchTableView {

	NSString *searchText = imgvideosearchBar.text;
    
    NSString *strSearch =[NSString stringWithFormat:@"SELECT * FROM tbl_cameraroll where tag LIKE '%%%@%%'",searchText];
	ArryPhotoVideo = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_cameraroll:strSearch]];
    
    Yaxis=4;
    Xaxis=-75;
    TagLast = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [AppDel doshowHUD];
    
    [self performSelector:@selector(callThumbnail:) withObject:ArryPhotoVideo];
}

- (void) doneSearching_Clicked {
	
   /* Yaxis=4;
    Xaxis=-75;
    TagLast = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [AppDel doshowHUD];
    [self performSelectorInBackground:@selector(callThumbnail:) withObject:ArryPhotoVideo];*/
    
    [ovController.view removeFromSuperview];
	ovController = nil;

	//imgvideosearchBar.text = @"";
	[imgvideosearchBar resignFirstResponder];
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
