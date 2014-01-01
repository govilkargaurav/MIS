//
//  ImageZoomViewController.m
//  OBVENT
//
//  Created by W@rrior on 18/03/13.
//  Copyright (c) 2013 W@rrior. All rights reserved.
//

#import "ImageZoomViewController.h"
#import "UIImageView+WebCache.h"
#import "UIScrollViewEvent.h"
#import "NSString+Utilities.h"
#import "WSManager.h"
#import "BlogFeed.h"
#import "NewsFeed.h"

#define PADDING  10
@interface ImageZoomViewController () <UIAlertViewDelegate>

@end

@implementation ImageZoomViewController
@synthesize selectedindex,phototype;

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
    
    self.navigationController.navigationBarHidden = YES;
    //KEYBOARD OBSERVERS
    /************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    switch (phototype) {
        case PhotoTypeBlog:
        {
            lblLikeCount.text=[[[arrHome objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
            BOOL shouldLike=([[[arrHome objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
            [btnLike setTitle:(shouldLike)?@"Like":@"Unlike" forState:UIControlStateNormal];
        }
            break;
            
        case PhotoTypeNews:
        {
            lblLikeCount.text=[[[arrNews objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
            BOOL shouldLike=([[[arrNews objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
            [btnLike setTitle:(shouldLike)?@"Like":@"Unlike" forState:UIControlStateNormal];
        }
            break;
            
        case PhotoTypeProfilePosts:
        {
            lblLikeCount.text=[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
            BOOL shouldLike=([[[arrPosts objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
            [btnLike setTitle:(shouldLike)?@"Like":@"Unlike" forState:UIControlStateNormal];
        }
            break;
            
        case PhotoTypeNotification:
        {
            lblLikeCount.text=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"like_count"] removeNull];
            BOOL shouldLike=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
            [btnLike setTitle:(shouldLike)?@"Like":@"Unlike" forState:UIControlStateNormal];
        }
            break;
        
        case PhotoTypeProfilePic:
        {
            bottomView.hidden=YES;
        }
            break;

            
        default:
            break;
    }
    
    [self scrollViewSetup];
    
    UILongPressGestureRecognizer *longPressPhoto = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleLongPressWall:)];
    longPressPhoto.minimumPressDuration = 1;
    [Scl_Photo addGestureRecognizer:longPressPhoto];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setDelaysTouchesBegan : YES];
    [Scl_Photo addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelaysTouchesBegan : YES];
    [Scl_Photo addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail : doubleTap];
    
    UISwipeGestureRecognizer *swipe_Down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipe_Down.direction = UISwipeGestureRecognizerDirectionDown;
    [Scl_Photo addGestureRecognizer:swipe_Down];
    [self updatereadcount];
}
#pragma mark - Like Tapped
-(void)updatereadcount
{
    if (isAppInGuestMode) {
        return;
    }
    
    if (phototype==PhotoTypeProfilePic)
    {
        return;
    }
    
    switch (phototype) {
        case PhotoTypeBlog:
        {
            BOOL shouldUpdate=([[[arrHome objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id", nil];
                [[arrHome objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }

        }
            break;
            
        case PhotoTypeNews:
        {
            BOOL shouldUpdate=([[[arrNews objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                [[arrNews objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }

        }
            break;
            
        case PhotoTypeProfilePosts:
        {
            BOOL shouldUpdate=([[[arrPosts objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                [[arrPosts objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
            
        }
            break;
            
        case PhotoTypeNotification:
        {
            BOOL shouldUpdate=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"id"],@"news_id", nil];
                [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
            
        }
            break;

            
        default:
            break;
    }
}
-(IBAction)btnLikeClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    switch (phototype) {
        case PhotoTypeBlog:
        {
            BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:selectedindex];
            
            BOOL shouldLike=objBlog.canLike;
            NSInteger likecount=[objBlog.strLikeCount integerValue];

            [btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
            lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            
            [[arrHome objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
            [[arrHome objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
            
            objBlog.canLike=!shouldLike;
            objBlog.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            [arrHomeModel replaceObjectAtIndex:selectedindex withObject:objBlog];
            
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id", nil];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kBlogLikeURL:kBlogDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
            [obj startRequest];
        }
            break;
            
        case PhotoTypeNews:
        {
            NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:selectedindex];
            
            BOOL shouldLike=objNews.canLike;
            NSInteger likecount=[objNews.strLikeCount integerValue];
            
            [btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
            lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            
            [[arrNews objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
            [[arrNews objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
            
            objNews.canLike=!shouldLike;
            objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            [arrNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
            
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
            [obj startRequest];
        }
            break;
            
            
        case PhotoTypeProfilePosts:
        {
            NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
            
            BOOL shouldLike=objNews.canLike;
            NSInteger likecount=[objNews.strLikeCount integerValue];
            
            [btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
            lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            
            [[arrPosts objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
            [[arrPosts objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
            
            objNews.canLike=!shouldLike;
            objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
            
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
            [obj startRequest];
        }
            break;
            
        case PhotoTypeNotification:
        {
            
            BOOL shouldLike=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
            NSInteger likecount=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"like_count"] removeNull] integerValue];
            
            [btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
            lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
            
            [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
            [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
                        
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"id"],@"news_id", nil];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
            [obj startRequest];
        }
            break;
            
        default:
            break;
    }
}
-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    CGRect keyboardRect = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
}
-(void)keyboardWillHide:(NSNotification*)notification {
    _keyboardHeight = 0.0;
}
-(void)alertIfGuestMode
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Guest Mode" message:kGuestPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-Up", nil];
    alert.tag=24;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==24)
    {
        if (buttonIndex==1)
        {
            shouldInviteToSignUp=YES;
            [self dismissViewControllerAnimated:NO completion:Nil];
        }
    }
}

#pragma mark - Double Tap
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if(Scl_Photo.zoomScale > Scl_Photo.minimumZoomScale)
        [Scl_Photo setZoomScale:Scl_Photo.minimumZoomScale animated:YES];
    else
        [Scl_Photo setZoomScale:Scl_Photo.maximumZoomScale animated:YES];
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (bottomView.alpha == 1.0f)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1f];
        bottomView.alpha = 0.0f;
        btnDone.alpha = 0.0f;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1f];
        bottomView.alpha = 1.0f;
        btnDone.alpha = 1.0f;
        [UIView commitAnimations];
    }
}
- (void)scrollViewSetup
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    // supports iPhone 5 screen size
    Scl_Photo.frame = screenFrame;
    
    Scl_Photo.contentSize = [self contentSizeForscrollView];
    Scl_Photo.maximumZoomScale = 5.;
    Scl_Photo.minimumZoomScale = 1;
    
    LoadImage = YES;
    imgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.tag = 1;
    imgView.userInteractionEnabled=YES;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    Scl_Photo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  
    // @Fix: Allows scrolling for different sized images
    Scl_Photo.zoomScale = 1.1;
    Scl_Photo.zoomScale = 1.0;
    ((UIScrollViewEvent*)Scl_Photo).imgView = imgView;
    [Scl_Photo addSubview:imgView];
    
    //[self.view bringSubviewToFront:bottomView];
    [Scl_Photo setNeedsDisplay];
    [self.view setNeedsDisplay];
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)contentSizeForscrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = Scl_Photo.bounds;
    return CGSizeMake(bounds.size.width + PADDING, bounds.size.height + PADDING);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imgView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setThumbsAndCommentCountAndImage];
}

- (void)layoutSubviews {
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = Scl_Photo.bounds.size;
    CGRect frameToCenter = imgView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    imgView.frame = frameToCenter;
}

-(void)handleLongPressWall:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:kAppName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save photo to album", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        sheet.tag = 1;
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
        //Do Whatever You want on Began of Gesture
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //Do Whatever You want on End of Gesture
    }
}
-(void)swipeDown:(UISwipeGestureRecognizer*)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self performSelector:@selector(saveimagetoalbum) withObject:nil afterDelay:0.0];
        }
        else if (buttonIndex == 1)
        {
            return;
        }
    }
}
-(void)saveimagetoalbum
{
    UIImageWriteToSavedPhotosAlbum(imgView.image, self, nil, nil);
}

-(void)setThumbsAndCommentCountAndImage
{
    if (LoadImage)
    {
        __block ImageZoomViewController *imgdet = self;
        ActivityPhoto.hidden = NO;
        [ActivityPhoto startAnimating];
        NSURL *imageURL = [NSURL URLWithString:self.strURL];
        if (![self.strURL isEqualToString:@""] || imageURL != nil)
        {
            [imgView setImageWithURL:imageURL placeholderImage:Nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
            {
                imgdet->imgView.image = image;
                [imgdet HideAnimating];
            }];
        }
        LoadImage = NO;
    }
}
-(void)HideAnimating
{
    [Scl_Photo setZoomScale:Scl_Photo.maximumZoomScale animated:NO];
    [Scl_Photo setZoomScale:Scl_Photo.minimumZoomScale animated:NO];
    [ActivityPhoto stopAnimating];
     ActivityPhoto.hidden = YES;
}
#pragma mark - URLManager Delegete Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(IBAction)btnDonePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
