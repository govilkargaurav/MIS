//
//  LearningViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LearningViewController.h"
#import "ResourceDetailView.h"
#import "GlobleClass.h"
#import "ResourceFilesViewController.h"
#import "HelpViewController.h"
#import "ResourceLocalViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:[@"http://assessments.tlisc.org.au/webservices/resources/getlearning.php?jsoncallback=?&token=1726204214321678|xTAieBBJoDaWmBsG1stxfq4zLO4" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] //2



@implementation LearningViewController

@synthesize _tableView;
@synthesize buttonArray;




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
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDel showWithGradient:@"Please wait !!" views:self.view];
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    LearningALLRecords = [[NSMutableArray alloc]init];
    strQuery = [NSString stringWithFormat:@"select *from tbl_Learning_Resources"];
    CountValue = [DatabaseAccess getNoOfRecord:strQuery];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
        NSLog(@"Task Downloaded");
        [self performSelectorOnMainThread:@selector(fetchedData:)withObject:data waitUntilDone:YES];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RELOAD_LEARNING_FILTER) name:@"RELOAD_LEARNING_FILTER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFilter) name:@"FILTER__VIEW_HIDE_LEARNING" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RELOAD_SORT) name:@"RELOAD_LEARNING" object:nil];
    [self createTableView];
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
	return YES;
}

