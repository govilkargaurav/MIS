//
//  Gallery.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gallery.h"
#import "AppConstat.h"
#import "ASIFormDataRequest.h"
#import "BusyAgent.h"
#import "PhotoScrollViewCtr.h"
#import "ImageViewURL.h"

#pragma mark - Keyboard Display Declaration

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
// adjust this following value to account for the height of your toolbar, too
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation Gallery
@synthesize request;
CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    CALayer *l=[txtImgDesc layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor clearColor] CGColor];
    l.backgroundColor=[[UIColor whiteColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
	[self.view addSubview:toolBar];  
    
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressedResign)];
    
	NSArray *buttons = [NSArray arrayWithObjects:item2, nil];
    [toolBar setItems: buttons animated:NO];
    
    [UIView commitAnimations];
    [super viewDidLoad];
}
-(void)CallURL
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    resultsGallery=[[NSDictionary alloc]init];
    NSString *strLogin=[NSString stringWithFormat:@"%@webservices/gallery.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
}
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    resultsGallery = [responseString JSONValue];
    if ([resultsGallery count] >=1)
    {
        ImageViewURL *x=[[ImageViewURL alloc] init];
        x.imgV=imgupload;
        x.strUrl=[NSURL URLWithString:[[[resultsGallery valueForKey:@"gallery"] objectAtIndex:0]  valueForKey:@"vGalleryImg"]];
    }
}
-(IBAction)btnAddImagePressed:(id)sender
{
    if ([[resultsGallery valueForKey:@"gallery"] count] >= 5)
    {
        DisplayAlertWithTitle(APP_Name, @"The maximum upload limit of 5 images is reached,so you can not add more.");
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Choose from library" otherButtonTitles:@"Take from camera", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        [sheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) 
    {
        return; 
    }
    else
    {
        if (buttonIndex == 0 || buttonIndex == 1)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if(buttonIndex == 0)
            {
                if([UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else if (buttonIndex == 1)
            {
                if([UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypeCamera])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                }
            }
            NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.image",nil];
            [imagePicker setMediaTypes:mediaTypesAllowed];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.wantsFullScreenLayout=TRUE;
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        imgdata = [[NSData alloc]init];
        imgdata = [NSData dataWithData:UIImagePNGRepresentation([self scaleAndRotateImage:img])];
        imgupload.image = [UIImage imageWithData:imgdata];
        double byte = [imgdata length];
        double fixFloat = 5242880;
        if (byte > fixFloat)
        {
            if (imgdata!=Nil)
            {
                imgdata=nil;
                imgdata = [[NSData alloc]init];
            }
            float actualHeight = imgupload.image.size.height;
            float actualWidth = imgupload.image.size.width;
            float imgRatio = actualWidth/actualHeight;
            float maxRatio = 320.0/400.0;
            
            if(imgRatio!=maxRatio){
                if(imgRatio < maxRatio){
                    imgRatio = 400.0 / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = 400.0;
                }
                else{
                    imgRatio = 320.0 / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = 320.0;
                }
            }
            CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
            UIGraphicsBeginImageContext(rect.size);
            [imgupload.image drawInRect:rect];
            imgupload.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //imgupload.image = [imgupload.image resizedImageToSize:CGSizeMake(800 , 600)];
            imgdata = [NSData dataWithData:UIImagePNGRepresentation([self scaleAndRotateImage:img])];
        }
    }
    strSet = @"No";

    [picker dismissModalViewControllerAnimated:YES];
    
    
    // [self callThumbnail];
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
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
/*
 float actualHeight = image.size.height;
 float actualWidth = image.size.width;
 float imgRatio = actualWidth/actualHeight;
 float maxRatio = 320.0/480.0;
 
 if(imgRatio!=maxRatio){
 if(imgRatio < maxRatio){
 imgRatio = 480.0 / actualHeight;
 actualWidth = imgRatio * actualWidth;
 actualHeight = 480.0;
 }
 else{
 imgRatio = 320.0 / actualWidth;
 actualHeight = imgRatio * actualHeight;
 actualWidth = 320.0;
 }
 }
 CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
 UIGraphicsBeginImageContext(rect.size);
 [image drawInRect:rect];
 UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    strSet = @"No";
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([strSet isEqualToString:@"No"])
    {
        strSet = @"Yes";
    }
    else
    {
        [self CallURL];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Dealloc


#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)uploadClicked:(id)sender
{
    if ([imgdata length] > 0) 
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@webservices/upload_image.php",APP_URL];
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]]];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"] forKey:@"iUserID"];
        [request setPostValue:txtImgDesc.text forKey:@"vDescription"];
        //  [request setTimeOutSeconds:20];
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        [request setShouldContinueWhenAppEntersBackground:YES];
        #endif
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(uploadFinished:)];
        [request setDidFailSelector:@selector(uploadFailed:)];
        [request setData:imgdata withFileName:@".png" andContentType:@"image/png" forKey:@"vImage"];   
        [request startAsynchronous];
    }
    else
    {
        DisplayAlertWithTitle(APP_Name, @"Please select image first");
    }
}
- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    NSString *responseString1 = [theRequest responseString];
    NSDictionary *Dic = [responseString1 JSONValue];
    NSString *strmsg = [Dic valueForKey:@"msg"];
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    imgdata=nil;
    imgupload.image=[UIImage imageNamed:@"ImgUserBack.png"];
    txtImgDesc.text = @"";
    [self CallURL];
    DisplayAlertWithTitle(APP_Name, strmsg);
    
}
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    //   NSLog(@"Request failed:\r\n%@",[[theRequest error] localizedDescription]);
    DisplayAlertWithTitle(APP_Name, [[theRequest error] localizedDescription]);
}
-(IBAction)btnViewGalleryPressed:(id)sender
{
    if ([[resultsGallery valueForKey:@"gallery"] count] > 0)
    {
        PhotoScrollViewCtr *obj_PhotoScrollViewCtr = [[PhotoScrollViewCtr alloc]initWithNibName:@"PhotoScrollViewCtr" bundle:nil];
        obj_PhotoScrollViewCtr.DicPhoto = resultsGallery;
        [self.navigationController pushViewController:obj_PhotoScrollViewCtr animated:YES];
        obj_PhotoScrollViewCtr = nil;
    }
    else
    {
         DisplayAlertWithTitle(APP_Name, @"No images are added.");
    }
}

#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    CGRect textVWRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    toolBar.frame=CGRectMake(0,362, 320, 44);   
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
-(void)DonePressedResign
{
    [txtImgDesc resignFirstResponder];
}
#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
