//
//  DailyNewsViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "DailyNewsViewController.h"
#import "UIButton+WebCache.h"
#import "WebSiteViewController.h"

#define fontNameUsed @"Helvetica"
#define fontSizeUsed 13.0f
#define textColorOfLabels [UIColor darkGrayColor]
#define temporaryFileDestination [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Temporary Files"]
#define fileDestination [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Downloaded Files"]
#define interruptedDownloadsArrayFileDestination [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/InterruptedDownloadsFile/interruptedDownloads.txt"]
#define keyForTitle @"fileTitle"
#define keyForFileHandler @"filehandler"
#define keyForTimeInterval @"timeInterval"
#define keyForTotalFileSize @"totalfilesize"
#define keyForFileSizeInUnits @"fileSizeInUnits"
#define keyForRemainingFileSize @"remainigFileSize"

@implementation DailyNewsViewController

@synthesize popOverUserObj = _popOverUserObj;

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
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPDFDataAgain) name:@"loadPDFDataAgain" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PDFDeleted:) name:@"PDFDeleted" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [self LoadPdf];
    
    [self addGoogleAd];
    
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Load Pdf

-(void)loadPDFDataAgain
{
    if ([AppDel.downloadingArray count] > 0)
    {
        DisplayAlertWithTitle(App_Name, @"Download in progress. Please complete or cancel all downloads.");
    }
    else
    {
        [self LoadPdf];
    }
}

