//
//  GalleryViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "UIImage+Scale.h"
#import "FLButton.h"
#import "FirstViewController.h"
#import "ImageCell.h"
#import "UIImageView+WebCache.h"

@interface GalleryViewController ()

- (void)showAlbums;
- (void)saveImagesToDB:(NSArray *)imageDicts;
- (void)refresh;
@end

@implementation GalleryViewController
//@synthesize scrollView;
@synthesize hasAppeared;
@synthesize tblView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureSelectedPUSH:) name:@"LIKEPUSH" object:nil];
    hasAppeared = NO;
    isLoading = NO;
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    lblNavigationImage = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lblNavigationImage setFont:[UIFont fontWithName:@"WOODCUT" size:16]];
    [lblNavigationImage setTextColor:[UIColor whiteColor]];
    [lblNavigationImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lblNavigationImage setTextAlignment:UITextAlignmentCenter];
    [lblNavigationImage setText:self.title];
    [titleView addSubview:lblNavigationImage];
    self.navigationItem.title = @"";
    
    btnImageViews = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];
    dispatch_async(kBgQueue, ^{
        
        [self refresh];
        
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    hasAppeared=NO;
    [titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!hasAppeared)
    {
        hasAppeared = YES;
        NSString *albumName = [self.title stringByReplacingOccurrencesOfString:@" " withString:@""];
        RELEASE_SAFELY(picArray);
        picArray = [[[DAL sharedInstance] getAllImagesByValue:albumName andKey:PICTURE_DESC_KEY] retain];
        [self showAlbums];
        [self.navigationItem setHidesBackButton:YES];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DIDAPPEAR"] isEqualToString:@"DIDAPPEAR"]) {
         
            loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading Images..."];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LIKEPUSH" object:nil];
            [[NSUserDefaults standardUserDefaults] setValue:@"DIDAPPEAR1" forKey:@"DIDAPPEAR"];
        }
    }
}

- (void)viewDidUnload
{
    
    //[self setScrollView:nil];
    [self setTblView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    searchImageRequest.delegate = nil;
    RELEASE_SAFELY(searchImageRequest);
//    for (NSObject *obj in btnImageViews) {
//        RELEASE_SAFELY(obj);
//    }
    RELEASE_SAFELY(btnImageViews);
    RELEASE_SAFELY(titleView);
    RELEASE_SAFELY(picArray);
   // [scrollView release];
    [tblView release];
    [super dealloc];
}



- (void)showAlbums
{
    
    if (picArray && [picArray count]!=0)
    {
//        if (picArray.count!=scrollView.subviews.count)
//        {
//            for (UIView *view in scrollView.subviews) {
//                [view removeFromSuperview];
//            }
//            
//            [self performSelectorInBackground:@selector(populateImageViewArray:) withObject:picArray];
//        }
//        else {
//            [loadingActivityIndicator removeFromSuperview];
//        }
        [tblView reloadData];
        //[loadingActivityIndicator removeFromSuperview];
        [lblNavigationImage setText:self.title];
    }
    else {
//        for (UIView *view in scrollView.subviews) {
//            [view removeFromSuperview];
//        }

        //[loadingActivityIndicator removeFromSuperview];
        [lblNavigationImage setText:self.title];
    }
}

- (void)popViewController;
{
    if (searchImageRequest)
    {
        searchImageRequest.delegate = nil;
        RELEASE_SAFELY(searchImageRequest);
    }
    if ([Utility userID])
    {
        FirstViewController *controller = (FirstViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
        [controller dismissMyView:@"2"];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)pictureSelectedPUSH:(id)sender
{
    //UIButton *btn = (UIButton *)sender;
    
    for (Picture *picture in picArray)
    {
        
        NSString *realID = [[picture.image_url componentsSeparatedByString:@"="] lastObject];
        if ([realID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"ITEMID"]]){
            selectedImage = picture;
            break;
        }        
    }
    [self performSegueWithIdentifier:@"AlbumView" sender:self];
}


- (void)pictureSelected:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    for (Picture *picture in picArray) 
    {
        NSInteger tag = [[[picture.pic_id componentsSeparatedByString:@"-"] lastObject] intValue];
        if (btn.tag == tag){
            selectedImage = picture;
            break;
        }
    }
    [self performSegueWithIdentifier:@"AlbumView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AlbumView"])
    {
        AlbumViewController *controller = (AlbumViewController *)[segue destinationViewController];
        [controller setDelegate:self];
        [controller setComeFromView:2];
        [controller setPic:selectedImage];
        [controller setPicArray:[NSArray arrayWithArray:picArray]];
    }
}

#pragma mark
#pragma request wrapper delegate
- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        
    if (searchImageRequest)
    {
        [searchImageRequest setDelegate:nil];
        RELEASE_SAFELY(searchImageRequest);
    }
    isLoading = NO;
    
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if (jsonDict && [jsonDict objectForKey:@"data"])
    {
        if ([[jsonDict objectForKey:@"data"] count]>0)
            [self saveImagesToDB:[jsonDict objectForKey:@"data"]];
        else {
            [self saveImagesToDB:nil];
        }
    }
    else {
        [Utility showServerError];
        //[loadingActivityIndicator removeFromSuperview];
        
        [lblNavigationImage setText:self.title];
        NSString *albumName = [self.title stringByReplacingOccurrencesOfString:@" " withString:@""];
        RELEASE_SAFELY(picArray)
        picArray = [[[DAL sharedInstance] getAllImagesByValue:albumName andKey:PICTURE_DESC_KEY] retain];
        NSLog(@"%@",picArray);
        [self showAlbums];
    }
        
    //});
}