- (void)fetchedData:(NSData *)responseData
{
    NSError* error;    
    aryParseArray = [[NSMutableArray alloc]initWithArray: [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error]];
    
    if(!CountValue)
    {
        for(int l=0;l<[aryParseArray count];l++)
        {
            strQuery = [NSString stringWithFormat:@"Insert into tbl_Learning_Resources (ResourceID,UnitCode,UnitName,Version,Status,Published,Published_date,Progress,SectorID,SectorName,SectorColor,CoverImage,textcount,resourcetype,ipadtext,DownloadStatus) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','NO')",[[aryParseArray objectAtIndex:l] valueForKey:@"ResourceID"],[[aryParseArray objectAtIndex:l] valueForKey:@"UnitCode"],[[aryParseArray objectAtIndex:l] valueForKey:@"UnitName"],[[aryParseArray objectAtIndex:l] valueForKey:@"Version"],[[aryParseArray objectAtIndex:l] valueForKey:@"Status"],[[aryParseArray objectAtIndex:l] valueForKey:@"Published"],[[aryParseArray objectAtIndex:l] valueForKey:@"Published_date"],[[aryParseArray objectAtIndex:l] valueForKey:@"Progress"],[[aryParseArray objectAtIndex:l] valueForKey:@"SectorID"],[[aryParseArray objectAtIndex:l] valueForKey:@"SectorName"],[[aryParseArray objectAtIndex:l] valueForKey:@"SectorColor"],[[aryParseArray objectAtIndex:l] valueForKey:@"CoverImage"],[[aryParseArray objectAtIndex:l] valueForKey:@"textcount"],[[aryParseArray objectAtIndex:l] valueForKey:@"resourcetype"],[[aryParseArray objectAtIndex:l] valueForKey:@"ipadtext"]];
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
    }
    
    LearningALLRecords = [DatabaseAccess get_learningResources:@"select *from tbl_Learning_Resources order by SectorName"];
    LearningRecords = [[NSMutableArray alloc]initWithArray:LearningALLRecords];
    LearningFilter = [[NSMutableArray alloc]initWithArray:LearningRecords];
    [_tableView reloadData];
    [appDel hideWithGradient];
}


#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LearningRecords count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",[LearningRecords objectAtIndex:indexPath.row]);
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    
    UITableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    tablecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queBG.png"]];
    imageview.frame=CGRectMake(0,0,769,70);
    [tablecell addSubview:imageview];
    
    UIImageView *ivStrip = [[UIImageView alloc]init];
    NSLog(@"%@",[[LearningRecords valueForKey:@"SectorColor"] objectAtIndex:indexPath.row]);
    NSLog(@"%@",[[LearningRecords valueForKey:@"SectorName"] objectAtIndex:indexPath.row]);
    NSString *colorSTr = [[LearningRecords valueForKey:@"SectorColor"] objectAtIndex:indexPath.row];
    NSArray *arC = [[NSArray alloc]init];
    arC = [colorSTr componentsSeparatedByString:@","];
    [ivStrip setBackgroundColor:[UIColor colorWithRed:[[arC objectAtIndex:0]floatValue]/255.f green:[[arC objectAtIndex:1]floatValue]/255.f blue:[[arC objectAtIndex:2]floatValue]/255.f alpha:1.0]];
    [ivStrip setFrame:CGRectMake(0 ,0, 10, 70)];
    [tablecell addSubview:ivStrip];
    
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(30,12,290,25)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor blackColor];
    titleLbl.font=[UIFont systemFontOfSize:16];
    titleLbl.text=[[LearningRecords valueForKey:@"UnitName"] objectAtIndex:indexPath.row];
    [imageview addSubview:titleLbl];
    
    
    
    UIButton *arrowbtn=[[UIButton alloc] initWithFrame:CGRectMake(730,23, 10, 14)];
    [arrowbtn addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [arrowbtn setImage:[UIImage imageNamed:@"ARROW.png"] forState:UIControlStateNormal];
    [arrowbtn setTag:indexPath.row];
    [tablecell addSubview:arrowbtn];
    
    UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(30,40,600,25)];
    descLbl.backgroundColor=[UIColor clearColor];
    descLbl.textColor=[UIColor grayColor];
    descLbl.font=[UIFont systemFontOfSize:13];
    NSString *getStr1=[NSString stringWithFormat:@"%@ | %@ | %@",[[LearningRecords valueForKey:@"UnitCode"] objectAtIndex:indexPath.row],[[LearningRecords valueForKey:@"Version"] objectAtIndex:indexPath.row],[[LearningRecords valueForKey:@"Status"] objectAtIndex:indexPath.row]];
    descLbl.text=getStr1;
    [imageview addSubview:descLbl];
    
    NSArray *ar = [[NSArray alloc]init];
    ar = [[[LearningRecords valueForKey:@"SectorColor"] objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    
    float R = [[ar objectAtIndex:0]floatValue];
    float G = [[ar objectAtIndex:1]floatValue];
    float B = [[ar objectAtIndex:2]floatValue];
    
    
    UILabel *descLbl3=[[UILabel alloc] initWithFrame:CGRectMake(400,25,290,25)];
    descLbl3.backgroundColor=[UIColor clearColor];
    descLbl3.textColor=[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1];
    descLbl3.font=[UIFont boldSystemFontOfSize:15];
    descLbl3.text=[[LearningRecords valueForKey:@"SectorName"] objectAtIndex:indexPath.row];
    [imageview addSubview:descLbl3];
    
    
    UIButton *cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    BOOL yn = [[NSString stringWithFormat:@"%@",[[LearningRecords valueForKey:@"DownloadStatus"] objectAtIndex:indexPath.row]] boolValue];
    UIImage *iv = (yn)? [UIImage imageNamed:@"view_btn2.png"] : [UIImage imageNamed:@"download"];
    [cellbutton addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchDown];
    [cellbutton setImage:iv forState:UIControlStateNormal];
    [cellbutton setTag:yn];
    [cellbutton setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    [cellbutton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [cellbutton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    cellbutton.frame = CGRectMake(600,18,96,33);
    
    [tablecell addSubview:cellbutton];
    tablecell.selectionStyle=FALSE;
    return tablecell;    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    
    
}


-(void)viewDissmiss{
    
    [popoverController dismissPopoverAnimated:YES];
    
    
}
-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,121,768,885) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=70;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

/*
 * On click UITbaleViewCell Button this method will Call...
 */




#pragma mark - Sort Method
-(void)RELOAD_SORT
{
    [popoverController dismissPopoverAnimated:YES];
    [self SortTblData:strSortType];
}
-(void)SortTblData:(NSString*)strSortType
{
    if([strSortType isEqualToString:@"NAME, A-Z"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitName" ascending:YES];
        [LearningRecords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"NAME, Z-A"])
    {
        NSLog(@"%@",LearningRecords);
        NSLog(@"%d",[LearningRecords count]);
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitName" ascending:NO];
        [LearningRecords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"DATE, Ascending"])
    {
        
    }
    else if([strSortType isEqualToString:@"DATE, Descending"])
    {
        
    }
    else if([strSortType isEqualToString:@"Category, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"SectorName" ascending:YES];
        [LearningRecords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"Version" ascending:YES];
        [LearningRecords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Descending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"Version" ascending:NO];
        [LearningRecords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    [_tableView reloadData];
}
-(IBAction)sortDropDown:(id)sender{
    
    sortViewName = @"LEARNING";
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		_popOverSort = [[PopoverSort alloc] initWithNibName:@"PopoverSort" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:_popOverSort];
		
		[popoverController setPopoverContentSize:CGSizeMake(229.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(357,72,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}

#pragma mark - Filter Method
-(IBAction)filterDropDown:(id)sender{
    
    FilterFromView = @"LEARNING";
    
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		_popOverController = [[PopoverFilter alloc] initWithNibName:@"PopoverFilter" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:_popOverController];
		
		[popoverController setPopoverContentSize:CGSizeMake(229.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(263,71,68,40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations]; 
}
-(void)FilterTblData:(NSString*)strFilterType
{
    NSLog(@"%@",strFilterType);
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess get_learningResources:[NSString stringWithFormat:@"select *from tbl_Learning_Resources where (SectorName in (%@)) order by SectorName",strFilterType]]];
    
    if([ar count]>0)
    {
        LearningALLRecords = [ar copy];
        LearningRecords =  [[NSMutableArray alloc]initWithArray:LearningALLRecords];
        NSLog(@"%@",LearningRecords);
        //[self SortTblData:strSortType];
    }
    else
    {
        LearningALLRecords = [ar copy];
        LearningRecords = [[NSMutableArray alloc]initWithArray:LearningALLRecords];
        NSLog(@"%@",LearningRecords);
    }
    
    [_tableView reloadData];
}
-(void)RELOAD_LEARNING_FILTER
{
    [popoverController dismissPopoverAnimated:YES];
    [self FilterTblData:strFilterType];
}
-(void)hideFilter
{
    [popoverController dismissPopoverAnimated:YES];
}



#pragma mark - IBAction Methods
-(IBAction)helpButtonTapped:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		HelpViewController *objHelpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:objHelpViewController];
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 500.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(90,0,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}



-(IBAction)btnSearchTapped:(id)sender
{
    [LearningRecords removeAllObjects];
    for(int y=0;y<[LearningFilter count];y++)
    {
        NSMutableArray *ar = [[NSMutableArray alloc]initWithObjects:[LearningFilter objectAtIndex:y], nil];
        NSLog(@"%@",ar);
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(UnitName like %@) OR (UnitCode like %@) OR (Version like %@)",tfSearchTextBox.text,tfSearchTextBox.text,tfSearchTextBox.text];
        NSArray *filtered  = [[NSArray alloc]initWithArray:[ar filteredArrayUsingPredicate:predicate]];
        if([filtered count]>0)
        {
            [LearningRecords addObject:[filtered objectAtIndex:0]];
        }
        
        NSLog(@"%@",filtered);
    }
    [_tableView reloadData];
    
    
}

-(void)actionPressed:(id)sender
{
    objLearningInfoViewController =[[LearningInfoViewController alloc]initWithNibName:@"LearningInfoViewController" bundle:nil];
    objLearningInfoViewController.objlearninginfodelegate = self;
    objLearningInfoViewController.HTMLStr=[[LearningRecords valueForKey:@"ipadtext"] objectAtIndex:[sender tag]];
    objLearningInfoViewController.headerLableStr=[[LearningRecords valueForKey:@"UnitName"] objectAtIndex:[sender tag]];
    objLearningInfoViewController.resourceImageStr=[NSString stringWithFormat:@"%@.png",[[LearningRecords valueForKey:@"SectorName"] objectAtIndex:[sender tag]]];
    objLearningInfoViewController.unitinfo = [NSString stringWithFormat:@"%@ | %@ | %@",[[LearningRecords valueForKey:@"UnitCode"] objectAtIndex:[sender tag]],[[LearningRecords valueForKey:@"Version"] objectAtIndex:[sender tag]],[[LearningRecords valueForKey:@"Status"] objectAtIndex:[sender tag]]];
    
    if([[[LearningRecords objectAtIndex:[sender tag]]valueForKey:@"DownloadStatus"] boolValue])
        objLearningInfoViewController.ivDownloadStatus = [UIImage imageNamed:@"StartResourcedown.png"];
    else
        objLearningInfoViewController.ivDownloadStatus = [UIImage imageNamed:@"Downloaddown.png"];
    
    
    objLearningInfoViewController.dictLearningResource = [aryParseArray objectAtIndex:[sender tag]];
    objLearningInfoViewController.strIndexPathRow = [NSString stringWithFormat:@"%d",[sender tag]];
    viewWillAppearStr=@"1";
    [self.view addSubview:objLearningInfoViewController.view];
}

-(void)customActionPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if([sender tag]){
        
        ResourceLocalViewController *objResourceLocalViewController = [[ResourceLocalViewController alloc]initWithNibName:@"ResourceLocalViewController" bundle:nil];
        objResourceLocalViewController.aryResourceFiles = [LearningALLRecords objectAtIndex:[sender tag]];
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
    
    UIButton *btn = (UIButton *)sender;
    int IndexPathRow = [[btn currentTitle] intValue];
    aryTextArray = [[NSMutableArray alloc]initWithArray:[[aryParseArray objectAtIndex:[[btn currentTitle] intValue]] valueForKey:@"text"]];
    NSLog(@"%@",aryTextArray);
    for(int y=0;y<[aryTextArray count];y++)
    {
        strQuery = [NSString stringWithFormat:@"Insert into tbl_Learning_Text (ResourceID,TextID,TextDesc) values ('%@','%@','%@')",[[aryParseArray objectAtIndex:IndexPathRow] valueForKey:@"ResourceID"],[NSString stringWithFormat:@"%d",y],[[aryTextArray objectAtIndex:y]valueForKey:@"text"]];
        NSLog(@"%@",strQuery);
        [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        
        aryFileArray = [[NSMutableArray alloc]initWithArray:[[aryTextArray objectAtIndex:y] valueForKey:@"files"]];
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
            
            strQuery = [NSString stringWithFormat:@"Insert into tbl_Learning_Files (ResourceID,TextID,FilesID,FilesDescription) values('%@','%d','%@','%@')",[[aryParseArray objectAtIndex:IndexPathRow] valueForKey:@"ResourceID"],y,[NSString stringWithFormat:@"%d",r],[arrSlash lastObject]];
            NSLog(@"%@",strQuery);
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
    }
    [btn setImage:[UIImage imageNamed:@"view_btn2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"view_btn2"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"view_btn2"] forState:UIControlStateSelected];
    [btn setTag:1];
    [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_Learning_Resources set DownloadStatus = 'YES' where ResourceID = '%@'",[[aryParseArray objectAtIndex:IndexPathRow] valueForKey:@"ResourceID"]]];
    
}
-(void)btnSuperViewReload:(id)sender{
    [objLearningInfoViewController.view removeFromSuperview];
    LearningALLRecords = [DatabaseAccess get_learningResources:@"select *from tbl_Learning_Resources order by SectorName"];
    LearningRecords = [[NSMutableArray alloc]initWithArray:LearningALLRecords];
    LearningFilter = [[NSMutableArray alloc]initWithArray:LearningRecords];
    [_tableView reloadData];
}


#pragma mark - TopBar Methods
-(IBAction)btnHomePressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnLearningPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_12" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnAssessmentPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_13" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnResourcePressed:(id)sender
{
    globle_SectorName=@"allresources";
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}



@end
