//
//  ResourceLocalViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 12/3/12.
//
//

#import "ResourceLocalViewController.h"
# 

@interface UITextView (extended)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface ResourceLocalViewController ()

@end

@implementation ResourceLocalViewController
@synthesize aryAllLearningResouces,aryTextArray,aryFilesArray,aryResourceFiles;

#pragma mark - View Life Cycle

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
    NSLog(@"%@",aryResourceFiles);
    aryTextArray = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_learningResourcesText:[NSString stringWithFormat:@"SELECT * FROM tbl_Learning_Text where cast(ResourceID as int) = %@",[aryResourceFiles valueForKey:@"ResourceID"]]]];
  
    aryFilesArray = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_learningResourcesFiles:[NSString stringWithFormat:@"SELECT * FROM tbl_Learning_Files where cast(ResourceID as int) = %@",[aryResourceFiles valueForKey:@"ResourceID"]]]];
    
    aryText = [[NSMutableArray alloc]init];
    aryFiles = [[NSMutableArray alloc]init];
    aryTextViewHeight = [[NSMutableArray alloc]init];
    
    for(int u=0;u<[aryTextArray count];u++)
    {
        [aryText insertObject:[[aryTextArray objectAtIndex:u] valueForKey:@"TextDesc"] atIndex:u];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TextID = %@", [[aryTextArray objectAtIndex:u] valueForKey:@"TextID"]];
        [aryFiles addObject:[aryFilesArray filteredArrayUsingPredicate:predicate]];
        NSLog(@"%@",aryFiles);
    }
    
    lbl_1.text = [aryResourceFiles valueForKey:@"UnitName"];
    [lbl_2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",[aryResourceFiles valueForKey:@"UnitCode"],[aryResourceFiles valueForKey:@"Version"],[aryResourceFiles valueForKey:@"Status"]]];
    
    [tblResourceFile setBackgroundColor:[UIColor colorWithRed:212/255.f green:212/255.f blue:213/255.f alpha:1.0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Methods - 
#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",aryText);
    int yAxis = 0;
    
    [tvWebContent resignFirstResponder];
    [tvWebContent setContentToHTMLString:[aryText objectAtIndex:indexPath.row]];
    [tvWebContent setEditable:NO];
    [tvWebContent setTag:NO];
    tvWebContent.scrollEnabled = NO;
    tvWebContent.opaque = NO;
    [tvWebContent setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    tvWebContent.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0); //UIEdgeInsetsMake(-4,-8,0,0);
    
    
    CGRect frame = tvWebContent.frame;
    frame.size.height = tvWebContent.contentSize.height;
    tvWebContent.frame = frame;
    NSLog(@"%f",tvWebContent.frame.size.height);
    
    yAxis = yAxis + tvWebContent.frame.size.height + 5;
    
    for(int j=0;j<[[aryFiles objectAtIndex:indexPath.row] count];j++)
    {
        yAxis = yAxis + 210;
    }
    [aryTextViewHeight insertObject:[NSString stringWithFormat:@"%f",tvWebContent.frame.size.height+5] atIndex:indexPath.row];
    return yAxis;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryText count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    
    UITableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    tablecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    int yAxis = 0;
    
    float fHeight = [[aryTextViewHeight objectAtIndex:indexPath.row] floatValue];
    UITextView *tvWeb = [[UITextView alloc]initWithFrame:CGRectMake(0,yAxis,768,fHeight)];
    [tvWeb setBackgroundColor:[UIColor clearColor]];
    [tvWeb setTextColor:[UIColor blackColor]];
    [tvWeb resignFirstResponder];
    [tvWeb setContentToHTMLString:[aryText objectAtIndex:indexPath.row]];
    [tvWeb setEditable:NO];
    [tvWeb setTag:NO];
    tvWeb.scrollEnabled = NO;
    tvWeb.opaque = NO;
    [tvWeb setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    tvWeb.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    [tablecell addSubview:tvWeb];
    
    yAxis = yAxis + fHeight + 5;
    
    for(int j=0;j<[[aryFiles objectAtIndex:indexPath.row] count];j++)
    {
        NSString *fileName = [[[aryFiles objectAtIndex:indexPath.row] objectAtIndex:j] valueForKey:@"FilesDescription"];
        int l = [fileName length];
        NSString *strImg = [NSString stringWithFormat:@"%@",[[fileName substringFromIndex:l-4] substringToIndex:4]];
        
        if([strImg isEqualToString:@".mp4"])
        {
            NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],fileName];
            NSURL* urlFileVideo = [NSURL fileURLWithPath:filenamepath];
            
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:urlFileVideo];
            UIImage  *thumbnail = [player thumbnailImageAtTime:8.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [player stop];
            player = nil;
            
            UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_1 setImage:thumbnail forState:UIControlStateNormal];
            [btn_1 setFrame:CGRectMake(134, yAxis, 500, 200)];
            [btn_1 setTitle:fileName forState:UIControlStateNormal];
            [btn_1 addTarget:self action:@selector(btn_1Pressed:) forControlEvents:UIControlEventTouchUpInside];
            [tablecell addSubview:btn_1];
            
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(134, yAxis, 500, 200)];
            [iv setImage:[UIImage imageNamed:@"videoPlayIcon.png"]];
            [iv setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Shaddow.png"]]];
            [iv setContentMode:UIViewContentModeCenter];
            [tablecell addSubview:iv];
            
            yAxis = yAxis + 210;
        }
        else
        {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(134, yAxis, 500, 200)];
            NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[[[aryFiles objectAtIndex:indexPath.row] objectAtIndex:j] valueForKey:@"FilesDescription"]];
            NSLog(@"%@",filenamepath);
            NSData *imagedata=[[NSData alloc] initWithContentsOfFile:filenamepath];
            [iv setImage:[UIImage imageWithData:imagedata]];
            [iv setContentMode:UIViewContentModeScaleToFill];
            [iv setBackgroundColor:[UIColor clearColor]];
            [tablecell addSubview:iv];
            
            yAxis = yAxis + 210;
        }
        
        
        
    }
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -5, 768, yAxis)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:226/255.f green:228/255.f blue:230/255.f alpha:1].CGColor,(id)[UIColor colorWithRed:212/255.f green:213/255.f blue:215/255.f alpha:1].CGColor, nil];
    layer.frame = backgroundView.frame;
    [backgroundView.layer addSublayer:layer];
    tablecell.backgroundView=backgroundView;
    tablecell.selectionStyle=FALSE;
    return tablecell;
}


#pragma mark - UIButton Event

-(IBAction)btnBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btn_1Pressed:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    NSLog(@"%@",[btn titleLabel].text);
    NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[btn titleLabel].text];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:filenamepath];
    
    [moviePlayer readyPlayer];
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:moviePlayer animated:NO];
    //[self presentModalViewController:moviePlayer animated:YES];
    moviePlayer=nil;
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

@end
