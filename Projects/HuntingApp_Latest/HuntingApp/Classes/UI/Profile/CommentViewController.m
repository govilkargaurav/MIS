//
//  CommentViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "GalleryViewController.h"
#import "AlbumViewController.h"
#import "UIImageView+WebCache.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface CommentViewController ()

- (void)getImageInfo;
- (void)gotoProfile:(id)sender;
- (void)populateImageArray;
- (BOOL)doesCommentsArrayContainYourComment;
@end

@implementation CommentViewController
@synthesize editBtn;
@synthesize subview;
CGFloat animatedDistance;
@synthesize delegate,selectedPicture,shouldLike,likesInfo;


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
    
}


- (void)alertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(buttonIndex == 0)
    {
        NSString *comment = ((UITextView *)[alertView viewWithTag:99]).text;
        DLog(@"%@",comment);
        if ([comment isEqualToString:@""]|| [comment isEqualToString:@"Place your comment here\n\n\n\n"])
        {
            RELEASE_SAFELY(av);
            return;
        }
        if (commentRequest)
        {
            commentRequest.delegate = nil;
            RELEASE_SAFELY(commentRequest);
        }
        commentRequest = [[WebServices alloc] init];
        commentRequest.delegate = self;
        [commentRequest commentImageByID:imageID andComment:comment];
    }
    RELEASE_SAFELY(av);
}


- (void)viewDidUnload
{
    [tblView release];
    tblView = nil;
    [lblComment release];
    lblComment = nil;
    [lblLike release];
    lblLike = nil;
    [likeScrollView release];
    likeScrollView = nil;
    [self setEditBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    RELEASE_SAFELY(av);
    RELEASE_SAFELY(btnImageViews);
    RELEASE_SAFELY(imageID);
    if(likeRequest)
    {
        likeRequest.delegate = nil;
        RELEASE_SAFELY(likeRequest);
    }
    if(deleteCommentRequest)
    {
        deleteCommentRequest.delegate = nil;
        RELEASE_SAFELY(deleteCommentRequest);
    }
    if(commentRequest)
    {
        commentRequest.delegate = nil;
        RELEASE_SAFELY(commentRequest);
    }
    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    [tblView release];
    [lblComment release];
    [lblLike release];
    [likeScrollView release];
    [editBtn release];
    [super dealloc];
}


- (IBAction)showAnimation:(id)sender
{

    [UIView animateWithDuration:0.2 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f, 0.7f);
         self.subview.alpha = 0.5;
     }
                     completion:^(BOOL finished){
                         [self bounceOutAnimationStoped];
                     }];
}


- (void)bounceOutAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.6);
         self.subview.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
}

- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,0.7);
         self.subview.alpha = 1.0;
     }
                     completion:^(BOOL finished){
                         [self animationStoped];
                     }];
}
- (void)animationStoped
{
    
    [txtfldComment becomeFirstResponder];
    
}

- (IBAction)hide:(id)sender
{
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         self.subview.alpha = 0;
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
         
     }
                     completion:^(BOOL finished){
                         //[self animationStoped];
                     }];
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - request wrapper delegate
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
        [self getImageInfo];
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_DELETE])
    {
        if(deleteCommentRequest)
        {
            deleteCommentRequest.delegate = nil;
            RELEASE_SAFELY(deleteCommentRequest);
        }
        DLog(@"Comment deleted");
        [self getImageInfo];
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_COMMENT]) 
    {
        if(commentRequest)
        {
            commentRequest.delegate = nil;
            RELEASE_SAFELY(commentRequest);
        }
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            DLog(@"Image Comment successfully");
        }
        [self getImageInfo];
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE]) 
    {
        if(getImageRequest)
        {
            getImageRequest.delegate = nil;
            RELEASE_SAFELY(getImageRequest);
        }
        NSDictionary *imgInfo = [[[jsonDict objectForKey:@"data"] objectAtIndex:0]objectForKey:@"data"];
        NSNumber *likes_count = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]];
        NSNumber *commentCount = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]];
        if (([selectedPicture.likes_count intValue]!=[likes_count intValue]) || ([selectedPicture.comments_count intValue]!=[commentCount intValue]))
        {
            [selectedPicture setLikes_count:likes_count];
            [selectedPicture setComments_count:commentCount];
            [[DAL sharedInstance] saveContext];
        }
        lblLike.text = [NSString stringWithFormat:@"%d",[selectedPicture.likes_count intValue]];
        lblComment.text = [NSString stringWithFormat:@"%d",[selectedPicture.comments_count intValue]];
        if ([jsonDict objectForKey:@"comment"] && [[jsonDict objectForKey:@"comment"]count]>0)
        {
            NSArray *arr = [jsonDict objectForKey:@"comment"];
            for (NSDictionary *dict in arr) 
            {
                dict = [dict objectForKey:[[dict allKeys]objectAtIndex:0]];
                [[DAL sharedInstance] addCommentAndEditPictureWithParams:dict inPicture:selectedPicture.pic_id];
            }
            [tblView reloadData];
        }
        if ([jsonDict objectForKey:@"like"] && [[jsonDict objectForKey:@"like"]count]>0)
        {
            NSArray *arr = [jsonDict objectForKey:@"like"];
            [self setLikesInfo:arr];  
            
        }
        else {
            [self setLikesInfo:nil];
        }
        [self populateImageArray];
    }
}

