//
//  ReadingListViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/18/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "ReadingListViewController.h"
#import "SettingsViewController.h"
#import "WebSiteViewController.h"

#define temporaryFileDestination [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Temporary Files"]
#define fileDestination [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Downloaded Files"]


@implementation ReadingListViewController



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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extractFiles) name:@"extractFilesNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [self addGoogleAd];
    // Do any additional setup after loading the view from its nib.
}
-(void)deviceOrientationDidChange:(NSNotification*)noti
{
    if (PDFViewCtr)
    {
        if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
        {
            [PDFViewCtr setDocumentMode:YLDocumentModeSingle];
        }
        else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
        {
            [PDFViewCtr setDocumentMode:YLDocumentModeDouble];
        }
 
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [adCustomView setHidden:NO];
        [btnCancelAd setHidden:NO];
    }
    else
    {
        [adCustomView setHidden:YES];
        [btnCancelAd setHidden:YES];
    }
    [self setOrientationOfAddBanner];
    
    [self updateui];
    
    [self extractFiles];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Extract Files From Documents
-(void)extractFiles
{
    ArryDowloaded_PDF = [[NSMutableArray alloc]init];
    ArryToTalDownload_PDF = [[NSMutableArray alloc]init];
    
    NSMutableArray *ArryDowloaded_PDF_Temp = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_Downloaded_List:@"SELECT * FROM Downloaded_List"]];
    ArryDowloaded_PDF = ArryDowloaded_PDF_Temp;
    ArryToTalDownload_PDF = ArryDowloaded_PDF_Temp;
    [self LoadThumbnail];
}

