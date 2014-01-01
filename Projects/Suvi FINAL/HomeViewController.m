//
//  HomeViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "IIViewDeckController.h"
#import "PhotoZoomViewController.h"

// New Avaiary Classes
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "AFPhotoEditorController.h"
#import "AFPhotoEditorCustomization.h"
#import "AFOpenGLManager.h"
#import "MapVC.h"

@interface HomeViewController () <AFPhotoEditorControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;

@end

@implementation HomeViewController
@synthesize imgFlag;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self NewAviaryClassSetUp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeView:) name:@"pushIt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddViews:) name:@"presentIt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPhotoZoom:) name:@"photoZoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMapView:) name:@"MapviewController" object:nil];
}

#pragma mark - New Aviary Class Allocation
-(void)NewAviaryClassSetUp
{
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
}

-(void)openPhotoZoom:(NSNotification *)notif
{
    PhotoZoomViewController *obj=[[PhotoZoomViewController alloc]init];
    obj.imgURL = [notif.object valueForKey:@"imgURL"];
    [self presentModalViewController:obj animated:NO];
}
-(void)openMapView:(NSNotification *)notif
{
    MapVC *obj=[[MapVC alloc]init];
    obj.dictMapVC = (id)notif.object ;
    [self presentModalViewController:obj animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=TRUE;
    
    if (AddViewFlag!=50)
    {
        UIButton *btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption setBackgroundColor:[UIColor clearColor]];
        [btnOption setImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];
        [btnOption setFrame:CGRectMake(9, 5+iOS7ExHeight, 34, 35)];
        [btnOption addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOption];
        
        UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnContact setBackgroundColor:[UIColor clearColor]];
        [btnContact setImage:[UIImage imageNamed:@"contact.png"] forState:UIControlStateNormal];
        [btnContact setFrame:CGRectMake(276, 5+iOS7ExHeight, 34, 35)];
        [btnContact addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnContact];
        
        [self ChangeView:nil];
    }
}

-(void)ChangeView:(NSNotification *)notif
{
    if (objViewControl1 !=nil)
    {
        [objViewControl1.view removeFromSuperview];
        objViewControl1=nil;
    }
    if (objMyFeedsViewController !=nil)
    {
        [objMyFeedsViewController.view removeFromSuperview];
        objMyFeedsViewController=nil;
    }

    if (FlagView1==0) 
    {
        self.navigationItem.title=@"YOU";
    }
    else if (FlagView1==1)
    {
        objViewControl1=[[ViewControl1 alloc] initWithNibName:@"ViewControl1" bundle:nil];
        [self.view addSubview:objViewControl1.view];
    }
    else if (FlagView1==2)
    {
        objMyFeedsViewController=[[MyFeedsViewController alloc] initWithNibName:@"MyFeedsViewController" bundle:nil];
        [self.view addSubview:objMyFeedsViewController.view];
    }
}
-(void)AddViews:(NSNotification *)notif
{
    if (AddViewFlag==1)
    {
        strPostSuccessful = @"PostOnly";
        PostViewController *objPost=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
        objPost.imgToPost = nil;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPost];
        [self presentModalViewController:navC animated:YES];
    }
    else if (AddViewFlag==2)
    {
        strPostSuccessful = @"PostOnly";
        PostViewController *objPost=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
        objPost.isLocationPostingView=YES;
        objPost.imgToPost = nil;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPost];
        [self presentModalViewController:navC animated:YES];
    }
    else if (AddViewFlag==9)
    {
        strPostSuccessful = @"PostOnly";
        PostViewController *objPost=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
        objPost.isYouTubePostingView=YES;
        objPost.imgToPost = nil;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPost];
        [self presentModalViewController:navC animated:YES];
    }
    else if (AddViewFlag==3)
    {
        AddFriendsViewController *obj=[[AddFriendsViewController alloc]initWithNibName:@"AddFriendsViewController" bundle:nil];
        UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:obj];
        navc.navigationBarHidden=YES;
        [self presentModalViewController:navc animated:YES];
    }
    else if (AddViewFlag==4)
    {
        strPostSuccessful = @"PostVideo";
        PostViewController *objPostViewController = [[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
        objPostViewController.videoURL = [notif.object valueForKey:@"videoURL"];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPostViewController];
        [self presentModalViewController:navC animated:YES];
    }
    else if (AddViewFlag==5)
    {
        AddCommentView *objAddCommentView = [[AddCommentView alloc]initWithNibName:@"AddCommentView" bundle:nil];
        objAddCommentView.dictAllData = [notif.object copy];
        objAddCommentView.iActivityID = [notif.object valueForKey:@"iActivityID"];
        objAddCommentView.vType_of_post = [notif.object valueForKey:@"vType_of_content"];
        [self.navigationController presentModalViewController:objAddCommentView animated:YES];
    }
    else if (AddViewFlag==6)
    {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        mediaPicker.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO; // this is the default  
        [self presentModalViewController:mediaPicker animated:YES];
    }
    else if (AddViewFlag==7)
    {
        AFPhotoEditorController *featherController = [[AFPhotoEditorController alloc] initWithImage:[[notif.object valueForKey:@"imgToPost"] copy]];
        [featherController setDelegate:self];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:featherController];
        navC.navigationBarHidden = YES;
        [self presentModalViewController:navC animated:YES]; 
    }
    else if (AddViewFlag==8)
    {
        FriendsProfileVC *objFriendsProfileVC = [[FriendsProfileVC alloc]initWithNibName:@"FriendsProfileVC" bundle:nil];
        objFriendsProfileVC.admin_id = [[notif.object valueForKey:@"admin_id"] copy];
        objFriendsProfileVC.shouldShowOnlyOneFeed = NO;
        objFriendsProfileVC.strFrom = @"FriendView";
        [self.navigationController pushViewController:objFriendsProfileVC animated:YES];
    }
    else if (AddViewFlag==40)
    {
        NSString *str = [[notif.object valueForKey:@"imgFlag"] copy];
        if ([str isEqualToString:@"TakePhoto"])
        {
            [self openCamera:str];
        }
        else if ([str isEqualToString:@"ChoosePhoto"])
        {
            [self openLibrary:str];
        }
        else if ([str isEqualToString:@"TakeVideo"])
        {
            [self TakeVideo:str];
        }
        else if ([str isEqualToString:@"ChooseVideo"])
        {
            [self ChooseVideo:str];
        }
    }
    else if (AddViewFlag==51)
    {
        WatchVideoViewController *objWatchVideoViewController = [[WatchVideoViewController alloc]initWithNibName:@"WatchVideoViewController" bundle:nil];
        objWatchVideoViewController.imgURLPOST=[notif.object valueForKey:@"imgURLPOST"];
        [self presentModalViewController:objWatchVideoViewController animated:YES];
    }
}