#pragma mark - tableView methods

- (IBAction)editTblView:(UIBarButtonItem *)btn
{
    [tblView setEditing:!tblView.editing];
    if (tblView.editing)
    {
        btn.title = @"Done";
    }
    else 
    {
        btn.title = @"Edit";
    }
}


- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:COMMENT_ID_KEY ascending:YES] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    Comment *comment = [[selectedPicture.comments sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row];
    if([comment.user_id isEqualToString:[Utility userID]])
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:COMMENT_ID_KEY ascending:YES] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    Comment *comment = [[selectedPicture.comments sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row];
    float height = [Utility getStringSizeForString:comment.desc withFontSize:12 andMaxWidth:250].height;
    return height>24?(height+28):44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self doesCommentsArrayContainYourComment])
    {
        [editBtn setEnabled:YES];
    }
    else 
    {
        editBtn.title = @"Edit";
        [tblView setEditing:NO];
        [editBtn setEnabled:NO];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedPicture.comments)
    {
        return [selectedPicture.comments count];
    }
    else 
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:COMMENT_ID_KEY ascending:YES] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    Comment *comment = [[selectedPicture.comments sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row];
    [cell.lblName setTitle:comment.user_name forState:UIControlStateNormal];
    [cell.lblName setTitle:comment.user_name forState:UIControlStateHighlighted];
    [cell.lblName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cell.imgProfileView setImageWithURL:[NSURL URLWithString:[Utility getProfilePicURL:comment.user_id]] placeholderImage:[UIImage imageNamed:@"Loading.png"]];
    [cell.imgProfileView getWhiteBorderImage];
    cell.lblComment.text = comment.desc;
    [cell.lblName setTag:[comment.user_id intValue]];
    [cell.profilePic setTag:[comment.user_id intValue]];
    [cell.lblName addTarget:self action:@selector(gotoProfile:) forControlEvents:UIControlEventTouchUpInside];
    CGRect lblFrame = cell.lblName.frame;
    float width = [Utility getStringSizeForString:comment.user_name withFontSize:14 andMaxWidth:250].width + 10;
    lblFrame.size.width = width;
    [cell.lblName setFrame:lblFrame];
    [cell.profilePic addTarget:self action:@selector(gotoProfile:) forControlEvents:UIControlEventTouchUpInside];
    [cell.lblComment sizeToFit];
    float height = [Utility getStringSizeForString:comment.desc withFontSize:12 andMaxWidth:250].height;
    [cell.lblComment setFrame:CGRectMake(48, 20, 250, height)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:COMMENT_ID_KEY ascending:YES] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    Comment *comment = [[selectedPicture.comments sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row];
    
    if (deleteCommentRequest)
    {
        deleteCommentRequest.delegate = nil;
        RELEASE_SAFELY(deleteCommentRequest)
    }
    deleteCommentRequest = [[WebServices alloc] init];
    deleteCommentRequest.delegate = self;
    [deleteCommentRequest deleteComment:[comment.comment_id stringValue] ofImageID:[[selectedPicture.image_url componentsSeparatedByString:@"="]lastObject]];
    
    
    [[[DAL sharedInstance] managedObjectContext] deleteObject:comment];
    [[DAL sharedInstance] saveContext];
    [tblView reloadData];
    
    
}

- (IBAction)like:(id)sender 
{
    if ([Utility userID])
    {
        if (likeRequest)
        {
            likeRequest.delegate = nil;
            RELEASE_SAFELY(likeRequest);
        }
        likeRequest = [[WebServices alloc] init];
        [likeRequest setDelegate:self];
        [likeRequest likeImage:imageID];
    }
}

- (IBAction)comment:(id)sender
{
    if ([Utility userID])
    {
        if (!av)
        {
//            av = [[TSAlertView alloc] init] ;
//            av.title = @"Comment Box";
//            av.message = @"Place your comment here\n\n\n\n";
//            av.delegate = self;
//            [av addButtonWithTitle: [NSString stringWithFormat: @"Comment"]];
//            [av addButtonWithTitle: [NSString stringWithFormat: @"Cancel"]];
//            
//            av.style = TSAlertViewStyleNormal;
//            av.buttonLayout = TSAlertViewButtonLayoutNormal;
//            av.usesMessageTextView = YES;
//            
//            av.width = 0;
//            av.maxHeight = 0;
//            
//            [av show];
            
            txtfldComment.text=@"";
            [self showAnimation:nil];
        }
    }
}

- (void)getImageInfo
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


- (IBAction)dismissView:(id)sender 
{
    if (delegate && [delegate respondsToSelector:@selector(dismissCommentView)])
    {
        [delegate dismissCommentView];
    }
}

- (void)addCommentControllerAsSubviewInController:(UIViewController *)controller
{

    [controller.view addSubview:self.view];
    if ([txtfldComment.text isEqualToString:@""]) {
        
    }
    self.subview.layer.borderWidth = 5.0f;
    self.subview.alpha = 0.0;
    self.subview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    
    editBtn.title = @"Edit";
    [tblView setEditing:NO];
    imageID = [[[selectedPicture.image_url componentsSeparatedByString:@"="] lastObject] retain];
    
	if (!shouldLike)
    {
        [self showAnimation:nil];
    }
    lblLike.text = [NSString stringWithFormat:@"%d",[selectedPicture.likes_count intValue]];
    lblComment.text = [NSString stringWithFormat:@"%d",[selectedPicture.comments_count intValue]];
    [tblView reloadData];
    [self getImageInfo];
    for (UIView *view in likeScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    if (IS_IPHONE_5) {
        
    tblView.frame=CGRectMake(0, 89, 320, 268);
    viewBottom.frame=CGRectMake(0, 370, 320, 42);
        
    }
    
    
    //[self populateImageArray];
}

- (void)gotoProfile:(id)sender
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
    AlbumViewController *albumController = (AlbumViewController *)self.delegate;
    GalleryViewController *galController = (GalleryViewController *)albumController.delegate;
    [self dismissView:nil];
    [albumController dismissAlbumView:nil];
    [galController.navigationController pushViewController:controller animated:YES];
    
   // [self dismissAlbumView:nil];
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //    [appDelegate gotoProfileView:sender];
}


- (void)populateImageArray
{
    for (UIView *view in likeScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    [btnImageViews removeAllObjects];
    float initX = 0;
    float initY = 0;
    int ind = 0;
    CGRect rect = CGRectMake((initX+((ind%7)*43)), (initY+((ind/7)*43)), 38, 38);
    for (NSDictionary *dict in likesInfo) 
    {
        
        dict = [dict objectForKey:[[dict allKeys]objectAtIndex:0]];
        NSString *ID = [dict objectForKey:KWEB_SERVICE_USERID];
        FLButton *imgBtn = [[[FLButton alloc] initWithFrame:rect] autorelease] ;
        [imgBtn.imageView getWhiteBorderImage];
        [imgBtn setTag:[ID integerValue]];
        [imgBtn setImageWithURL:[Utility getProfilePicURL:ID]];
        [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
        [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
        [imgBtn addTarget:self action:@selector(gotoProfile:) forControlEvents:UIControlEventTouchUpInside];
        ind ++;
        rect = CGRectMake((initX+((ind%7)*43)), (initY+((ind/7)*43)), 38, 38);
        [btnImageViews addObject:imgBtn];
        [likeScrollView addSubview:imgBtn];
        
    }
    UIButton *imgBtnView = [btnImageViews lastObject];
    float scrollableHeight = imgBtnView.frame.origin.y+100;
    [likeScrollView setContentSize:CGSizeMake(310, scrollableHeight)];
    
    
}

- (BOOL)doesCommentsArrayContainYourComment
{
    BOOL contain = NO;
    for (Comment *comment in selectedPicture.comments) {
        if ([comment.user_id isEqualToString:[Utility userID]])
        {
            contain = YES;
            break;
        }
    }
    return contain;
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [txtfldComment resignFirstResponder];
    [self hide:nil];
    
    if (![txtfldComment.text isEqualToString:@""]) {
        
        if (commentRequest)
        {
            commentRequest.delegate = nil;
            RELEASE_SAFELY(commentRequest);
        }
        commentRequest = [[WebServices alloc] init];
        commentRequest.delegate = self;
        [commentRequest commentImageByID:imageID andComment:txtfldComment.text];
        
    }
    
    return YES;
    
}



@end
