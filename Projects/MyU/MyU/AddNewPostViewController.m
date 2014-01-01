//
//  AddNewPostViewController.m
//  MyU
//
//  Created by Vijay on 7/16/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "AddNewPostViewController.h"
#import "WSManager.h"
#import "UIImageView+WebCache.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"

@interface AddNewPostViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *imgPostBox;
    IBOutlet UITextView *txtPostBox;
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UILabel *lblWhatsNew;
    IBOutlet UIImageView *imgPost;
    UIImagePickerController *picker;
    IBOutlet UIImageView *imgProgress;
    IBOutlet UIImageView *imgProgressTop;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnPost;
    BOOL isPostUploading;
}
@end

@implementation AddNewPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    imgProfilePic.layer.cornerRadius=4.0;
    imgProfilePic.clipsToBounds=YES;
    [imgProfilePic setImageWithURL:[NSURL URLWithString:[strUserProfilePic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
    
    imgPostBox.image=[UIImage imageNamed:[NSString stringWithFormat:@"bg_newpost%@.png",iPhone5ImageSuffix]];
    txtPostBox.textColor=[UIColor darkGrayColor];
    
    [self performSelector:@selector(openkeyboard)];
    [self performSelector:@selector(allocpicker) withObject:nil afterDelay:1.0];
    
    imgProgress.hidden=YES;
    imgProgressTop.hidden=YES;
}
-(void)openkeyboard
{
    [txtPostBox becomeFirstResponder];
}
-(void)allocpicker
{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
}
-(IBAction)btnPostClicked:(id)sender
{
//    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
//    overlay.animation = MTStatusBarOverlayAnimationShrink;  // MTStatusBarOverlayAnimationShrink
//    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
//    //overlay.delegate = self;
//    overlay.progress = 0.0;
//    [overlay postMessage:@"Following @myell0w on Twitter…"];
//    overlay.progress = 0.1;
//    // ...
//    [overlay postMessage:@"Following myell0w on Github…" animated:NO];
//    overlay.progress = 0.5;
//    // ...
//    [overlay postImmediateFinishMessage:@"Following was a good idea!" duration:2.0 animated:YES];
//    overlay.progress = 1.0;

    
    //[txtPostBox resignFirstResponder];
    
    //[[MyAppManager sharedManager]showSpinnerInView:self.view];
    //[[MyAppManager sharedManager]showLoaderInMainThread];
    
    UIImage *image = [self imageReduceSize:[UIScreen mainScreen].bounds.size:imgPost.image];
    NSData *dataF = UIImagePNGRepresentation(image);
    
    if (([[txtPostBox.text removeNull] length]==0) && ([dataF length]==0)) {
        kGRAlert(@"Please add text/image.");
    }
    else
    {
        btnBack.enabled=NO;
        btnPost.enabled=NO;
        //self.view.userInteractionEnabled=NO;
        isPostUploading=YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self performSelector:@selector(postthenews) withObject:nil afterDelay:0.4];
    }
}

-(void)postthenews
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strUserUniId,@"uni_id",[txtPostBox.text removeNull],@"news_description",nil];
    
    NSData *dataF2 = UIImagePNGRepresentation([imgPost.image scaleAndRotateImage]);
    NSLog(@"%lu",(unsigned long)[dataF2 length]);
    
    UIImage *image = [self imageReduceSize:[UIScreen mainScreen].bounds.size:imgPost.image];
    NSData *dataF = UIImagePNGRepresentation(image);
    NSLog(@"%lu",(unsigned long)[dataF length]);
    
    imgProgress.hidden=NO;
    imgProgressTop.hidden=NO;

    float progress=0.0;
    imgProgress.frame=CGRectMake(0, 44+iOS7, 320.0*progress, 3);
    imgProgressTop.frame=CGRectMake((320.0*progress)-2.0, 42.0+iOS7, 8.0, 6.0);
    
    NSDictionary *dictData=[[NSDictionary alloc]initWithObjectsAndKeys:dataF,@"news_image",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAddPostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:(imgPost.image)?dictData:nil withsucessHandler:@selector(newpostadded:) withfailureHandler:@selector(newpostfailed:) withCallBackObject:self];
    obj.shouldShowProgress=YES;
    [obj startRequest];
}

- (UIImage *)imageReduceSize:(CGSize)newSize :(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = newSize.width/newSize.height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = newSize.height / actualHeight;
            actualWidth = imgRatio* actualWidth;
            actualHeight = newSize.height;
        }
        else{
            imgRatio = newSize.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = newSize.width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)newpostadded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([dictResponse objectForKey:@"progress"])
    {
        //NSLog(@"The New Progress:%@",[dictResponse objectForKey:@"progress"]);
        float progress=[[dictResponse objectForKey:@"progress"] floatValue];
        
        if (progress>0.98)
        {
            progress=0.98;
        }
        
        imgProgress.frame=CGRectMake(0, 44+iOS7, 320.0*progress, 3);
        imgProgressTop.frame=CGRectMake((320.0*progress)-4.0, 42.5+iOS7, 8.0, 6.0);
    }
    else
    {
        //[[MyAppManager sharedManager]hideLoader];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        isPostUploading=NO;

        if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
        {
            [self performSelector:@selector(exitfromview) withObject:nil afterDelay:0.1];
        }
        else
        {
            imgProgress.hidden=YES;
            imgProgressTop.hidden=YES;
            btnBack.enabled=YES;
            btnPost.enabled=YES;
            self.view.userInteractionEnabled=YES;
            
            NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
            if ([[strErrorMessage removeNull] length]>0) {
                kGRAlert([strErrorMessage removeNull])
            }
        }
    }
}
-(void)newpostfailed:(id)sender
{
    isPostUploading=NO;
    //[[MyAppManager sharedManager]hideLoader];
    imgProgress.hidden=YES;
    imgProgress.hidden=YES;
    btnBack.enabled=YES;
    btnPost.enabled=YES;
    self.view.userInteractionEnabled=YES;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)exitfromview
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
	[self dismissViewControllerAnimated:NO completion:^{}];
}

-(IBAction)btnLibraryClicked:(id)sender
{
    if (!isPostUploading)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}
-(IBAction)btnCameraClicked:(id)sender
{
    if (!isPostUploading)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            kGRAlert(@"\nThis device doesn't contain\ncamera.");
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    //UIImage *resultingImage = (1)?[info objectForKey:UIImagePickerControllerEditedImage]:[info objectForKey:UIImagePickerControllerEditedImage];
    imgPost.image=[info objectForKey:UIImagePickerControllerOriginalImage];
	[self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)pickers
{
	[pickers dismissViewControllerAnimated:YES completion:^{}];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (isPostUploading)
    {
        return NO;
    }
    
    lblWhatsNew.alpha=(range.location>0 || text.length!=0)?0.0:1.0;
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lblWhatsNew.alpha=(textView.text.length!=0)?0.0:1.0;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    lblWhatsNew.alpha=(textView.text.length!=0)?0.0:1.0;
}

-(IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
	[self dismissViewControllerAnimated:NO completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