#pragma mark - Camera Or Library
-(void)openCamera:(NSString *)str
{
    AddViewFlag = 50;
    self.imgFlag = @"TakePhoto";
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [UIImagePickerController new] ;
        
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [pickerController setDelegate:self];
        if (CoverORProfileORIMGPost == 1 || CoverORProfileORIMGPost == 2)
        {
            pickerController.allowsEditing=YES;
        }

        [self presentModalViewController:pickerController animated:YES];
    }
    else
    {
        DisplayAlertWithTitle(@"Note!!", @"Camera is not available on your device");
        return;
    }
}
-(void)openLibrary:(NSString *)str
{
    AddViewFlag = 50;
    self.imgFlag = @"ChoosePhoto";
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *pickerController = [UIImagePickerController new] ;
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [pickerController setDelegate:self];
        if (CoverORProfileORIMGPost == 1 || CoverORProfileORIMGPost == 2)
        {
            pickerController.allowsEditing=YES;
        }
        
        [self presentModalViewController:pickerController animated:YES]; 
    }
    else
    {
        DisplayAlertWithTitle(@"Note!!", @"Library is not available on your device");
        return;
    }
}

#pragma mark - TakeVideo ChooseVideo
-(void)TakeVideo:(NSString *)str
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {   
        AddViewFlag = 50;
        self.imgFlag = @"TakeVideo";
        
        UIImagePickerController *UIPiker = [[UIImagePickerController alloc]init];
        UIPiker.sourceType=UIImagePickerControllerSourceTypeCamera;
        UIPiker.delegate=self;
        UIPiker.mediaTypes =  [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        //UIPiker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        UIPiker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        UIPiker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        UIPiker.videoMaximumDuration=20;
        [self presentModalViewController:UIPiker animated:YES];
    }
    else
    {
        DisplayAlertWithTitle(@"Note!!", @"Camera is not available on your device");
        return;
    }
}
-(void)ChooseVideo:(NSString *)str
{
    AddViewFlag = 50;
    self.imgFlag = @"ChooseVideo";
    UIImagePickerController *piker = [[UIImagePickerController alloc]init];
    NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.movie",nil];
    [piker setMediaTypes:mediaTypesAllowed];
    piker.videoMaximumDuration=20;
    piker.delegate=self;
    [self presentModalViewController:piker animated:YES];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    AddViewFlag = 50;
    if ([self.imgFlag isEqualToString:@"TakePhoto"] ||
        [self.imgFlag isEqualToString:@"ChoosePhoto"])
    {
        UIImage *resultingImage;
        if (CoverORProfileORIMGPost==1 || CoverORProfileORIMGPost==2)
        {
            resultingImage= (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            resultingImage= (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        
        if (CoverORProfileORIMGPost == 1 || CoverORProfileORIMGPost == 2)
        {
            [picker dismissModalViewControllerAnimated:NO];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:resultingImage forKey:@"imgPost"];
            NSNotification *notif = [NSNotification notificationWithName:@"updateCoverPic" object:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else
        {
            if ([self.imgFlag isEqualToString:@"TakePhoto"])
            {
                // UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                // Request to save the image to camera roll
                [library writeImageToSavedPhotosAlbum:[resultingImage CGImage] orientation:(ALAssetOrientation)[resultingImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                    if (error) {
                    } else {
                        
                        void(^completion)(void)  = ^(void){
                            
                            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                if (asset){
                                    [self launchEditorWithAsset:asset];
                                }
                            } failureBlock:^(NSError *error) {
                                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            }];
                        };
                        [self dismissViewControllerAnimated:YES completion:completion];
                    }
                }];
            }
            else
            {
                NSURL  *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                
                void(^completion)(void)  = ^(void){
                    
                    [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        if (asset){
                            [self launchEditorWithAsset:asset];
                        }
                    } failureBlock:^(NSError *error) {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }];
                };
                [self dismissViewControllerAnimated:YES completion:completion];
            }
            
            
            // [picker dismissModalViewControllerAnimated:NO];
            //[self performSelector:@selector(NotiforIMGPost:) withObject:resultingImage afterDelay:0.5f];
        }
    }
    else if([self.imgFlag isEqualToString:@"TakeVideo"] ||
            [self.imgFlag isEqualToString:@"ChooseVideo"])
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        if ([mediaType isEqualToString:@"public.movie"])
        {
            NSURL *videoURL = [[info objectForKey:UIImagePickerControllerMediaURL] copy];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
            
            CMTime duration = playerItem.duration;
            float seconds = CMTimeGetSeconds(duration);
            if (abs(seconds)<=20)
            {
                if ([self.imgFlag isEqualToString:@"TakeVideo"])
                {
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
                    {
                        UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                    }
                }
                self.imgFlag = @"";
                [self dismissModalViewControllerAnimated:NO];
                [self performSelector:@selector(NotiforVideoPost:) withObject:videoURL afterDelay:0.5];
            }
            else
            {
                DisplayAlertWithTitle(@"Please Select Video Less Then 20 Sec.",@"");
                [picker dismissModalViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        [picker dismissModalViewControllerAnimated:YES];
    }
}


-(void)NotiforVideoPost:(NSURL *)url
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:url forKey:@"videoURL"];
    AddViewFlag = 4;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)NotiforIMGPost:(UIImage *)image
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:image forKey:@"imgToPost"];
    AddViewFlag = 7;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.imgFlag = @"";
    [self  dismissModalViewControllerAnimated:YES];    
}


