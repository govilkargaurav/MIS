//
//  LearningInfoViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 12/6/12.
//
//

#import "LearningInfoViewController.h"
#import "GTMNSString+HTML.h"
@interface LearningInfoViewController ()

@end

@implementation LearningInfoViewController
@synthesize HTMLStr,headerLableStr,resourceImageStr,unitinfo,IsEmptyBOOL,strIndexPathRow,dictLearningResource;
@synthesize objlearninginfodelegate,ivDownloadStatus;
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
    NSLog(@"%@",dictLearningResource);
    [_btnDownloadResource setImage:ivDownloadStatus forState:UIControlStateNormal];
    [lblUnitName setText:headerLableStr];
    [lblUnitInfo setText:unitinfo];
    [ivSectorImage setImage:[UIImage imageNamed:resourceImageStr]];
    // Do any additional setup after loading the view from its nib.
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(407 ,670 ,358, 330)];
    _webView.backgroundColor=[UIColor clearColor];
    [_webView setOpaque:NO];
    _webView.delegate=self;
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body><font color=#FFFFFF>%@</font></body></html>",HTMLStr] baseURL:nil];
    [self.view addSubview:_webView];
}
#pragma mark NULL Check For Any Object

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnDownloadResource:nil];
    [super viewDidUnload];
}


#pragma mark - IBAction Methods
-(IBAction)btnCloseTapped:(id)sender
{
    //[self.view removeFromSuperview];
    [self.objlearninginfodelegate btnSuperViewReload:sender];
}

- (IBAction)btnDownloadResourceTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if([sender tag]){
        
        ResourceLocalViewController *objResourceLocalViewController = [[ResourceLocalViewController alloc]initWithNibName:@"ResourceLocalViewController" bundle:nil];
        //objResourceLocalViewController.aryResourceFiles = [LearningALLRecords objectAtIndex:[sender tag]];
        [self.navigationController pushViewController:objResourceLocalViewController animated:YES];
    }
    else{
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setLabelText:@"Please wait !!"];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(downloadInProgress:) onTarget:self withObject:btn animated:YES];
        
    }
}


-(void)downloadInProgress:(id)sender{
    
    NSMutableArray *aryTextArray = [[NSMutableArray alloc]initWithArray:[dictLearningResource valueForKey:@"text"]];
    NSLog(@"%@",aryTextArray);
    for(int y=0;y<[aryTextArray count];y++)
    {
        NSString *strQuery = [NSString stringWithFormat:@"Insert into tbl_Learning_Text (ResourceID,TextID,TextDesc) values ('%@','%@','%@')",[dictLearningResource valueForKey:@"ResourceID"],[NSString stringWithFormat:@"%d",y],[[aryTextArray objectAtIndex:y]valueForKey:@"text"]];
        NSLog(@"%@",strQuery);
        [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        
        NSMutableArray *aryFileArray = [[NSMutableArray alloc]initWithArray:[[aryTextArray objectAtIndex:y] valueForKey:@"files"]];
        NSLog(@"%@",aryFileArray);
        for(int r=0;r<[aryFileArray count];r++)
        {
            NSArray *arrSlash = [[[aryFileArray objectAtIndex:r]valueForKey:@"text"] componentsSeparatedByString:@"/"];
            NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[arrSlash lastObject]];
            NSLog(@"%@",filenamepath);
            NSFileManager *fm=[NSFileManager defaultManager];
            
            if(![fm fileExistsAtPath:filenamepath])
            {
                //dispatch_async(kBgQueue, ^{
                NSURL *url = [NSURL URLWithString:[[aryFileArray objectAtIndex:r]valueForKey:@"text"]];
                NSLog(@"%@",url);
                NSLog(@"%@",filenamepath);
                NSData *VImageOriginal = [NSData dataWithContentsOfURL:url];
                [VImageOriginal writeToFile:filenamepath atomically:NO];
                //});
            }
            
            strQuery = [NSString stringWithFormat:@"Insert into tbl_Learning_Files (ResourceID,TextID,FilesID,FilesDescription) values('%@','%d','%@','%@')",[dictLearningResource valueForKey:@"ResourceID"],y,[NSString stringWithFormat:@"%d",r],[arrSlash lastObject]];
            NSLog(@"%@",strQuery);
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
    }
    [_btnDownloadResource setImage:[UIImage imageNamed:@"StartResourcedown.png"] forState:UIControlStateNormal];
    [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_Learning_Resources set DownloadStatus = 'YES' where ResourceID = '%@'",[dictLearningResource valueForKey:@"ResourceID"]]];
    
}


@end