-(void)LoadThumbnail
{

    while ([scl_PDF_Download.subviews count] > 0) {
        
        [[[scl_PDF_Download subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    yAxis = 0;

    int module = 3;
    int width = 728;
    if (flagOrientation == 1)
    {
        module = 4;
        width = 984;
        xAxis = 80;
    }
    else
    {
        module = 3;
        width = 728;
        xAxis = 70;
    }
    
    for (int i = 1; i <= [ArryDowloaded_PDF count]; i++)
    {
        if (i % module == 1)
        {
            UIImageView *imgStand = [[UIImageView alloc]init];
            imgStand.image = [UIImage imageNamed:@"L-stand.png"];
            imgStand.frame = CGRectMake(0, yAxis + 205, width, 47);
            [scl_PDF_Download addSubview:imgStand];
        }
        
        UIView *viewPDF = [[UIView alloc]init];
        viewPDF.backgroundColor = [UIColor clearColor];
        
        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [lblDate setTag:1000];
        [lblDate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        [lblDate setBackgroundColor:[UIColor blackColor]];
        [lblDate setTextColor:[UIColor whiteColor]];
        lblDate.textAlignment = NSTextAlignmentCenter;
        [lblDate setText:[self StringNotNullValidation:[[ArryDowloaded_PDF objectAtIndex:i-1]valueForKey:@"dIssueDate"]]];
        [viewPDF addSubview:lblDate];
        
        lblDate.layer.cornerRadius = 5;
        
        UIButton *btnThumbnail = [UIButton buttonWithType:UIButtonTypeCustom];
        btnThumbnail.frame = CGRectMake(0,  50, 130, 170);
        NSString *strImgUrl = [self StringNotNullValidation:[[ArryDowloaded_PDF objectAtIndex:i-1]valueForKey:@"vFileNameThumb"]];
        [btnThumbnail setImageWithURL:[NSURL URLWithString:strImgUrl] forState:UIControlStateNormal];
        [btnThumbnail addTarget:self action:@selector(btnThumbnailPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnThumbnail.tag = 1001;
        btnThumbnail.backgroundColor = [UIColor clearColor];
        [viewPDF addSubview:btnThumbnail];
        
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        longpressGesture.minimumPressDuration = 1.0;
        [longpressGesture setDelegate:self];
        [btnThumbnail addGestureRecognizer:longpressGesture];
        
        viewPDF.tag = i;
        viewPDF.frame = CGRectMake(xAxis, yAxis, 130, 250);
        [scl_PDF_Download addSubview:viewPDF];
        
        if (i % module == 0)
        {
            yAxis = yAxis + 290;
            
            if (flagOrientation == 1)
                xAxis = 80;
            else
                xAxis = 70;
        }
        else
        {
            xAxis = xAxis + 230;
        }
        
    }
   
    NSInteger lastpageoffset = [ArryDowloaded_PDF count] % module;
    NSInteger pagecounts = [ArryDowloaded_PDF count] /module+((lastpageoffset==0)?0:1);
    scl_PDF_Download.contentSize = CGSizeMake(width,MAX(290*pagecounts, 864));
    
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        int SuperViewPdfTag = [gestureRecognizer.view superview].tag;
        fileIndex = SuperViewPdfTag-1;
        UIActionSheet *AS_Delete = [[UIActionSheet alloc]initWithTitle:@"Do you want to delete this PDF?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [AS_Delete showFromRect:[gestureRecognizer.view superview].frame inView:scl_PDF_Download animated:YES];
        //Do Whatever You want on Began of Gesture
    }
    
}

#pragma mark - Button Action

-(IBAction)btnThumbnailPressed:(id)sender
{
    UIView *SuperViewPdf = (UIView *)[sender superview];
    int SuperViewPdfTag = SuperViewPdf.tag;
    
    NSString *strPath = [NSString stringWithFormat:@"%@",[[[ArryDowloaded_PDF objectAtIndex:SuperViewPdfTag-1]valueForKey:@"vFileName"] lastPathComponent]];
    BOOL FileexistPath = [self PDFFileExistAtPath:strPath];
    
    if (FileexistPath)
    {
        PDFViewCtr = [[YLPDFViewController alloc] initWithDocument:[self document:strPath]] ;
        [PDFViewCtr setDelegate:self];
        if (flagOrientation == 1)
        {
            [PDFViewCtr setDocumentMode:YLDocumentModeDouble];
        }
        else
        {
            [PDFViewCtr setDocumentMode:YLDocumentModeSingle];
        }
        [PDFViewCtr setPageCurlEnabled:YES];
        [PDFViewCtr setDocumentLead:YLDocumentLeadRight];
        
        [self.tabBarController presentModalViewController:PDFViewCtr animated:YES];
    }
}

#pragma mark - Pdf Document Path
- (YLDocument *)document:(NSString*)strPDFName
{
    
    NSString *strPath = [NSString stringWithFormat:@"%@/%@",fileDestination,strPDFName];
    YLDocument *_document = [[YLDocument alloc] initWithFilePath:strPath];
    
    //to remove/set the title of pdf
    [_document setTitle:@""];
    
    if(_document.isLocked)
    {
        // unlock pdf document
        [_document unlockWithPassword:@""];
    }
    
    return _document;
}

-(IBAction)ClickBtnRefresh:(id)sender
{
    ArryDowloaded_PDF = ArryToTalDownload_PDF;
    [self extractFiles];
}


#pragma mark - Orientation 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight
        ||interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        flagOrientation = 1;
    }
    else
    {
        flagOrientation = 0;
    }
    [self setOrientation];
    
    
	return YES;
}

-(void)setOrientation
{
    if (flagOrientation == 1)
    {
        imgHeader.image = [UIImage imageNamed:@"L-TopBar.png"];
    }
    else
    {
        imgHeader.image = [UIImage imageNamed:@"TopBar.png"];
    }
    [self extractFiles];
    
    if(AppDel.popOverFlag == 1)
    {
        [btnUser sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if([AppDel.popOverSignInObj isPopoverVisible])
    {
        [btnHiddenForSignInFrame sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if([AppDel.popOverSubscriptionObj isPopoverVisible])
    {
        [btnHiddenForSubscriptionFrame sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
    [self setOrientationOfAddBanner];
}

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
    }
    [self setOrientation];
}


-(int)ReurnIndexofArrayMain:(NSString*)strUrl
{
    for (int i = 0; i < [AppDel.arrPdf count]; i++)
    {
        NSString *strMainURL = [[[AppDel.arrPdf objectAtIndex:i]valueForKey:@"vFileName"] lastPathComponent];
        if ([strMainURL isEqualToString:strUrl])
        {
            return i;
        }
    }
    return 0;
}
-(BOOL)PDFFileExistAtPath:(NSString*)strfilepath
{
    strfilepath = [NSString stringWithFormat:@"%@/%@",fileDestination,strfilepath];
    BOOL Existpath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:strfilepath])
    {
        Existpath = YES;
    }
    else
    {
        Existpath = NO;
    }
    return Existpath;
}

#pragma mark - ActionSheet Delegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
         NSString *strPath = [NSString stringWithFormat:@"%@",[[[ArryDowloaded_PDF objectAtIndex:fileIndex]valueForKey:@"vFileName"]lastPathComponent]];
         NSString *strPathComplete = [NSString stringWithFormat:@"%@/%@",fileDestination,strPath];
         if ([[NSFileManager defaultManager] fileExistsAtPath:strPathComplete])
         {
             [[NSFileManager defaultManager] removeItemAtPath:strPathComplete error:nil];
             NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM Downloaded_List where iPdfID='%@'",[[ArryDowloaded_PDF objectAtIndex:fileIndex]valueForKey:@"iPdfID"]];
             [DatabaseAccess updatetbl:strQueryDelete];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"PDFDeleted" object:strPath];
             [self extractFiles];
         }
    }
    else if (buttonIndex == 1)
    {
        return;
    }
}

#pragma mark - String Validation

-(NSString *)StringNotNullValidation:(NSString *)stringIp
{
    if(stringIp == nil)
    {
        return @"";
    }
    else if(stringIp == (id)[NSNull null] || [stringIp caseInsensitiveCompare:@"(null)"] == NSOrderedSame || [stringIp caseInsensitiveCompare:@"<null>"] == NSOrderedSame || [stringIp caseInsensitiveCompare:@""] == NSOrderedSame || [stringIp caseInsensitiveCompare:@"<nil>"] == NSOrderedSame || [stringIp length]==0)
    {
        return @"";
    }
    else
    {
        return [stringIp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


//Google AdBanner
-(void)addGoogleAd
{
    AbMob_DownloadView = [[GADBannerView alloc] init];
    [self.view bringSubviewToFront:AbMob_DownloadView];
    
    AbMob_DownloadView.adUnitID =@"a1514a9bada517c";
    AbMob_DownloadView.rootViewController = self;
    AbMob_DownloadView.delegate=self;
    
    [self setOrientationOfAddBanner];
    
    [adCustomView addSubview:AbMob_DownloadView];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = YES;
    [AbMob_DownloadView loadRequest:r];
}

#pragma mark - ADmob Method

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [adCustomView setHidden:NO];
        [btnCancelAd setHidden:NO];
    }
    else
    {
        [adCustomView setHidden:YES];
        [btnCancelAd setHidden:YES];
    }
    [self.view bringSubviewToFront:adCustomView];
    [self.view bringSubviewToFront:btnCancelAd];
}

-(void)setOrientationOfAddBanner
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        AbMob_DownloadView.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        AbMob_DownloadView.adSize = kGADAdSizeSmartBannerLandscape;
    }
}
- (IBAction)ClickBtnCancelAd:(id)sender
{
    [adCustomView setHidden:YES];
    [btnCancelAd setHidden:YES];
}

-(BOOL)pdfViewController:(YLPDFViewController *)controller tappedOnAnnotation:(YLAnnotation *)annotation
{
    NSRange textRange = [annotation.uri rangeOfString:@"galleryshow"];
    
    if(textRange.location != NSNotFound)
    {
        
        [AppDel doshowHUD];
        
        NSString *str_2 = [annotation.uri copy];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_2 stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
         {
             
             if (error)
             {
                 DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                 [AppDel dohideHUD];
                 return;
             }
             else
             {
                 NSError *err;
                 NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                 [AppDel dohideHUD];
                 ScrollGalleryViewController* objScrollGalleryViewController = [[ScrollGalleryViewController alloc]initWithNibName:@"ScrollGalleryViewController" bundle:nil];
                 objScrollGalleryViewController.arrayGalleryData = [[arr valueForKey:@"images"] mutableCopy];
                 [PDFViewCtr presentModalViewController:objScrollGalleryViewController animated:YES];
                 
             }
             
             
         }];
        
        
    }
    else
    {
        if ([annotation.uri length] > 0)
        {
            WebSiteViewController *obj_WebSiteViewController = [[WebSiteViewController alloc]initWithNibName:@"WebSiteViewController" bundle:nil];
            obj_WebSiteViewController.strLink = [NSString stringWithFormat:@"%@",annotation.uri];
            [PDFViewCtr presentModalViewController:obj_WebSiteViewController animated:YES];
        }
    }
    
    return YES;
}

@end
