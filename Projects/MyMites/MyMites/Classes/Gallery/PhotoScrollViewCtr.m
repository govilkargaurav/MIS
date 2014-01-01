//
//  PhotoScrollViewCtr.m
//  MyMites
//
//  Created by Apple-Openxcell on 9/27/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "PhotoScrollViewCtr.h"
#import "ImageViewURL.h"
#import "BusyAgent.h"
#import "JSON.h"
#import "AppConstat.h"

@implementation PhotoScrollViewCtr
@synthesize indexclick;
@synthesize DicPhoto;
const CGFloat kScrollObjHeight	= 350.0;
const CGFloat kScrollObjWidth	= 320.0;

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
    indexclick = 0;
    [self ReloadAllView];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDeletePressed:(id)sender
{
    [self performSelectorInBackground:@selector(activityRunning) withObject:self];
}
-(void)activityRunning
{
    @autoreleasepool 
    {
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        NSString *urlString=[NSString stringWithFormat:@"%@webservices/delete_gallery.php?iImageID=%@",APP_URL,[[[DicPhoto valueForKey:@"gallery"] objectAtIndex:indexclick]  valueForKey:@"iImageID"]];
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
        [request2 setURL:[NSURL URLWithString:urlString]];
        NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:nil error:nil];  
        NSString *responseString1 = [[NSString alloc] initWithData:responseData1 encoding: NSUTF8StringEncoding];
        NSDictionary* responseDict = [responseString1 JSONValue];
        NSLog(@"%@",responseDict);
    }
    [self performSelectorOnMainThread:@selector(GetAllPhoto) withObject:nil waitUntilDone:YES]; 
}
-(void)GetAllPhoto
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    [self CallURL]; 
}
-(void)ReloadAllView
{
    while ([scl_Photo.subviews count] > 0) {
        
        [[[scl_Photo subviews] objectAtIndex:0] removeFromSuperview];
    }
    if ([[DicPhoto valueForKey:@"gallery"] count]==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self CallCountImg];
    [scl_Photo setBackgroundColor:[UIColor blackColor]];
	[scl_Photo setCanCancelContentTouches:NO];
    scl_Photo.delegate=self;
	scl_Photo.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	scl_Photo.clipsToBounds = YES;
	scl_Photo.scrollEnabled = YES;
	scl_Photo.pagingEnabled = YES;
    
	NSUInteger i;
	for (i = 1; i <= [[DicPhoto valueForKey:@"gallery"] count]; i++)
	{
        webview = [[UIWebView alloc]init];
        CGRect rect = webview.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		webview.frame = rect;
        NSString *urlAddress = [NSString stringWithFormat:@"%@",[[[DicPhoto valueForKey:@"gallery"] objectAtIndex:i-1]  valueForKey:@"vGalleryImg"]];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSString *htmlString = [NSString stringWithFormat:
                                @"<html>"
                                "<head>"
                                "<script type=\"text/javascript\" >"
                                "function display(img){"
                                "var imgOrigH = document.getElementById('image').offsetHeight;"
                                "var imgOrigW = document.getElementById('image').offsetWidth;"
                                "var bodyH = window.innerHeight;"
                                "var bodyW = window.innerWidth;"
                                "if((imgOrigW/imgOrigH) > (bodyW/bodyH))"
                                "{"
                                "document.getElementById('image').style.width = bodyW + 'px';"
                                "document.getElementById('image').style.top = (bodyH - document.getElementById('image').offsetHeight)/2  + 'px';"
                                "}"
                                "else"
                                "{"
                                "document.getElementById('image').style.height = bodyH + 'px';"
                                "document.getElementById('image').style.marginLeft = (bodyW - document.getElementById('image').offsetWidth)/2  + 'px';"
                                "}"
                                "}"
                                "</script>"                         
                                "</head>"
                                "<body style=\"margin:0;\" bgcolor=\"#000000\" >"
                                "<img id=\"image\" src=\"%@\" onload=\"display()\" style=\"position:relative\" />"
                                "</body>"
                                "</html>",url
                                ];
        [webview loadHTMLString:htmlString baseURL:nil];
        webview.scalesPageToFit = YES;
        webview.delegate=self;
        webview.tag = i;
		[scl_Photo addSubview:webview];
        
        txtDesc = [[UITextView alloc]init];
        CGRect rect1 = webview.frame;
		rect1.size.height = 40;
		rect1.size.width = 320;
		txtDesc.frame = rect1;
        txtDesc.backgroundColor = [UIColor clearColor];
        txtDesc.textColor = [UIColor whiteColor];
        txtDesc.font = [UIFont systemFontOfSize:14.0f];
        txtDesc.tag = i;
        txtDesc.editable = NO;
        txtDesc.textAlignment = UITextAlignmentCenter;
        txtDesc.text = [NSString stringWithFormat:@"%@",[[[DicPhoto valueForKey:@"gallery"] objectAtIndex:i-1]  valueForKey:@"vGallerydesc"]];
        [scl_Photo addSubview:txtDesc];
	}
	
	[self layoutScrollImages]; 
}
-(void)CallCountImg
{
    lblTitle.text=[NSString stringWithFormat:@"%d of %d",indexclick + 1,[[DicPhoto valueForKey:@"gallery"] count]];
}
- (void)layoutScrollImages
{
	UIWebView *view = nil;
    UITextView *view1 = nil;
	NSArray *subviews = [scl_Photo subviews];
    
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIWebView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 50);
			view.frame = frame;
			view.userInteractionEnabled=YES;
			curXLoc += (kScrollObjWidth);
		}
	}
    CGFloat curXLoc1 = 0;
	for (view1 in subviews)
	{
		if ([view1 isKindOfClass:[UITextView class]] && view1.tag > 0)
		{
			CGRect frame = view1.frame;
			frame.origin = CGPointMake(curXLoc1, 350);
			view1.frame = frame;
			view1.userInteractionEnabled=YES;
			curXLoc1 += (kScrollObjWidth);
		}
	}
    
	[scl_Photo setContentOffset:CGPointMake(indexclick * kScrollObjWidth, 0)];
	[scl_Photo setContentSize:CGSizeMake(([[DicPhoto valueForKey:@"gallery"] count] * kScrollObjWidth), kScrollObjHeight)];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexaddminus = scrollView.contentOffset.x /  kScrollObjWidth;
    indexclick = indexaddminus ;
    [self CallCountImg];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
-(void)webViewDidStartLoad:(UIWebView *)webView 
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES; 
}

-(void)webViewDidFinishLoad:(UIWebView *)webView 
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; 
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
}

-(void)CallURL
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    DicPhoto=[[NSDictionary alloc]init];
    NSString *strLogin=[NSString stringWithFormat:@"%@webservices/gallery.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
}
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    DicPhoto = [responseString JSONValue];
    if (indexclick == 0)
    {
        indexclick=0;
    }
    else
    {
        indexclick--;
    }
     [self ReloadAllView];
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