#pragma mark - Music
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection 
{
    MPMediaItem *currentItem;
    currentItem=[mediaItemCollection.items objectAtIndex:0];
    NSString *strsongtitle   = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *strartist = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *stralbumtitle  = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    UIImage *artworkImage = [UIImage imageNamed:@"player.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    if(artwork)
    {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    NSMutableDictionary *musicdata = [[NSMutableDictionary alloc]init];
    [musicdata addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:strsongtitle,@"title",strartist,@"artist",stralbumtitle,@"albumtitle",artworkImage,@"artwork", nil]];
   
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:NO];
    [self performSelector:@selector(MuzinPost:) withObject:musicdata afterDelay:0.5];
}
-(void)MuzinPost :(NSMutableDictionary *)dict
{
    AddViewFlag = 500000;
    strPostSuccessful = @"PostOnly";
    PostViewController *objPost=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
    objPost.isMusicPostingView=YES;
    objPost.imgToPost = nil;
    objPost.muzikDict = [dict copy];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPost];
    [self presentModalViewController:navC animated:YES];
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissModalViewControllerAnimated:YES];
}


/*
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:NO];
    strPostSuccessful  =  @"PostImage";
    PostViewController *objPostViewController=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
    objPostViewController.imgToPost = [image copy];        
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPostViewController];
    [self presentModalViewController:navC animated:YES]; 
}
- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:YES];
}
*/

#pragma mark - Photo Editor Launch Methods New

- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage  *editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation  *representation = [asset defaultRepresentation];
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = [representation orientation];
    CGFloat scale = [representation scale];
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    AFPhotoEditorController  *photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
}
#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block HomeViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}
#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:NO];
    strPostSuccessful  =  @"PostImage";
    PostViewController *objPostViewController=[[PostViewController alloc]initWithNibName:@"PostViewController" bundle:nil];
    objPostViewController.imgToPost = [image copy];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:objPostViewController];
    [self presentModalViewController:navC animated:YES];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    AddViewFlag = 50;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Extra Methods
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
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}


@end