-(void)LoadPdf
{
    AppDel.arrPdf = [[NSMutableArray alloc]init];
    [self CancelAllDownloads];
    
        NSString *strEditionId = [[NSUserDefaults standardUserDefaults]valueForKey:@"iEditionID"];
        NSString *strZoneId = [[NSUserDefaults standardUserDefaults] valueForKey:@"iZoneID"];
        
        [AppDel doshowHUD];
        
        NSString *str_GetURL = [NSString stringWithFormat:@"%@c=pdf&func=getpdflite&iZoneID=%@&iEditionID=%@&dIssueDate=%@",WebURL,strZoneId,strEditionId,@""];
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_GetURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        
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
                 NSArray *arr = [[NSArray alloc]init];
                 arr = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                 if ([arr isKindOfClass:[NSArray class]])
                 {
                     if ([AppDel.arrPdf count] > 0)
                     {
                         [AppDel.arrPdf removeAllObjects];
                     }
                     for (int i = 0; i < [arr count]; i++)
                     {
                         [AppDel.arrPdf addObject:[arr objectAtIndex:i]];
                     }
                 }
                 [self LoadThumbnail];
             }
         }];
}
-(void)LoadThumbnail
{
    while ([scl_PDF.subviews count] > 0) {
        
        [[[scl_PDF subviews] objectAtIndex:0] removeFromSuperview];
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
    
    for (int i = 1; i <= [AppDel.arrPdf count]; i++)
    {
        if (i % module == 1)
        {
            UIImageView *imgStand = [[UIImageView alloc]init];
            imgStand.image = [UIImage imageNamed:@"L-stand.png"];
            imgStand.frame = CGRectMake(0, yAxis + 205, width, 47);
            //imgStand.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [scl_PDF addSubview:imgStand];
        }
        
        UIView *viewPDF = [[UIView alloc]init];
        viewPDF.backgroundColor = [UIColor clearColor];
        
        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [lblDate setTag:1000];
        [lblDate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        [lblDate setBackgroundColor:[UIColor blackColor]];
        [lblDate setTextColor:[UIColor whiteColor]];
        lblDate.textAlignment = NSTextAlignmentCenter;
        
        lblDate.text = [self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:i-1]valueForKey:@"dIssueDate"]];
        
        [viewPDF addSubview:lblDate];
        
        lblDate.layer.cornerRadius = 5;
        
        UIButton *btnThumbnail = [UIButton buttonWithType:UIButtonTypeCustom];
        btnThumbnail.frame = CGRectMake(0,  50, 130, 170);
        NSString *strImgUrl = [self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:i-1]valueForKey:@"vFileNameThumb"]];
        [btnThumbnail setImageWithURL:[NSURL URLWithString:strImgUrl] forState:UIControlStateNormal];
        [btnThumbnail addTarget:self action:@selector(btnThumbnailPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnThumbnail.tag = 1001;
        btnThumbnail.backgroundColor = [UIColor clearColor];
        [viewPDF addSubview:btnThumbnail];
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.frame = CGRectMake(0, 120, 130, 9);
        progressView.hidden = YES;
        [progressView setTag:1002];
        [progressView setProgress:0.0f];
        progressView.progressTintColor = [UIColor whiteColor];
        progressView.trackTintColor = [UIColor blackColor];
        [viewPDF addSubview:progressView];
        
        UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDownload.frame = CGRectMake(20, 140, 118, 35);
        [btnDownload setTitle:@"Download" forState:UIControlStateNormal];
        [btnDownload setBackgroundColor:[UIColor clearColor]];
        [btnDownload setImage:[UIImage imageNamed:@"downloadPdf.png"] forState:UIControlStateNormal];
        [btnDownload addTarget:self action:@selector(btnDownloadPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnDownload.tag = 1003;
        [viewPDF addSubview:btnDownload];
        
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(19, 180, 118, 35);
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel setBackgroundColor:[UIColor clearColor]];
        [btnCancel setImage:[UIImage imageNamed:@"canceldownload.png"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnCancel.tag = 1004;
        btnCancel.hidden = YES;
        [viewPDF addSubview:btnCancel];
        
        UIImageView *imgCheckUncheck = [[UIImageView alloc]init];
        imgCheckUncheck.image = [UIImage imageNamed:@"uncheck_box.png"];
        imgCheckUncheck.frame = CGRectMake(0, 200, 20, 20);
        imgCheckUncheck.hidden = YES;
        imgCheckUncheck.tag = 1005;
        [viewPDF addSubview:imgCheckUncheck];
        
        NSString *strPath = [[AppDel.arrPdf objectAtIndex:i-1]valueForKey:@"vFileName"];
        BOOL FileexistPath = [self PDFFileExistAtPath:[strPath lastPathComponent]];
        
        if (FileexistPath)
        {
            btnDownload.hidden = YES;
            btnCancel.hidden = YES;
            progressView.hidden = YES;
            progressView.progress = 0.0;
            imgCheckUncheck.image = [UIImage imageNamed:@"check_box.png"];
            imgCheckUncheck.hidden = NO;
        }
        
        
        viewPDF.tag = i;
        viewPDF.frame = CGRectMake(xAxis, yAxis, 130, 250);
        [scl_PDF addSubview:viewPDF];
        
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
    
    NSInteger lastpageoffset = [AppDel.arrPdf count] % module;
    NSInteger pagecounts = [AppDel.arrPdf count] /module+((lastpageoffset==0)?0:1);
    scl_PDF.contentSize=CGSizeMake(width,290*pagecounts);
    [AppDel dohideHUD];
}

-(void)SetThumbnailFrameWhileOrientation
{
    NSMutableArray *ArryViews = [[NSMutableArray alloc]init];
    for (UIView *view in scl_PDF.subviews)
    {
        if ([view isKindOfClass:[UIView class]] && ![view isKindOfClass:[UIImageView class]])
        {
            [ArryViews addObject:view];
        }
        else if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    if ([ArryViews count] > 0)
    {
        int yAxisView = 0;
        int xAxisView;
        
        int module = 3;
        int width = 728;
        
        if (flagOrientation == 1)
        {
            module = 4;
            width = 984;
            xAxisView = 80;
        }
        else
        {
            module = 3;
            width = 728;
            xAxisView = 70;
        }
        
        for (int i = 1; i <= ArryViews.count; i++)
        {
            if (i % module == 1)
            {
                UIImageView *imgStand = [[UIImageView alloc]init];
                imgStand.image = [UIImage imageNamed:@"L-stand.png"];
                imgStand.frame = CGRectMake(0, yAxisView + 205, width, 47);
                //imgStand.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                [scl_PDF addSubview:imgStand];
                [scl_PDF sendSubviewToBack:imgStand];
            }
            
            UIView *view = [ArryViews objectAtIndex:i-1];
            view.frame = CGRectMake(xAxisView, yAxisView, 130, 250);
            
            if (i % module == 0)
            {
                yAxisView = yAxisView + 290;
                
                if (flagOrientation == 1)
                    xAxisView = 80;
                else
                    xAxisView = 70;
            }
            else
            {
                xAxisView = xAxisView + 230;
            }
            
        }
        
        NSInteger lastpageoffset = [ArryViews count] % module;
        NSInteger pagecounts = [ArryViews count] /module+((lastpageoffset==0)?0:1);
        scl_PDF.contentSize = CGSizeMake(width,290*pagecounts);
    }
}

#pragma mark - Button Action

-(IBAction)ClickBtnRefresh:(id)sender
{
    if ([AppDel.downloadingArray count] > 0)
    {
        DisplayAlertWithTitle(App_Name, @"Download in progress. Please complete or cancel all downloads.");
    }
    else
    {
        [self LoadPdf];
    }
}



#pragma mark - Gesture delegate Methods
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
    
    
    [self SetThumbnailFrameWhileOrientation];

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


#pragma mark - Download PDF
-(IBAction)btnThumbnailPressed:(id)sender
{
    UIView *SuperViewPdf = (UIView *)[sender superview];
    int SuperViewPdfTag = SuperViewPdf.tag;
    
    NSString *strPath = [[AppDel.arrPdf objectAtIndex:SuperViewPdfTag-1]valueForKey:@"vFileName"];
    BOOL FileexistPath = [self PDFFileExistAtPath:[strPath lastPathComponent]];
    
    if (FileexistPath)
    {
        PDFViewCtr = [[YLPDFViewController alloc] initWithDocument:[self document:[strPath lastPathComponent]]] ;
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
    
        
        [self presentModalViewController:PDFViewCtr animated:YES];
        //[self.navigationController pushViewController:PDFViewCtr animated:<#(BOOL)#>]
    }
}
-(IBAction)btnDownloadPressed:(id)sender
{
    if (![AppDel checkConnection])
    {
        DisplayAlertWithTitle(App_Name, @"No internet connection.You can not download.");
        return;
    }
    else
    {
        UIView *SuperViewPdf = (UIView *)[sender superview];
        int SuperViewPdfTag = SuperViewPdf.tag;

            if([[[AppDel.arrPdf objectAtIndex:SuperViewPdfTag-1] valueForKey:@"link_status"] isEqualToString:@"ok"])
            {
                if([[sender titleForState:UIControlStateNormal] isEqualToString:@"Download"])
                {
                    NSString *strPDFThumb = [NSString stringWithFormat:@"%@",[self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:SuperViewPdf.tag-1]valueForKey:@"vFileNameThumb"]]];
                    
                    NSString *strPDFPath = [NSString stringWithFormat:@"%@",[self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:SuperViewPdf.tag-1]valueForKey:@"vFileName"]]];
                    
                    [AppDel doshowHUD];
                    
                    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSURL *url = [NSURL URLWithString:strPDFThumb];
                        
                        BOOL DataExist = NO;
                        
                        if([NSData dataWithContentsOfURL:url options:kNilOptions error:nil])
                        {
                            DataExist = YES;
                        }
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            
                            if(DataExist)
                            {
                                [AppDel dohideHUD];
                                [SuperViewPdf.subviews enumerateObjectsUsingBlock:^(UIView *cellSubView, NSUInteger index, BOOL *stop)
                                 {
                                     if(cellSubView.tag == 1002)
                                     {
                                         UIProgressView *progressView = (UIProgressView *)cellSubView;
                                         progressView.hidden = NO;
                                     }
                                     else if(cellSubView.tag == 1003)
                                     {
                                         UIButton *btnDownload = (UIButton*)cellSubView;
                                         [btnDownload setTitle:@"Pause" forState:UIControlStateNormal];
                                         [btnDownload setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
                                         [self addDownloadRequest:strPDFPath];
                                     }
                                     else if (cellSubView.tag == 1004)
                                     {
                                         UIButton *CancelButton = (UIButton *)cellSubView;
                                         CancelButton.hidden = NO;
                                     }
                                 }];
                            } else
                            {
                                [AppDel dohideHUD];
                                DisplayAlertWithTitle(App_Name, @"File does not exist.");
                            }
                        });
                    });
                    
                }
                else
                {
                    int index = [self ReurnIndexofArrayDownload:[self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:SuperViewPdfTag-1]valueForKey:@"vFileName"]]];
                    
                    if([[sender titleForState:UIControlStateNormal] isEqualToString:@"Pause"])
                    {
                        [sender setTitle:@"Resume" forState:UIControlStateNormal];
                        [sender setImage:[UIImage imageNamed:@"Resume.png"] forState:UIControlStateNormal];
                        [self downloadRequestPaused:[AppDel.downloadingArray objectAtIndex:index]];
                        [[AppDel.downloadingArray objectAtIndex:index] cancel];
                    }
                    else
                    {
                        [sender setTitle:@"Pause" forState:UIControlStateNormal];
                        [sender setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
                        [self resumeInterruptedDownloads:index :[[[AppDel.downloadingArray objectAtIndex:index]url]absoluteString]];
                    }
                }
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error in document file path" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
    }
}
-(void)addDownloadRequest:(NSString *)urlString
{
    [self initializeDownloadingArrayIfNot];
    [self createDirectoryIfNotExistAtPath:temporaryFileDestination];
    [self createDirectoryIfNotExistAtPath:fileDestination];
    
    [self createDirectoryIfNotExistAtPath:[interruptedDownloadsArrayFileDestination stringByDeletingLastPathComponent]];
    [self createTemporaryFile:interruptedDownloadsArrayFileDestination];
    [self writeURLStringToFileIfNotExistForResumingPurpose:urlString];
    
    [self insertTableviewCellForRequest:[self initializeRequestAndSetProperties:urlString isResuming:NO]];
}
-(void)initializeDownloadingRequestsQueueIfNot
{
    if(!downloadingRequestsQueue)
        downloadingRequestsQueue = [[NSOperationQueue alloc] init];
}
-(void)updateProgressForCell:(UIView *)cell withRequest:(ASIHTTPRequest *)request
{
    NSFileHandle *fileHandle = [request.userInfo objectForKey:keyForFileHandler];
    if(fileHandle)
    {
        unsigned long long partialContentLength = [fileHandle offsetInFile];
        unsigned long long totalContentLenght = [[request.userInfo objectForKey:keyForTotalFileSize] unsignedLongLongValue];
        
        float percentComplete = (float)partialContentLength/totalContentLenght*100;
        float progressForProgressView = percentComplete / 100;
        
        [cell.subviews enumerateObjectsUsingBlock:^(UIView *cellSubView, NSUInteger index, BOOL *stop)
        {
            if(cellSubView.tag == 1002)
            {
                UIProgressView *progressView = (UIProgressView *)cellSubView;
                progressView.progress = progressForProgressView;
            }
        }];
    }
}
-(void)resumeInterruptedDownloads:(int)indexPath :(NSString *)urlString
{
    ASIHTTPRequest *request = [self initializeRequestAndSetProperties:urlString isResuming:YES];
    unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:request.temporaryFileDownloadPath error:Nil] fileSize];
    if(size != 0)
    {
        NSString* range = @"bytes=";
        range = [range stringByAppendingString:[[NSNumber numberWithInt:size] stringValue]];
        range = [range stringByAppendingString:@"-"];
        [request addRequestHeader:@"Range" value:range];
    }
    if(indexPath>=0)
    {
        [AppDel.downloadingArray replaceObjectAtIndex:indexPath withObject:request];
        [downloadingRequestsQueue addOperation:request];
    }
    else
    {
        [self insertTableviewCellForRequest:request];
    }
}
-(void)insertTableviewCellForRequest:(ASIHTTPRequest *)request
{
    if(AppDel.downloadingArray.count == 0)
    {
        [AppDel.downloadingArray addObject:request];
        [downloadingRequestsQueue addOperation:request];
    }
    else
    {
        [AppDel.downloadingArray addObject:request];
        [downloadingRequestsQueue addOperation:request];
    }
}
-(void)writeURLStringToFileIfNotExistForResumingPurpose:(NSString *)urlString
{
    NSMutableArray *interruptedDownloads = [NSMutableArray arrayWithContentsOfFile:interruptedDownloadsArrayFileDestination];
    if(!interruptedDownloads)
        interruptedDownloads = [[NSMutableArray alloc] init];
    if(![interruptedDownloads containsObject:urlString])
    {
        [interruptedDownloads addObject:urlString];
        [interruptedDownloads writeToFile:interruptedDownloadsArrayFileDestination atomically:YES];
    }
}
-(void)removeURLStringFromInterruptedDownloadFileIfRequestCancelByTheUser:(NSString *)urlString
{
    NSMutableArray *interruptedDownloads = [NSMutableArray arrayWithContentsOfFile:interruptedDownloadsArrayFileDestination];
    [interruptedDownloads removeObject:urlString];
    [interruptedDownloads writeToFile:interruptedDownloadsArrayFileDestination atomically:YES];
}
-(void)removeRequest:(ASIHTTPRequest *)request :(int)indexPath
{
    [AppDel.downloadingArray removeObject:request];
}
-(void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
}
-(void)resumeAllInterruptedDownloads
{
    [self initializeDownloadingArrayIfNot];
    NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:interruptedDownloadsArrayFileDestination];
    for(int i=0;i<tempArray.count;i++)
        [self resumeInterruptedDownloads:-1 :[tempArray objectAtIndex:i]];
}
#pragma mark - My IBActions -
-(IBAction)cancelButtonTapped:(UIButton *)sender
{
    UIView *SuperViewPdf = (UIView *)[sender superview];
    int SuperViewPdfTag = SuperViewPdf.tag;

    int index = [self ReurnIndexofArrayDownload:[self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:SuperViewPdfTag-1]valueForKey:@"vFileName"]]];
    
    [self removeURLStringFromInterruptedDownloadFileIfRequestCancelByTheUser:[[[AppDel.downloadingArray objectAtIndex:index]url]absoluteString]];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[[AppDel.downloadingArray objectAtIndex:index] temporaryFileDownloadPath] error:&error];
    if(error)
        NSLog(@"Error while deleting filehandle %@",error);
    
    [self downloadRequestCanceled:[AppDel.downloadingArray objectAtIndex:index]];
    [[AppDel.downloadingArray objectAtIndex:index] cancel];
    [self removeRequest:[AppDel.downloadingArray objectAtIndex:index] :index];
}
-(IBAction)pauseButtonTapped:(UIButton *)sender
{
    UIView *SuperViewPdf = (UIView *)[sender superview];
    int SuperViewPdfTag = SuperViewPdf.tag;
    
    int index = [self ReurnIndexofArrayDownload:[self StringNotNullValidation:[[AppDel.arrPdf objectAtIndex:SuperViewPdfTag-1]valueForKey:@"vFileName"]]];
    
    if([[sender titleForState:UIControlStateNormal] isEqualToString:@"Pause"])
    {
        [sender setTitle:@"Resume" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Resume.png"] forState:UIControlStateNormal];
        [self downloadRequestPaused:[AppDel.downloadingArray objectAtIndex:index]];
        [[AppDel.downloadingArray objectAtIndex:index] cancel];
    }
    else
    {
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
        [self resumeInterruptedDownloads:index :[[[AppDel.downloadingArray objectAtIndex:index]url]absoluteString]];
    }
}
#pragma mark - ASIHTTPRequest Delegate -
-(void)requestStarted:(ASIHTTPRequest *)request
{
    [self downloadRequestStarted:request];
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    [AppDel.downloadingArray enumerateObjectsUsingBlock:^(ASIHTTPRequest *req, NSUInteger index, BOOL *stop){
        if([req isEqual:request])
        {
            NSFileHandle *fileHandle = [req.userInfo objectForKey:keyForFileHandler];
            if(!fileHandle)
            {
                if(![req requestHeaders])
                {
                    fileHandle = [NSFileHandle fileHandleForWritingAtPath:req.temporaryFileDownloadPath];
                    [req.userInfo setValue:fileHandle forKey:keyForFileHandler];
                }
            }
            long long length = [[req.userInfo objectForKey:keyForTotalFileSize] longLongValue];
            if(length == 0)
            {
                length = [req contentLength];
                if (length != NSURLResponseUnknownLength)
                {
                    NSNumber *totalSize = [NSNumber numberWithUnsignedLongLong:(unsigned long long)length];
                    [req.userInfo setValue:totalSize forKey:keyForTotalFileSize];
                }
                [req.userInfo setValue:[NSDate date] forKey:keyForTimeInterval];
            }
            if([request requestHeaders])
            {
                NSString *range = [[request requestHeaders] objectForKey:@"Range"];
                NSString *numbers = [range stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
                unsigned long long size = [numbers longLongValue];
                
                if(length != 0)
                {
                    [req.userInfo setValue:[NSNumber numberWithUnsignedLongLong:length] forKey:keyForRemainingFileSize];
                    length = length + size;
                    NSNumber *totalSize = [NSNumber numberWithUnsignedLongLong:(unsigned long long)length];
                    [req.userInfo setValue:totalSize forKey:keyForTotalFileSize];
                    
                    
                    fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:req.temporaryFileDownloadPath];
                    [req.userInfo setValue:fileHandle forKey:keyForFileHandler];
                    [fileHandle seekToFileOffset:size];
                }
            }
            
            int indexView = [self ReurnIndexofArrayMain:[[req url] absoluteString]];
            UIView *view = (UIView*)[scl_PDF viewWithTag:indexView+1];
            [self updateProgressForCell:view withRequest:req];
            
            [self  downloadRequestReceivedResponseHeaders:request responseHeaders:responseHeaders];
            *stop = YES;
        }
    }];
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [AppDel.downloadingArray enumerateObjectsUsingBlock:^(ASIHTTPRequest *req, NSUInteger index, BOOL *stop){
        if([req isEqual:request])
        {
            NSFileHandle *fileHandle = [req.userInfo objectForKey:keyForFileHandler];
			[fileHandle writeData:data];
            
            int indexView = [self ReurnIndexofArrayMain:[[req url] absoluteString]];
            UIView *view = (UIView*)[scl_PDF viewWithTag:indexView+1];
            [self updateProgressForCell:view withRequest:req];
            *stop = YES;
        }
    }];
}
-(void)requestDone:(ASIHTTPRequest *)request
{
    [self removeURLStringFromInterruptedDownloadFileIfRequestCancelByTheUser:request.url.absoluteString];
    [self removeRequest:request :[AppDel.downloadingArray indexOfObject:request]];
   
    [self downloadRequestFinished:request];
}
- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    if([request.error.localizedDescription isEqualToString:@"The request was cancelled"])
    {
        
    }
    else
    {
       // [self showAlertViewWithMessage:request.error.localizedDescription];
        
        int indexView = [self ReurnIndexofArrayMain:[[request url] absoluteString]];
        UIView *cell = (UIView*)[scl_PDF viewWithTag:indexView+1];
        
        [cell.subviews enumerateObjectsUsingBlock:^(UIView *cellSubview, NSUInteger index, BOOL *stop){
            if(cellSubview.tag == 1003)
            {
                UIButton *pauseButton = (UIButton *)cellSubview;
                [pauseButton setTitle:@"Retry" forState:UIControlStateNormal];
                [pauseButton setImage:[UIImage imageNamed:@"retrydownload.png"] forState:UIControlStateNormal];
                *stop = YES;
            }
            else if (cellSubview.tag == 1004)
            {
                UIButton *CancelButton = (UIButton *)cellSubview;
                CancelButton.hidden = NO;
            }
            else if (cellSubview.tag == 1005)
            {
                UIImageView *CheckUncheckImg = (UIImageView *)cellSubview;
                CheckUncheckImg.hidden = YES;
                CheckUncheckImg.image = [UIImage imageNamed:@"check_box.png"];
            }
        }];
    }
    
    [self downloadRequestFailed:request];
}
-(ASIHTTPRequest *)initializeRequestAndSetProperties:(NSString *)urlString isResuming:(BOOL)isResuming
{
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setTimeOutSeconds:60.0];
    
    if(!request.userInfo)
        request.userInfo = [[NSMutableDictionary alloc] init];
    NSString *fileName = [request.userInfo objectForKey:keyForTitle];
    
    if(!fileName)
    {
        fileName = [request.url.absoluteString lastPathComponent];
        [request.userInfo setValue:fileName forKey:keyForTitle];
    }
    
    NSString *temporaryDestinationPath = [NSString stringWithFormat:@"%@/%@.download",temporaryFileDestination,fileName];
    [request setTemporaryFileDownloadPath:temporaryDestinationPath];
    if(!isResuming)
        [self createTemporaryFile:request.temporaryFileDownloadPath];
    
    [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@",fileDestination,fileName]];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [self initializeDownloadingRequestsQueueIfNot];
    return request;
}
#pragma mark - My Methods -
-(void)initializeDownloadingArrayIfNot
{
    if(!AppDel.downloadingArray)
        AppDel.downloadingArray = [[NSMutableArray alloc] init];
}
-(void)createDirectoryIfNotExistAtPath:(NSString *)path
{
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    
    BOOL DoNotBackUp = [self addSkipBackupAttributeToItemAtPath:path];
    
    if (DoNotBackUp)
        NSLog(@"Success");
    else
        NSLog(@"Failed");
    
    if(error)
        NSLog(@"Error while creating directory %@",[error localizedDescription]);
}
-(void)createTemporaryFile:(NSString *)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:path contents:Nil attributes:Nil];
        
        BOOL DoNotBackUp = [self addSkipBackupAttributeToItemAtPath:path];
        
        if (DoNotBackUp)
            NSLog(@"Success");
        else
            NSLog(@"Failed");
        
        if(!success)
            NSLog(@"Failed to create file");
        else {
            NSLog(@"success");
        }
    }
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL *fileURL = [NSURL fileURLWithPath:filePathString];
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return success;
}

