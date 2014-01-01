//
//  AlbumViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"
#import "CommentCell.h"
#import "UIImage+Scale.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "ProfileViewController.h"
#import "GalleryViewController.h"

@interface AlbumViewController ()

- (NSInteger)getTagFromPicture:(Picture *)picture;
- (NSString *)getCoredataIDFromImageID:(NSString *)imgID;
- (void)imageTapped:(id)sender;
- (void)setPictureAtIndex:(NSInteger)index isCurrentIndex:(BOOL)isCurrentIndex;
- (void)getImageInfo:(NSString *)imageID;
- (void)findLocation:(NSString *)location;
- (void)addLocation:(NSDictionary *)params;
@end

@implementation AlbumViewController

@synthesize pic;
@synthesize picArray;
@synthesize scrollVw;
@synthesize btnLike;
@synthesize lblLikes;
@synthesize lblComment;
@synthesize btnComment;
@synthesize btnShare;
@synthesize delegate;
@synthesize lblDesc;
@synthesize profilePic;
@synthesize btnName;
@synthesize isLikeBtnSelected,gotoCommentView;

@synthesize comeFromView;

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
	// Do any additional setup after loading the view.

    if (IS_IPHONE_5) {
        
        viewNavigation.frame=CGRectMake(0, 0, 320, 44);
    }
    
    isCommentViewLoading = NO;
    scrollViewArray = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)] autorelease];
    gesture.numberOfTapsRequired = 2;
    [scrollVw addGestureRecognizer:gesture];
    
    commentController = [[self.storyboard instantiateViewControllerWithIdentifier:@"CommentScreen"] retain];
    [commentController setDelegate:self];
    [commentController.view setFrame:CGRectMake(0, 0, 320, 460)];
    
    lblDesc.text = pic.caption;
    btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (!pic.album)
    {
        [profilePic setImageWithURL:[Utility getProfilePicURL:[[pic.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]]];
        [btnName setTitle:[[pic.user_desc componentsSeparatedByString:@":"]lastObject] forState:UIControlStateNormal];
        [btnName setTitle:[[pic.user_desc componentsSeparatedByString:@":"]lastObject] forState:UIControlStateHighlighted];
        [btnName setTag:[[[pic.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]intValue]];
        [profilePic setTag:[[[pic.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]intValue]];
    }
    else
    {
        [btnName setTitle:pic.album.user_profile.name forState:UIControlStateNormal];
        [btnName setTitle:pic.album.user_profile.name forState:UIControlStateHighlighted];
        if (!pic.album.user_profile.picture)
            [profilePic setImageWithProfile:pic.album.user_profile];
        else {
            [profilePic setImage:[UIImage imageWithData:pic.album.user_profile.picture] forState:UIControlStateNormal];
            [profilePic setImage:[UIImage imageWithData:pic.album.user_profile.picture] forState:UIControlStateHighlighted];
        }
        [btnName setTag:pic.album.user_profile.user_id.intValue];
        [profilePic setTag:pic.album.user_profile.user_id.intValue];
    }
    if ([[DAL sharedInstance] isFavLocation:pic.location])
    {
        btnLocation.tag = 1;
        [btnLocation setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    else 
    {
        btnLocation.tag = 0;
        [btnLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (pic.location && ![pic.location isEmptyString])
    {
        [btnLocation setTitle:[pic.location stringByReplacingOccurrencesOfString:@";" withString:@","] forState:UIControlStateNormal];
        [btnLocation setTitle:[pic.location stringByReplacingOccurrencesOfString:@";" withString:@","] forState:UIControlStateHighlighted];
    }
    else {
        [btnLocation setTitle:@" " forState:UIControlStateNormal];
        [btnLocation setTitle:@" " forState:UIControlStateHighlighted];
    }
    ///***********************//////////
    int ind = 0;
    CGPoint point= CGPointMake(0, 0);
    for (Picture *picture in picArray)
    {
        int tag = [self getTagFromPicture:picture];
        if ([pic.pic_id isEqualToString:picture.pic_id])
        {
            [self getImageInfo:[NSString stringWithFormat:@"%d",tag]];
            point = CGPointMake(ind*320, 0);
            [btnComment setTag:tag];
            [btnLike setTag:tag];
            [btnShare setTag:tag];
            selectedIndex = [[NSNumber alloc] initWithInt:ind];

        }
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ind*320, 0, 320, 460)];
        [scrollViewArray addObject:scrollView];
        [self.scrollVw addSubview:scrollView];
        
        ind ++;
        
    }
    
        
    [self.scrollVw setContentSize:CGSizeMake([picArray count] *320, 460)];
    [self.scrollVw setContentOffset:point];
     //////////***************///////////////////
    
    currentImage = [pic retain];
    lblLikes.text = [NSString stringWithFormat:@"%d",[pic.likes_count intValue]];
    lblComment.text = [NSString stringWithFormat:@"%d",[pic.comments_count intValue]];
    [self.navigationItem setHidesBackButton:YES];
    
    if(gotoCommentView)
    {
        if (self.isLikeBtnSelected)
        {
            [self like:btnLike];
        }
        else {
            [self comment:btnComment];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!viewHasAppeared)
    {
        viewHasAppeared = YES;
        [self setPictureAtIndex:[selectedIndex intValue] isCurrentIndex:YES];
        if ([selectedIndex intValue]>0)
            [self setPictureAtIndex:[selectedIndex intValue]-1 isCurrentIndex:NO];
        if ([selectedIndex intValue]<([picArray count]-1))
            [self setPictureAtIndex:[selectedIndex intValue]+1 isCurrentIndex:NO];
        RELEASE_SAFELY(selectedIndex);
    }
}

- (void)viewDidUnload
{
    [self setScrollVw:nil];
    
    [self setBtnLike:nil];
    [self setLblLikes:nil];
    [self setBtnComment:nil];
    [self setLblComment:nil];
    [self setBtnShare:nil];
    [footerView release];
    footerView = nil;
    [self setBtnName:nil];
    [self setLblDesc:nil];
    [self setProfilePic:nil];
    [btnLocation release];
    btnLocation = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    RELEASE_SAFELY(selectedIndex);
    RELEASE_SAFELY(imageIDLiked);
    if(findLocation)
    {
        findLocation.delegate = nil;
        RELEASE_SAFELY(findLocation);
    }
    if(addLocation)
    {
        addLocation.delegate = nil;
        RELEASE_SAFELY(addLocation);
    }
    if(likeRequest)
    {
        likeRequest.delegate = nil;
        RELEASE_SAFELY(likeRequest);
    }
    if(delLocRequest)
    {
        delLocRequest.delegate = nil;
        RELEASE_SAFELY(delLocRequest);
    }

    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    RELEASE_SAFELY(commentController);
    RELEASE_SAFELY(currentImage);
    for (NSObject *obj in scrollViewArray) {
        RELEASE_SAFELY(obj);
    }
    RELEASE_SAFELY(scrollViewArray);
    RELEASE_SAFELY(picArray);
    pic = nil;
    [scrollVw release];
    
    [btnLike release];
    [lblLikes release];
    [btnComment release];
    [lblComment release];
    [btnShare release];
    
    [footerView release];
    [btnName release];
    [lblDesc release];
    [profilePic release];
    [btnLocation release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView !=scrollVw)
    {
        return [scrollView viewWithTag:999];
    }
    else
        return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if (scrollView!=scrollVw)
    {
        [scrollView setContentSize:((UIImageView *)[scrollView.delegate viewForZoomingInScrollView:scrollVw]).image.size];
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
    if (scrollView!=scrollVw)
    {
        CGPoint point = scrollView.contentOffset;
        DLog(@"%f----%f",point.x,point.y);
        CGPoint cntre = scrollView.center;
        DLog(@"%f----%f",cntre.x,cntre.y);
        //scrollView.contentSize = CGSizeMake(320, 460);
        [scrollView setContentOffset:point];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView
{
    if (ascrollView == scrollVw)
    {
        float x = ascrollView.contentOffset.x;
        NSInteger currentIndex = (x)/320;
        
        Picture *picture = ((Picture *)[picArray objectAtIndex:currentIndex]);
        int tag = [self getTagFromPicture:picture];
        if ([currentImage.image_url isEqualToString:picture.image_url])
            pageChanged = NO;
        else
            pageChanged = YES;
        if (pageChanged)
        {
            gotoCommentView = NO;
            [self getImageInfo:[NSString stringWithFormat:@"%d",tag]];
            [self setPictureAtIndex:currentIndex isCurrentIndex:YES];
            if (currentIndex>0)
                [self setPictureAtIndex:currentIndex-1 isCurrentIndex:NO];
            if (currentIndex<([picArray count]-1))
                [self setPictureAtIndex:currentIndex+1 isCurrentIndex:NO];
        }
        [btnComment setTag:tag];
        [btnLike setTag:tag];
        [btnShare setTag:tag];
        RELEASE_SAFELY(currentImage);
        currentImage = [picture retain];
        
        
        
        
        self.lblLikes.text = [NSString stringWithFormat:@"%d",[picture.likes_count intValue]];
        self.lblComment.text = [NSString stringWithFormat:@"%d",[picture.comments_count intValue]];
        
        
        // change header accordingly
        [profilePic setImage:[UIImage imageNamed:@"Unknown-person.png"] forState:UIControlStateNormal];
        [profilePic setImage:[UIImage imageNamed:@"Unknown-person.png"] forState:UIControlStateHighlighted];
        lblDesc.text = picture.caption;
        DLog(@"%@",picture.user_desc);
        if (!pic.album)
        {
            [profilePic setImageWithURL:[Utility getProfilePicURL:[[picture.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]]];
            [btnName setTitle:[[picture.user_desc componentsSeparatedByString:@":"]lastObject] forState:UIControlStateNormal];
            [btnName setTitle:[[picture.user_desc componentsSeparatedByString:@":"]lastObject] forState:UIControlStateHighlighted];
            [btnName setTag:[[[picture.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]intValue]];
            [profilePic setTag:[[[picture.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]intValue]];
        }
        else
        {
            [btnName setTitle:picture.album.user_profile.name forState:UIControlStateNormal ];
            [btnName setTitle:picture.album.user_profile.name forState:UIControlStateHighlighted];
            if (!picture.album.user_profile.picture)
                [profilePic setImageWithProfile:picture.album.user_profile];
            else {
                [profilePic setImage:[UIImage imageWithData:picture.album.user_profile.picture] forState:UIControlStateNormal];
                [profilePic setImage:[UIImage imageWithData:picture.album.user_profile.picture] forState:UIControlStateHighlighted];
            }
            [btnName setTag:picture.album.user_profile.user_id.intValue];
            [profilePic setTag:picture.album.user_profile.user_id.intValue];
        }
        if ([[DAL sharedInstance] isFavLocation:picture.location])
        {
            btnLocation.tag = 1;
            [btnLocation setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        }
        else 
        {
            btnLocation.tag = 0;
            [btnLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }

        if (picture.location && ![picture.location isEmptyString])
        {
            [btnLocation setTitle:[picture.location stringByReplacingOccurrencesOfString:@";" withString:@","] forState:UIControlStateNormal];
            [btnLocation setTitle:[picture.location stringByReplacingOccurrencesOfString:@";" withString:@","] forState:UIControlStateHighlighted];
        }
        else {
            [btnLocation setTitle:@" " forState:UIControlStateNormal];
            [btnLocation setTitle:@" " forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)shareImage:(id)sender 
{
    if (currentImage && [Utility userID])
    {
        SHKItem *item = [SHKItem image:[UIImage imageWithData:currentImage.image.image] title:currentImage.caption];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        
        [actionSheet showInView:self.view];
    }
}

- (IBAction)comment:(id)sender 
{
    if (!isCommentViewLoading)
    {
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Comments & Likes"];
        
        gotoCommentView = YES;
        isLikeBtnSelected = NO;
        if ([Utility userID])
        {
            isCommentViewLoading = YES;
            NSString *ID = [NSString stringWithFormat:@"%d",((UIButton *)sender).tag];
            if(getImageRequest)
            {
                getImageRequest.delegate = nil;
                RELEASE_SAFELY(getImageRequest);
            }
            getImageRequest = [[WebServices alloc] init];
            [getImageRequest setDelegate:self];
            [getImageRequest getImage:ID ofUser:[Utility userID]]; 
        }
    }
}

- (IBAction)like:(id)sender 
{
    
    gotoCommentView = NO;
    isLikeBtnSelected = YES;
    if ([Utility userID])
    {
        NSString *ID = [NSString stringWithFormat:@"%d",((UIButton *)sender).tag];
        if (imageIDLiked)
            RELEASE_SAFELY(imageIDLiked);
        imageIDLiked = [ID retain];
        if (likeRequest)
        {
            likeRequest.delegate = nil;
            RELEASE_SAFELY(likeRequest);
        }
        likeRequest = [[WebServices alloc] init];
        [likeRequest setDelegate:self];
        [likeRequest likeImage:ID];
    }
}

- (IBAction)dismissAlbumView:(id)sender 
{
    if (delegate && [delegate respondsToSelector:@selector(disappearAlbumView)])
    {
        [delegate disappearAlbumView];
    }
}

- (void)locationAdded
{
    [btnLocation setTag:0];
    [btnLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)followLocation:(UIButton *)sender 
{
    NSString *location = sender.titleLabel.text;
    location = [location stringByReplacingOccurrencesOfString:@"," withString:@";"];
    if (location &&![location isEmptyString] && [location containsString:@";"] && sender.tag == 0)
    {
        NSArray *states = [Utility getAllStatesList];
        NSString *state = [[location componentsSeparatedByString:@";"] objectAtIndex:1];
        if ([states containsObject:state])
        {
            NSArray *counties = [Utility getAllCountiesListOfState:state];
            NSString *county = [[location componentsSeparatedByString:@";"] objectAtIndex:0];
            if ([counties containsObject:county])
            {
                [[Utility sharedInstance] addFavouriteLocationToUserProfile:location forViewController:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationAdded) name:NOTIFICATION_FAV_LOC_ADDED object:nil];
            }
            else {
                [self findLocation:location];
            }
        }
        else {
            [self findLocation:location];
        }

        
    }
    else if (sender.tag == 1) 
    {
        [btnLocation setTag:0];
        [btnLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *county = [[location componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *state = [[location componentsSeparatedByString:@";"] lastObject];
        
        Location *loc = [[DAL sharedInstance] getLocationByState:state andCounty:county];
        if (loc)
        {
            delLocRequest = [[WebServices alloc] init] ;
            [delLocRequest setDelegate:self];
            [delLocRequest deleteFavLoc:loc.loc_id];
            
            [[[DAL sharedInstance] managedObjectContext] deleteObject:loc];
            [[DAL sharedInstance] saveContext];
        }
    }
    
}

- (NSInteger)getTagFromPicture:(Picture *)picture
{
    NSString *picID = picture.pic_id;
    switch (comeFromView) 
    {
        case 0:
            picID = picture.pic_id; 
            break;
        case 1:
        {
            picID = [[picture.desc componentsSeparatedByString:@":"] objectAtIndex:0]; 
        }
            break;    
        case 2:
        {
            picID = [[picture.image_url componentsSeparatedByString:@"="] lastObject]; 
        }
            break;
        default:
            break;
    }
    return [picID intValue];
}





- (NSString *)getCoredataIDFromImageID:(NSString *)imgID
{
    NSString *picID = imgID;
    switch (comeFromView) {
        case 0:
            picID = imgID; 
            break;
        case 1:
        {
            for (Picture *picture in picArray) {
                NSString *realID = [[picture.desc componentsSeparatedByString:@":"] objectAtIndex:0];
                if ([realID isEqualToString:imgID])
                {
                    picID = picture.pic_id;
                    break;
                }
            } 
        }
            break;    
        case 2:
        {
            for (Picture *picture in picArray) {
                NSString *realID = [[picture.image_url componentsSeparatedByString:@"="] lastObject];
                if ([realID isEqualToString:imgID])
                {
                    picID = picture.pic_id;
                    break;
                }
            } 
        }
            break;
        default:
            break;
    }
    return picID;
}

#pragma mark - First Screen Delegate

- (void)imageDisappeared
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dismissCommentView
{
    self.lblLikes.text = [NSString stringWithFormat:@"%d",[commentController.selectedPicture.likes_count intValue]];
    self.lblComment.text = [NSString stringWithFormat:@"%d",[commentController.selectedPicture.comments_count intValue]];
    [commentController.view removeFromSuperview];
}

#pragma mark - Request Wrapper Delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_LIKE])
    {
        if(likeRequest)
        {
            likeRequest.delegate = nil;
            RELEASE_SAFELY(likeRequest);
        }
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            DLog(@"Image liked successfully");
        }
        [self getImageInfo:imageIDLiked];
        if (imageIDLiked)
            RELEASE_SAFELY(imageIDLiked);
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_GET_LOCATION])
    {
        if ([jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] count]>0)
        {
            [self addLocation:[[[jsonDict objectForKey:@"data"]objectAtIndex:0]objectForKey:@"data"]];
        }
        else 
        {
            [loadingActivityIndicator removeFromSuperview];
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Custom Location Error" message:@"Unable to find the custom location. The  location have been deleted from the server by the user who added that location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_FAV_LOCATION]) 
    {
        [loadingActivityIndicator removeFromSuperview];
        if ([jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            [btnLocation setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [btnLocation setTag:1];
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"OutdoorLoop" message:@"Location added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_DELETE])
    {
        if(delLocRequest)
        {
            delLocRequest.delegate = nil;
            RELEASE_SAFELY(delLocRequest);
        }

        DLog(@"Location deleted!!!");
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE]) 
    {
        if(getImageRequest)
        {
            getImageRequest.delegate = nil;
            RELEASE_SAFELY(getImageRequest);
        }
        if ([[jsonDict objectForKey:@"data"] count]>0)
        {
            NSDictionary *imgInfo = [[[jsonDict objectForKey:@"data"] objectAtIndex:0]objectForKey:@"data"];
            NSString *ID = [self getCoredataIDFromImageID:[imgInfo objectForKey:KWEB_SERVICE_IMAGE_ID]];
            NSString *caption = [imgInfo objectForKey:KWEB_SERVICE_IMAGE_TITLE];
            NSString *location = [imgInfo objectForKey:KWEB_SERVICE_IMAGE_LOCATION];
            NSNumber *likes_count = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]];
            NSNumber *commentCount = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]];
            Picture *picture = [[DAL sharedInstance] getImageByImageID:ID];
            [picture setCaption:caption];
            [picture setLocation:location];
            if (([picture.likes_count intValue]!=[likes_count intValue]) || ([picture.comments_count intValue]!=[commentCount intValue]))
            {
                [picture setLikes_count:likes_count];
                [picture setComments_count:commentCount];
                
            }
            [[DAL sharedInstance] saveContext];
            [self.scrollVw.delegate scrollViewDidEndDecelerating:scrollVw];
            if ([jsonDict objectForKey:@"comment"] && [[jsonDict objectForKey:@"comment"]count]>0)
            {
                NSArray *arr = [jsonDict objectForKey:@"comment"];
                for (NSDictionary *dict in arr) 
                {
                    dict = [dict objectForKey:[[dict allKeys]objectAtIndex:0]];
                    [[DAL sharedInstance] addCommentAndEditPictureWithParams:dict inPicture:ID];
                }
                
            }
            if ([jsonDict objectForKey:@"like"] && [[jsonDict objectForKey:@"like"]count]>0)
            {
                NSArray *arr = [jsonDict objectForKey:@"like"];
                [commentController setLikesInfo:arr];        
            }
            [commentController setSelectedPicture:picture];
            [commentController setShouldLike:isLikeBtnSelected];
            //[commentController setLikesInfo:nil];
            //[self.view addSubview:commentController.view];
            if (gotoCommentView)
            {
                isCommentViewLoading = NO;
                gotoCommentView = NO;
                [loadingActivityIndicator removeFromSuperview];
                [commentController addCommentControllerAsSubviewInController:self];
            }
        }
        else {
            isCommentViewLoading = NO;
        }
    }
    else 
    {
        [loadingActivityIndicator removeFromSuperview];
        [Utility showServerError];
    }

}

- (void)getImageInfo:(NSString *)imageID
{
    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    getImageRequest = [[WebServices alloc] init];
    [getImageRequest setDelegate:self];
    [getImageRequest getImage:imageID ofUser:[Utility userID]]; 
}
- (void)setPictureAtIndex:(int)index isCurrentIndex:(BOOL)isCurrentIndex
{
 
    UIScrollView *scrollView = [scrollViewArray objectAtIndex:index];
    FLImageView *imageView = nil;
    Picture *picture = (Picture *)[picArray objectAtIndex:index];
    UIImage *image = [UIImage imageWithData:picture.image.image];
    imageView = (FLImageView *)[scrollView viewWithTag:999];
    if (!imageView)
    {
        imageView = [[[FLImageView alloc] init] autorelease] ;
        [imageView setTag:999];
        
        
        [scrollView addSubview:imageView];
    }
    [imageView setFrame:CGRectMake(0, 0, 320, 460)];
    if (image)
        [imageView setImage:image];
    else {
        [imageView setImageWithImage:picture];
    }
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //scrollView.contentSize = image.size;
    
    scrollView.bounces = NO;
    
    scrollView.delegate = self;
    
    // set up our content size and min/max zoomscale
    CGFloat xScale = applicationFrame.size.width / image.size.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = applicationFrame.size.height / image.size.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    //scrollView.contentSize = image.size;
    scrollView.maximumZoomScale = maxScale*2;
    scrollView.minimumZoomScale = minScale;
    scrollView.zoomScale = minScale;
    
    
    DLog(@"%f----%f",image.size.width, image.size.width);
    
    
    
    // To change bound size of img view
    
    UIImage *aimage = [image scaleDownToSize:CGSizeMake(320, 480)];
    float y = (460 - aimage.size.height)/2;
    CGRect landScapeFrame;
    CGRect fullFrame;
    if (IS_IPHONE_5) {
        
        landScapeFrame = CGRectMake(0, y+50, 320, aimage.size.height);
        fullFrame =  CGRectMake(0,100 , 320, 480);
    }else{
        
        landScapeFrame = CGRectMake(0, y, 320, aimage.size.height);
        fullFrame =  CGRectMake(0,0 , 320, 480);
    }
    CGRect frame = fullFrame;
    if (image.size.width > image.size.height)
    {
        frame = landScapeFrame;
    }
    imageView.frame = frame;
    
    
    if (isCurrentIndex)
        [scrollVw setContentOffset:CGPointMake(index*320, 0)];

}


- (void)imageTapped:(id)sender
{
    float x = scrollVw.contentOffset.x;
    int index = x/320;
    UIScrollView *scrollView = [scrollViewArray objectAtIndex:index];
    if (scrollView.zoomScale==scrollView.minimumZoomScale)
        [scrollView setZoomScale:scrollView.maximumZoomScale];
    else
        [scrollView setZoomScale:scrollView.minimumZoomScale];
}

- (IBAction)gotoProfile:(id)sender
{   
    selectedID = [[NSString stringWithFormat:@"%d",((UIButton *)sender).tag] retain];
    if (![[DAL sharedInstance] getProfileByID:selectedID])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoProfileView:) name:NOTIFICATION_PROFILE_SAVED object:nil];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:selectedID];
    }
    else
        [self gotoProfileView:nil];
    
}

- (void)gotoProfileView:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIStoryboard *storyBoard = self.storyboard;
    ProfileViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"ProfileView"];
    Profile *profile = [[DAL sharedInstance] getProfileByID:selectedID];
    [controller setUserProfile:profile];
    RELEASE_SAFELY(selectedID);
    GalleryViewController *galController = (GalleryViewController *)self.delegate;
    [galController.navigationController pushViewController:controller animated:YES];
    [self dismissAlbumView:nil];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [appDelegate gotoProfileView:sender];
}

-(void)findLocation:(NSString *)location
{
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Adding location..."];
    if(findLocation)
    {
        findLocation.delegate = nil;
        RELEASE_SAFELY(findLocation);
    }
    findLocation = [[WebServices alloc] init];
    findLocation.delegate = self;
    [findLocation getLocationByTitle:location];
}

-(void)addLocation:(NSDictionary *)params
{
    if(addLocation)
    {
        addLocation.delegate = nil;
        RELEASE_SAFELY(addLocation);
    }
    addLocation = [[WebServices alloc] init];
    addLocation.delegate = self;
    [addLocation addFavLoc:params];

    NSString *county = [[[params objectForKey:KWEB_SERVICE_LOCATION_TITLE] componentsSeparatedByString:@";"] objectAtIndex:0];
    NSString *state = [[[params objectForKey:KWEB_SERVICE_LOCATION_TITLE] componentsSeparatedByString:@";"] lastObject]; 
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:county forKey:LOCATION_COUNTY_KEY];
    [dict setObject:state forKey:LOCATION_STATE_KEY];
    [dict setObject:[params objectForKey:LOCATION_LATITUDE_KEY] forKey:LOCATION_LATITUDE_KEY];
    [dict setObject:[params objectForKey:LOCATION_LONGITUDE_KEY] forKey:LOCATION_LONGITUDE_KEY];
    [dict setObject:[Utility userID] forKey:PROFILE_USER_ID_KEY];
    [[DAL sharedInstance] addFavLocToUserProfile:dict];
}

@end
