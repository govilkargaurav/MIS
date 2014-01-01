//
//  PhotoZoomViewController.m
//  Suvi
//
//  Created by Gagan on 4/15/13.
//
//

#import "PhotoZoomViewController.h"
#import "Global.h"
#import "UIImageView+WebCache.h"

@interface UINavigationController (Rotation_IOS6)
@end

@implementation UINavigationController (Rotation_IOS6)

- (BOOL) shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}
- (NSUInteger) supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
@end

@interface PhotoZoomViewController ()
{
    IBOutlet UIImageView *imgV;
}
@end

@implementation PhotoZoomViewController
@synthesize imgURL,isLocal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)btndone:(id)sender
{
    AddViewFlag = 50;
    [self performSelector:@selector(dismisstheview) withObject:nil];
}

-(void)dismisstheview
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    NSString *strURL=[NSString stringWithFormat:@"%@",self.imgURL];
    isLocal=!([strURL hasPrefix:@"http:"]);

    if (isLocal)
    {
        imgV.image=[UIImage imageWithContentsOfFile:[strURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        NSRange domainRange = [strURL rangeOfString:@"/admin/files/photogallary"];
        NSRange domainRange2 = [strURL rangeOfString:@"/admin/files/music"];
        if((domainRange.length==0) && (domainRange2.length==0))
        {
           // [imgV setImageWithURL: placeholderImage:];

            [imgV setImageWithURL:[NSURL URLWithString:[strURL stringByReplacingOccurrencesOfString:@"/admin/files" withString:@"/admin/files/hd"]] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageProgressiveDownload];
        }
        else
        {
            [imgV setImageWithURL:self.imgURL placeholderImage:[UIImage imageNamed:@"sync.png"]];
        }
    }
}

- (NSUInteger) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationPortraitUpsideDown;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    imgV = nil;
    [super viewDidUnload];
}
@end