#pragma mark - DownLoad Delegate MEthod for Start,Receive,Finish,Fail,Pause,Cancel

-(void)downloadRequestStarted:(ASIHTTPRequest *)request
{
}
-(void)downloadRequestReceivedResponseHeaders:(ASIHTTPRequest *)request responseHeaders:(NSDictionary *)responseHeaders
{
}
-(void)downloadRequestFinished:(ASIHTTPRequest *)request
{
    int index = [self ReurnIndexofArrayMain:[[request url] absoluteString]];
    UIView *view = (UIView*)[scl_PDF viewWithTag:index+1];
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *cellSubview, NSUInteger index, BOOL *stop)
    {
        if(cellSubview.tag == 1002)
        {
            UIProgressView *progressView = (UIProgressView *)cellSubview;
            progressView.hidden = YES;
            progressView.progress = 0.0f;
        }
        else if(cellSubview.tag == 1003)
        {
            UIButton *DownloadButton = (UIButton *)cellSubview;
            DownloadButton.hidden = YES;
            [DownloadButton setTitle:@"Download" forState:UIControlStateNormal];
            [DownloadButton setImage:[UIImage imageNamed:@"downloadPdf.png"] forState:UIControlStateNormal];
        }
        else if (cellSubview.tag == 1004)
        {
            UIButton *CancelButton = (UIButton *)cellSubview;
            CancelButton.hidden = YES;
        }
        else if (cellSubview.tag == 1005)
        {
            UIImageView *CheckUncheckImg = (UIImageView *)cellSubview;
            CheckUncheckImg.hidden = NO;
            CheckUncheckImg.image = [UIImage imageNamed:@"check_box.png"];
        }
       
    }];
    NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into Downloaded_List(iPdfID,vTitle,tDescription,vFileName,vPdfImage,iZoneID,dIssueDate,iEditionID,vAuthor,eStatus,dModification,tCreationDate,vFileNameThumb,vDownload,link_status,Test1,Test2,Test3,Test4,Test5) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"iPdfID"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vTitle"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"tDescription"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vFileName"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vPdfImage"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"iZoneID"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"dIssueDate"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"iEditionID"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vAuthor"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"eStatus"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"dModification"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"tCreationDate"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vFileNameThumb"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"vDownload"],[[AppDel.arrPdf objectAtIndex:index]valueForKey:@"link_status"],@"",@"",@"",@"",@""];
    [DatabaseAccess updatetbl:strQueryInsertMessage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"extractFilesNotification" object:nil];
    
}
-(void)downloadRequestFailed:(ASIHTTPRequest *)request
{
    if([request.error.localizedDescription isEqualToString:@"The request was cancelled"])
    {
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:request.error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        int indexView = [self ReurnIndexofArrayMain:[[request url] absoluteString]];
        UIView *cell = (UIView*)[scl_PDF viewWithTag:indexView+1];
        
        [cell.subviews enumerateObjectsUsingBlock:^(UIView *cellSubview, NSUInteger index, BOOL *stop){
            if(cellSubview.tag == 1003)
            {
                UIButton *pauseButton = (UIButton *)cellSubview;
                [pauseButton setTitle:@"Retry" forState:UIControlStateNormal];
                [pauseButton setImage:[UIImage imageNamed:@"retrydownload.png"] forState:UIControlStateNormal];
                *stop = YES;
            }
            else if (cellSubview.tag == 1004)
            {
                UIButton *CancelButton = (UIButton *)cellSubview;
                CancelButton.hidden = NO;
            }
            else if (cellSubview.tag == 1005)
            {
                UIImageView *CheckUncheckImg = (UIImageView *)cellSubview;
                CheckUncheckImg.hidden = YES;
                CheckUncheckImg.image = [UIImage imageNamed:@"check_box.png"];
            }
        }];
    }
}
-(void)downloadRequestPaused:(ASIHTTPRequest *)request
{
}
-(void)downloadRequestCanceled:(ASIHTTPRequest *)request
{
    int index = [self ReurnIndexofArrayMain:[[request url] absoluteString]];
    UIView *view = (UIView*)[scl_PDF viewWithTag:index+1];
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *cellSubview, NSUInteger index, BOOL *stop)
     {
         if(cellSubview.tag == 1002)
         {
             UIProgressView *progressView = (UIProgressView *)cellSubview;
             progressView.progress = 0.0;
             progressView.hidden = YES;
         }
         else if(cellSubview.tag == 1003)
         {
             UIButton *DownloadButton = (UIButton *)cellSubview;
             DownloadButton.hidden = NO;
             [DownloadButton setTitle:@"Download" forState:UIControlStateNormal];
             [DownloadButton setImage:[UIImage imageNamed:@"downloadPdf.png"] forState:UIControlStateNormal];
         }
         else if (cellSubview.tag == 1004)
         {
             UIButton *CancelButton = (UIButton *)cellSubview;
             CancelButton.hidden = YES;
         }
         
     }];
}