- (void)saveImagesToDB:(NSArray *)imageDicts
{
    int ind = 0;
    for (NSDictionary *dict in imageDicts) {
        NSDictionary *imageDict = [dict objectForKey:@"data"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"Trending-%@-%d",[imageDict objectForKey:KWEB_SERVICE_ALBUM_DESCRIPTION],ind] forKey:PICTURE_ID_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_LOCATION] forKey:PICTURE_LOCATION_KEY];
        [params setObject:[Utility getImageURL:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID]] forKey:PICTURE_IMAGE_URL_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]] forKey:PICTURE_LIKES_COUNT_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]] forKey:PICTURE_COMMENT_COUNT_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_TITLE] forKey:PICTURE_CAPTION_KEY];
        [params setObject:[NSString stringWithFormat:@"%@:%@",[imageDict objectForKey:KWEB_SERVICE_USERID],[imageDict objectForKey:KWEB_SERVICE_NAME]] forKey:PICTURE_USER_DESC_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_ALBUM_DESCRIPTION] forKey:PICTURE_DESC_KEY];
        [[DAL sharedInstance] createOtherUserImageWithParams:params];
        ind++;
    }
    NSString *albumName = [self.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    RELEASE_SAFELY(picArray)
    picArray = [[[DAL sharedInstance] getAllImagesByValue:albumName andKey:PICTURE_DESC_KEY] retain];
    [self showAlbums];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DIDAPPEAR"] isEqualToString:@"DIDAPPEAR1"]) {
        
        [loadingActivityIndicator removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LIKEPUSH" object:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"DIDAPPEAR12" forKey:@"DIDAPPEAR"];
        
    }
}

- (void)refresh
{
    if (!isLoading)
    {
        isLoading = YES;
        if (searchImageRequest)
        {
            [searchImageRequest setDelegate:nil];
            RELEASE_SAFELY(searchImageRequest);
        }
        searchImageRequest = [[WebServices alloc]init];
        [searchImageRequest setDelegate:self];
        [searchImageRequest searchImageByValue:[self.title stringByReplacingOccurrencesOfString:@" " withString:@""] andKey:KWEB_SERVICE_ALBUM_DESCRIPTION];
        //loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading Images..."];
        dispatch_async(dispatch_get_main_queue(),^{
            
        [lblNavigationImage setText:@"Loading..."];
            
        });
        
        
    }
    
}

- (void)disappearAlbumView
{
    [self dismissModalViewControllerAnimated:YES];
}


# pragma mark UITable view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (!picArray || picArray.count==0)?0:ceil((float)picArray.count/4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d %d",indexPath.row,indexPath.section];
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if(cell == nil) {
        
    cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //This shouldn't happen but you can build manually to be safe.
    cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    int index= indexPath.row*4;
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        FLButton *imgBtn = [[FLButton alloc] initWithFrame:CGRectMake(15, 5, 65, 65)];
        //[cell.btn1 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
                [imgBtn setImageWithImage:pic];
        }
        else {
            
            [imgBtn setImageWithDataInBackGround:pic.image.image];
        }
        [cell addSubview:imgBtn];
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
    }
    else {
        [cell.btn1 setHidden:YES];
    }
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        FLButton *imgBtn = [[FLButton alloc] initWithFrame:CGRectMake(92, 5, 65, 65)];
        //[cell.btn2 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
            [imgBtn setImageWithImage:pic];
//            [imgBtn setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
//            [imgBtn setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateHighlighted];
//            [imgBtn.imageView setImageWithURL:[NSURL URLWithString:pic.image_url]placeholderImage:[UIImage imageNamed:@"loading.png"]];
        }
        else {
            
            [imgBtn setImageWithDataInBackGround:pic.image.image];

        }
        [cell addSubview:imgBtn];
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
    }
    else {
        [cell.btn2 setHidden:YES];
    }
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        FLButton *imgBtn = [[FLButton alloc] initWithFrame:CGRectMake(165, 5, 65, 65)];
        //[cell.btn3 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
            [imgBtn setImageWithImage:pic];
//            [imgBtn setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
//            [imgBtn setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateHighlighted];
//            [imgBtn.imageView setImageWithURL:[NSURL URLWithString:pic.image_url]placeholderImage:[UIImage imageNamed:@"loading.png"]];
        }
        else {
            
            [imgBtn setImageWithDataInBackGround:pic.image.image];
            
        }
        [cell addSubview:imgBtn];
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
    }
    else {
        [cell.btn3 setHidden:YES];
    }
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        FLButton *imgBtn = [[FLButton alloc] initWithFrame:CGRectMake(240, 5, 65, 65)];
        //[cell.btn4 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
            
            [imgBtn setImageWithImage:pic];
        }
        else {
            
            [imgBtn setImageWithDataInBackGround:pic.image.image];
        
        }
        [cell addSubview:imgBtn];
        
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
    }
    else {
        [cell.btn4 setHidden:YES];
    }
        
    }
    return cell;
    
}


@end
