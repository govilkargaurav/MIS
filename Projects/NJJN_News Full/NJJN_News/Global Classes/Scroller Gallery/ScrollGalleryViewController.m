//
//  ScrollGalleryViewController.m
//  NJJN_News
//
//  Created by Mac-i7 on 7/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "ScrollGalleryViewController.h"

@interface ScrollGalleryViewController ()

@end

@implementation ScrollGalleryViewController

@synthesize arrayGalleryData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    indexclick = 0;
    
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
        scrollMainObj.frame = CGRectMake(0, 0, 768, 1004);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
        scrollMainObj.frame = CGRectMake(0, 0, 1024, 748);
    }
    scrollMainObj.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if ([arrayGalleryData count]>0)
    {
        scrollMainObj.userInteractionEnabled = TRUE;
        [self LoadGalleryImages];
        [self CallCountImg];
    }
    else
    {
        scrollMainObj.userInteractionEnabled = FALSE;
        DisplayAlertWithTitle(App_Name, @"There are no images in gallery.");
        return;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadGalleryImages
{
 
    //[arrayGalleryData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    // {
    
    UIImageView *imgViewAdded = (UIImageView*)[scrollMainObj viewWithTag:indexclick + 10];
    if (![scrollMainObj.subviews containsObject:imgViewAdded])
    {
        UIImageView* imgView = [[UIImageView alloc]init];
        
        if(flagOrientation == 0)
        {
            imgView.frame = CGRectMake(768*indexclick, 0, 768, 1004);
        }
        else
        {
            imgView.frame = CGRectMake(1024*indexclick, 0, 1024, 748);
        }
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = indexclick+10;
        imgView.userInteractionEnabled=YES;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [imgView setImageWithURL:[NSURL URLWithString:[[[arrayGalleryData objectAtIndex:indexclick] valueForKey:@"vImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
         }];
        
        [scrollMainObj addSubview:imgView];
    }
    
    // }];
    
    scrollMainObj.pagingEnabled = YES;
    if(flagOrientation == 0)
    {
        [scrollMainObj setContentSize:CGSizeMake(768 * arrayGalleryData.count, 1004)];
    }
    else
    {
        [scrollMainObj setContentSize:CGSizeMake(1024 * arrayGalleryData.count, 748)];
    }
}

-(void)ReframeAllContent
{
    [scrollMainObj.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         UIImageView* imgView = [scrollMainObj.subviews objectAtIndex:idx];
         if(flagOrientation == 0)
         {
             imgView.frame = CGRectMake(768*(imgView.tag - 10), 0, 768, 1004);
         }
         else
         {
             imgView.frame = CGRectMake(1024*(imgView.tag - 10), 0, 1024, 748);
         }
    }];
    
    int scrlWidth;
    if(flagOrientation == 0)
    {
       scrlWidth = 768;
       [scrollMainObj setContentSize:CGSizeMake(768 * arrayGalleryData.count, 1004)];
    }
    else
    {
        scrlWidth = 1024;
        [scrollMainObj setContentSize:CGSizeMake(1024 * arrayGalleryData.count, 748)];
    }
    
    [scrollMainObj setContentOffset:CGPointMake(indexclick * scrlWidth, 0)];
    
    scrollMainObj.alpha = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int scrlWidth;
    if(flagOrientation == 0)
    {
        scrlWidth = 768;
    }
    else
    {
        scrlWidth = 1024;
    }
    indexclick = scrollMainObj.contentOffset.x /  scrlWidth;
    if (indexclick < [arrayGalleryData count])
    {
        [self LoadGalleryImages];
    }
    [self CallCountImg];
}

-(void)CallCountImg
{
    lblTitle.text=[NSString stringWithFormat:@"%d of %d",indexclick + 1,[arrayGalleryData count]];
}

-(void)Back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
        scrollMainObj.frame = CGRectMake(0, 0, 768, 1004);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
        scrollMainObj.frame = CGRectMake(0, 0, 1024, 748);
    }
	return YES;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    return orientations;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    scrollMainObj.alpha = 0.0;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
        scrollMainObj.frame = CGRectMake(0, 0, 768, 1004);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
        scrollMainObj.frame = CGRectMake(0, 0, 1024, 748);
    }
    [self ReframeAllContent];
    
}







@end