#pragma mark - Get Index
-(int)ReurnIndexofArrayDownload:(NSString*)strUrl
{
    for (int i = 0; i < [AppDel.downloadingArray count]; i++)
    {
        NSString *strDownloadURL = [[[AppDel.downloadingArray objectAtIndex:i]url]absoluteString];
        if ([strDownloadURL isEqualToString:strUrl])
        {
            return i;
        }
    }
    return 0;
}
-(int)ReurnIndexofArrayMain:(NSString*)strUrl
{
    for (int i = 0; i < [AppDel.arrPdf count]; i++)
    {
        NSString *strMainURL = [[AppDel.arrPdf objectAtIndex:i]valueForKey:@"vFileName"];
        if ([strMainURL isEqualToString:strUrl])
        {
            return i;
        }
    }
    return 0;
}

#pragma mark - Get Document For Display
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

// Deleted PDF
-(void)PDFDeleted:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PDFDeleted"])
    {
    
        for (int i = 0; i < [AppDel.arrPdf count]; i++)
        {
            NSString *strPDFLink = [NSString stringWithFormat:@"%@",[[[AppDel.arrPdf objectAtIndex:i]valueForKey:@"vFileName"] lastPathComponent]];
            if ([strPDFLink isEqualToString:[notification object]])
            {
                UIView *view = (UIView *)[scl_PDF viewWithTag:i+1];
                UIButton *btnDownload = (UIButton*)[view viewWithTag:1003];
                btnDownload.hidden = NO;
                
                UIImageView *checkuncheckImg = (UIImageView*)[view viewWithTag:1005];
                checkuncheckImg.image = [UIImage imageNamed:@"uncheck_box.png"];
                checkuncheckImg.hidden = YES;
            }
            
        }
    }
}
-(void)CancelAllDownloads
{
    for (int i = 0; i < [AppDel.downloadingArray count]; i++)
    {
        [self removeURLStringFromInterruptedDownloadFileIfRequestCancelByTheUser:[[[AppDel.downloadingArray objectAtIndex:i]url]absoluteString]];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[[AppDel.downloadingArray objectAtIndex:i] temporaryFileDownloadPath] error:&error];
        if(error)
            NSLog(@"Error while deleting filehandle %@",error);
        
        [[AppDel.downloadingArray objectAtIndex:i] cancel];
        [self removeRequest:[AppDel.downloadingArray objectAtIndex:i] :i];
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
    AbMob_PDFView = [[GADBannerView alloc] init];
    [self.view bringSubviewToFront:AbMob_PDFView];
    
    AbMob_PDFView.adUnitID =@"a1514a9bada517c";
    AbMob_PDFView.rootViewController = self;
    AbMob_PDFView.delegate=self;
    
    [self setOrientationOfAddBanner];
    
    [adCustomView addSubview:AbMob_PDFView];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = YES;
    [AbMob_PDFView loadRequest:r];
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
        AbMob_PDFView.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        AbMob_PDFView.adSize = kGADAdSizeSmartBannerLandscape;
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
                 
                 if([[arr valueForKey:@"images"] count]>0)
                 {
                     ScrollGalleryViewController* objScrollGalleryViewController = [[ScrollGalleryViewController alloc]initWithNibName:@"ScrollGalleryViewController" bundle:nil];
                     objScrollGalleryViewController.arrayGalleryData = [[arr valueForKey:@"images"] mutableCopy];
                     [PDFViewCtr presentModalViewController:objScrollGalleryViewController animated:YES];
                 }
                 else
                 {
                     DisplayAlertWithTitle(App_Name, @"There are no images in gallery.");
                 }
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
