//
//  ChangePhotoViewCtr.m
//  MyMites
//
//  Created by Apple-Openxcell on 9/26/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "ChangePhotoViewCtr.h"
#import "ImageViewURL.h"
#import "AppConstat.h"
#import "ASIFormDataRequest.h"
#import "BusyAgent.h"
#import "JSON.h"

@implementation ChangePhotoViewCtr
@synthesize strProfileLink;
@synthesize request;

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
    
    ImageViewURL *x=[[ImageViewURL alloc] init];
    x.imgV=imgProfile;
	x.strUrl=[NSURL URLWithString:strProfileLink];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - IBAction Methods

-(IBAction)Back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)btnChoosePressed:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_Name delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Choose from library",@"Take from camera",@"Cancel", nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    sheet.destructiveButtonIndex = 2;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
-(IBAction)btnSavePressed:(id)sender
{
    if ([imgdata length] > 0) 
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@webservices/update_profile_picture.php",APP_URL];
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]]];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"] forKey:@"iUserID"];
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
    DisplayAlertWithTitle(APP_Name, strmsg);
    
}
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    //   NSLog(@"Request failed:\r\n%@",[[theRequest error] localizedDescription]);
    DisplayAlertWithTitle(APP_Name, [[theRequest error] localizedDescription]);
}
#pragma mark - ActionSheet Delegates Methods

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
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
        NSArray *mediaTypesAllowed = [NSArray arrayWithObject:@"public.image"];
        [imagePicker setMediaTypes:mediaTypesAllowed];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.wantsFullScreenLayout=TRUE;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else if (buttonIndex == 2)
    {
        return;
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    imgProfile.image = img;
    imgdata = [[NSData alloc]init];
    imgdata = [NSData dataWithData:UIImagePNGRepresentation([self scaleAndRotateImage:img])];
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
