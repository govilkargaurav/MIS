//
//  TimeZoneViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "TimeZoneViewCtr.h"
#import "DatabaseAccess.h"
#import "GlobalMethods.h"

@interface TimeZoneViewCtr ()

@end

@implementation TimeZoneViewCtr
@synthesize strNav_Title;

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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DonePressed:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    // Do any additional setup after loading the view from its nib.
}

-(void)DonePressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSettingPopOver" object:nil userInfo:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    self.navigationItem.title = strNav_Title;
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"SettingTimeZoneVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblheading"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
    }
    
    
    NSString *strQuerySelect = @"SELECT * FROM tbl_timezone";
    ArryTimeZone = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_TimeZone:strQuerySelect]];
    
    //Send Data Of user setting from local databse
    NSString *strQuerySelectSetting = @"SELECT * FROM tbl_user_setting";
    ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelectSetting]];
    for (int i = 0; i < [ArryTimeZone count]; i++)
    {
        if ([[[ArryTimeZone objectAtIndex:i] valueForKey:@"zoneName"] isEqualToString:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"timeZone"]] || [[[ArryTimeZone objectAtIndex:i] valueForKey:@"zoneId"] isEqualToString:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"timeZone"]] || [[[ArryTimeZone objectAtIndex:i] valueForKey:@"zoneTime"] isEqualToString:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"timeZone"]])
        {
            selectedindex = i;
        }
    }
    [tbl_TimeZone reloadData];
}

#pragma mark - TableMethods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryTimeZone count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == Nil)
   // {
    if(cell!=nil)
    cell=nil;
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    
    UIImageView *imgbg = [[UIImageView alloc]init];
    imgbg.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-1);
    imgbg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imgbg.image = [UIImage imageNamed:@"bgTrans.png"];
    [cell addSubview:imgbg];
    
        UILabel *lblZoneName=[[UILabel alloc] init];
        if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
        {
            lblZoneName.frame=CGRectMake(0,5,230,35);
        }
        else
        {
            lblZoneName.frame=CGRectMake(0,5,390,35);
        }
        if (selectedindex == indexPath.row)
        {
            lblZoneName.textColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
        }
        else
        {
            lblZoneName.textColor = [UIColor blackColor];
        }
        lblZoneName.tag = indexPath.row;
        lblZoneName.backgroundColor=[UIColor clearColor];
        lblZoneName.textAlignment=UITextAlignmentLeft;
        lblZoneName.font = [UIFont fontWithName:@"ArialMT" size:14.0 ];
        lblZoneName.numberOfLines = 10;
        lblZoneName.text=[[ArryTimeZone objectAtIndex:indexPath.row] valueForKey:@"zoneName"];
        [cell addSubview:lblZoneName];
        lblZoneName=nil;
        
        
        UIButton *btnSelect =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSelect addTarget:self action:@selector(btnradioPressed:) forControlEvents:UIControlEventTouchDown];
        if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
        {
            [btnSelect setFrame:CGRectMake(240, 5, 25, 25)];
        }
        else
        {
            [btnSelect setFrame:CGRectMake(400, 5, 25, 25)];
        }
        [btnSelect setTag:indexPath.row];
        [btnSelect setSelected:NO];
        UIImage *SelectedImage;
        if (selectedindex == indexPath.row)
        {
            SelectedImage = [UIImage imageNamed:@"check.png"];
        }
        else
        {
            SelectedImage = [UIImage imageNamed:@"uncheck.png"];
        }
        [btnSelect setImage:SelectedImage forState:UIControlStateNormal];
        [cell addSubview:btnSelect];
   // }
	// Configure the cell.
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // return cell;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *someText = [[ArryTimeZone objectAtIndex:indexPath.row] valueForKey:@"zoneName"];
    UIFont *textFont = [UIFont fontWithName:@"ArialMT" size:14.0 ];
    CGSize constraintSize;
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        constraintSize.width = 230.0f;
    }
    else
    {
         constraintSize.width = 390.0f;
    }
    constraintSize.height = MAXFLOAT;
    CGSize stringSize =[someText sizeWithFont:textFont constrainedToSize: constraintSize lineBreakMode: NSLineBreakByWordWrapping];
    if (stringSize.height < 45)
    {
        return 44;
    }
    else
    {
        return  stringSize.height;
    }
}
#pragma mark - IBAction Methods

-(IBAction)btnradioPressed:(id)sender
{
    selectedindex = [sender tag];
    
    NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_user_setting Set timeZone='%@' Where userId=%d",[[ArryTimeZone objectAtIndex:selectedindex] valueForKey:@"zoneTime"],[[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdate];
    
    [tbl_TimeZone reloadData];
}

#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
