//
//  AutoSyncViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/3/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "AutoSyncViewCtr.h"

@interface AutoSyncViewCtr ()

@end

@implementation AutoSyncViewCtr
@synthesize strNav_Title;
@synthesize timer;
@synthesize localizationDict;

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
    
    checkmarkindexPath=-1;
        
    NSString *strTimer = [[NSUserDefaults standardUserDefaults] stringForKey:@"SyncSwitch"];
    if (!strTimer)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Off" forKey:@"SyncSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:@"-1" forKey:@"checkmarkindexPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    strTimer = [[NSUserDefaults standardUserDefaults] stringForKey:@"SyncSwitch"];
    if ([strTimer isEqualToString:@"On"])
    {
        tblAutoSync.hidden=FALSE;
        [timerSwitch setOn:YES];
        imgBg.frame = CGRectMake(0, 210, 320, 190);
    }
    else
    {
        imgBg.frame = CGRectMake(0, 77, 320, 322);
        tblAutoSync.hidden=TRUE;
        [timerSwitch setOn:NO];
        [[NSUserDefaults standardUserDefaults] setValue:@"-1" forKey:@"checkmarkindexPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DonePressed:)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    // Do any additional setup after loading the view from its nib.
}
-(void)DonePressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSettingPopOver" object:nil userInfo:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    self.navigationItem.title = strNav_Title;
    lblAutoSync.text = strNav_Title;
    // Set Selected Langauge
    NSString *strLang = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
    if ([strLang isEqualToString:@"en"])
        timerArr = [[NSArray alloc] initWithObjects:@"Every 10 min",@"Every 30 min",@"Every hour", nil];
    else if ([strLang isEqualToString:@"de"])
        timerArr = [[NSArray alloc] initWithObjects:@"Alle 10 Minuten",@"Alle 30 Minuten",@"Jede Stunde", nil];
    
    [tblAutoSync reloadData];
}
-(IBAction)ChangeState:(id)sender
{
    if ([timerSwitch isOn])
    {
        imgBg.frame = CGRectMake(0, 210, 320, 190);
        tblAutoSync.hidden=FALSE;
        [timerSwitch setOn:YES];
        [[NSUserDefaults standardUserDefaults] setValue:@"On" forKey:@"SyncSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        imgBg.frame = CGRectMake(0, 77, 320, 322);
        tblAutoSync.hidden=TRUE;
        [timerSwitch setOn:NO];
        [[NSUserDefaults standardUserDefaults] setValue:@"Off" forKey:@"SyncSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

#pragma mark TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timerArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell==nil) {
    if(cell!=nil)
        cell=nil;
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    
    UIImageView *imgbg = [[UIImageView alloc]init];
    imgbg.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-1);
    imgbg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imgbg.image = [UIImage imageNamed:@"bgTrans.png"];
    [cell.contentView addSubview:imgbg];
    
    cell.textLabel.text = [timerArr objectAtIndex:indexPath.row];

    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"checkmarkindexPath"];
    NSString *strindexPath = [NSString stringWithFormat:@"%d",indexPath.row];
    
    if ([str isEqualToString:strindexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"checkmarkindexPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"checkmarkindexPath"];
    int intstr = [str intValue];
    [tableView reloadData];
    
    if(timer) {
        [timer invalidate];
    }
    
    //600.0
    
    switch (intstr)
    {
        case 0:
            timer = [NSTimer scheduledTimerWithTimeInterval:600.0 target:self selector:@selector(CallTimer) userInfo:nil repeats:YES];
            break;
        case 1:
            timer = [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(CallTimer) userInfo:nil repeats:YES];
            break;
        case 2:
            timer = [NSTimer scheduledTimerWithTimeInterval:3600.0 target:self selector:@selector(CallTimer) userInfo:nil repeats:YES];
            
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)CallTimer
{
    SyncClass *obj_SyncClass = [[SyncClass alloc]init];
    [obj_SyncClass CallSync:@"YES"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
