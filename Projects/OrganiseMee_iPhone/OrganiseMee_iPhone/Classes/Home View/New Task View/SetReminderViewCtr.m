//
//  SetReminderViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by apple on 2/11/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "SetReminderViewCtr.h"
#import "DatabaseAccess.h"
#import "GlobalMethods.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

@interface SetReminderViewCtr ()

@end

@implementation SetReminderViewCtr

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
    
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
    [self updateui];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"reminderVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblreminder"]];
        lblReminderBeforeDuedate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblreminderbefore"]];
        lblReminderOnDuedate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblreminderonduedate"]];
        lblalldaysbetween.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblandevery"]];
        lblStandardReminder.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblapplystanreminder"]];
        lblInduReminder.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblspecifyindireminder"]];
        lblSendReminder.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsend"]];
        lbldaybeforeduedate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbldaybeforeduedate"]];
        
        
        NSArray *arrAllSubViews = [scl_bg subviews];
        for (UIView *view in arrAllSubViews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lbl = (UILabel *)view;
                if ([lbl.text isEqualToString:@"At"]) {
                    lbl.text = @"Um";
                }
                if ([lbl.text isEqualToString:@"H"]) {
                    lbl.text = @"Std.";
                }
                if ([lbl.text isEqualToString:@"mm"]) {
                    lbl.text = @"Min.";
                }
            }
        }
    }
    
    // Set ScrollView Content Size
    scl_bg.contentSize = CGSizeMake(320, 665);
    
    // Get Standard Reminder From Local Db
    NSString *strQuerySelect = @"SELECT * FROM tbl_standerd_reminder";
    ArryStan_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
    
    // Get Channels From Local Db
    NSString *strQuerySelectChannels = @"SELECT * FROM tbl_channels";
    ArryChannel = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_channels:strQuerySelectChannels]];
    
    for (int i = 0; i < [ArryChannel count]; i++)
    {
        if ([[[ArryChannel objectAtIndex:i]valueForKey:@"isDefault"] intValue] == 1)
        {
            lblContactBeforeDueDate.text = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:i]valueForKey:@"channelName"]];
            lblContactOnDueDate.text = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:i]valueForKey:@"channelName"]];
            strBeforChannelID = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:i]valueForKey:@"channelId"]];
            strOnChannelID = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:i]valueForKey:@"channelId"]];
            break;
        }
    }
    
    // If Time is in 24 formate then hide AMPM buttons
    NSString *strTimeSetting = [[NSUserDefaults standardUserDefaults] stringForKey:@"TimeSetting"];
    if ([strTimeSetting intValue] == 0)
    {
        for (int i = 1; i <= 6; i++)
        {
            UIButton *btnAMPM = (UIButton*)[self.view viewWithTag:i];
            btnAMPM.hidden = YES;
        }
        strBeforeAMPM1 = strBeforeAMPM2 = strBeforeAMPM3 = strOnAMPM1 = strOnAMPM2 = strOnAMPM3 = @"";
    }
    else
    {
        strBeforeAMPM1 = strBeforeAMPM2 = strBeforeAMPM3 = strOnAMPM1 = strOnAMPM2 = strOnAMPM3 = @"AM";
    }
    strAllDaysCheckUncheck = @"0";
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - IBAction Methods
-(IBAction)btnAssignStandardReminderPressed:(id)sender
{
    NSString *strImgName;
    if ([btnAssignCheckUncheck isSelected])
    {
        strImgName = @"uncheck.png";
        btnAssignCheckUncheck.selected = NO;
    }
    else
    {
        strImgName = @"check.png";
        btnAssignCheckUncheck.selected = YES;
        
        tfReminderCountBeforeDay.text = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"startDay"]]];
        NSString *strEveryDay = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"isEveryDay"]]];
        if ([strEveryDay isEqualToString:@"1"])
        {
            btnAllDayCheckUnCheck.selected = YES;
            [btnAllDayCheckUnCheck setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            strAllDaysCheckUncheck = @"1";
        }
        NSArray *ArryBefore1 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"beforeDuedateTime1"]]]];
        if ([ArryBefore1 count] == 2)
        {
            tfBeforeHH1.text = [NSString stringWithFormat:@"%@",[ArryBefore1 objectAtIndex:0]];
            tfBeforeMM1.text = [NSString stringWithFormat:@"%@",[ArryBefore1 objectAtIndex:1]];
        }
        NSArray *ArryBefore2 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"beforeDuedateTime2"]]]];
        if ([ArryBefore2 count] == 2)
        {
            tfBeforeHH2.text = [NSString stringWithFormat:@"%@",[ArryBefore2 objectAtIndex:0]];
            tfBeforeMM2.text = [NSString stringWithFormat:@"%@",[ArryBefore2 objectAtIndex:1]];
        }
        NSArray *ArryBefore3 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"beforeDuedateTime3"]]]];
        if ([ArryBefore3 count] == 2)
        {
            tfBeforeHH3.text = [NSString stringWithFormat:@"%@",[ArryBefore3 objectAtIndex:0]];
            tfBeforeMM3.text = [NSString stringWithFormat:@"%@",[ArryBefore3 objectAtIndex:1]];
        }
        NSArray *ArryOn1 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"onDuedateTime1"]]]];
        if ([ArryOn1 count] == 2)
        {
            tfOnHH1.text = [NSString stringWithFormat:@"%@",[ArryOn1 objectAtIndex:0]];
            tfOnMM1.text = [NSString stringWithFormat:@"%@",[ArryOn1 objectAtIndex:1]];
        }
        NSArray *ArryOn2 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"onDuedateTime2"]]]];
        if ([ArryOn2 count] == 2)
        {
            tfOnHH2.text = [NSString stringWithFormat:@"%@",[ArryOn2 objectAtIndex:0]];
            tfOnMM2.text = [NSString stringWithFormat:@"%@",[ArryOn2 objectAtIndex:1]];
        }
        NSArray *ArryOn3 = [self ArrayFromString:[self removeNull:[NSString stringWithFormat:@"%@",[[ArryStan_Reminder objectAtIndex:0] valueForKey:@"onDuedateTime3"]]]];
        if ([ArryOn3 count] == 2)
        {
            tfOnHH3.text = [NSString stringWithFormat:@"%@",[ArryOn3 objectAtIndex:0]];
            tfOnMM3.text = [NSString stringWithFormat:@"%@",[ArryOn3 objectAtIndex:1]];
        }

    }
     [btnAssignCheckUncheck setImage:[UIImage imageNamed:strImgName] forState:UIControlStateNormal];
}
-(IBAction)btnAllDaysReminderPressed:(id)sender
{
    if ([tfReminderCountBeforeDay.text length] > 0)
    {
        NSString *strImgName;
        if ([btnAllDayCheckUnCheck isSelected])
        {
            strImgName = @"uncheck.png";
            btnAllDayCheckUnCheck.selected = NO;
            strAllDaysCheckUncheck = @"0";
        }
        else
        {
            strImgName = @"check.png";
            btnAllDayCheckUnCheck.selected = YES;
            strAllDaysCheckUncheck = @"1";
        }
        [btnAllDayCheckUnCheck setImage:[UIImage imageNamed:strImgName] forState:UIControlStateNormal];
    }
    else
    {
        DisplayAlertWithTitle(App_Name, @"Please enter days before due date first");
        return;
    }

}
-(IBAction)btnChannelPressed:(id)sender
{
    ChannelSelectedTag = [sender tag];
    
   /* alertChannleList = [[UIAlertView alloc] initWithTitle:@"Choose an option..." message:@"\n\n\n\n\n\n"delegate:nil  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    tblViewChannel = [[UITableView alloc]initWithFrame:CGRectMake(10, 43, 264, 132)];
    tblViewChannel.layer.cornerRadius = 8.0;
    tblViewChannel.layer.masksToBounds = YES;
    tblViewChannel.delegate = self;
    tblViewChannel.dataSource = self;
    [alertChannleList addSubview:tblViewChannel];
    alertChannleList.tag = 1000;
    [alertChannleList show];*/
    alert	= [[SBTableAlert alloc] initWithTitle:@"Choose an option..." cancelButtonTitle:@"Cancel" messageFormat:nil];
    [alert.view setTag:1];
    [alert setDelegate:self];
	[alert setDataSource:self];
	
	[alert show];
}
-(IBAction)btnAMPMPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *strAMPM;
    if ([btn isSelected])
    {
        [btn setImage:[UIImage imageNamed:@"am.png"] forState:UIControlStateNormal];
        [btn setSelected:NO];
        strAMPM = @"AM";
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"pm.png"] forState:UIControlStateNormal];
        [btn setSelected:YES];
        strAMPM = @"PM";
    }
    
    switch ([btn tag]) {
        case 1:
             strBeforeAMPM1 = strAMPM;
            break;
        case 2:
            strBeforeAMPM2 = strAMPM;
            break;
        case 3:
            strBeforeAMPM3 = strAMPM;
            break;
        case 4:
            strOnAMPM1 = strAMPM;
            break;
        case 5:
            strOnAMPM2 = strAMPM;
            break;
        case 6:
            strOnAMPM3 = strAMPM;
            break;
            
        default:
            break;
    }
}
-(IBAction)btnSavReminderPressed:(id)sender
{
    BOOL CheckFLag = [self checkallfields];
    if (CheckFLag)
    {
        if ([UserLanguage isEqualToString:@"de"]) {
            DisplayAlertWithTitle(App_Name, @"Please set atleast one time to set reminder before duedate");
        }else{
            DisplayAlertWithTitle(App_Name, @"Bitte setzen Sie mindestens eine Uhrzeit.");
        }
    }
    else
    {
        NSString *strBeforeTime1 = [self SetTime:tfBeforeHH1.text Minute:tfBeforeMM1.text AMPM:strBeforeAMPM1];
        NSString *strBeforeTime2 = [self SetTime:tfBeforeHH2.text Minute:tfBeforeMM2.text AMPM:strBeforeAMPM2];
        NSString *strBeforeTime3 = [self SetTime:tfBeforeHH3.text Minute:tfBeforeMM3.text AMPM:strBeforeAMPM3];
        NSString *strOnTime1 = [self SetTime:tfOnHH1.text Minute:tfOnMM1.text AMPM:strOnAMPM1];
        NSString *strOnTime2 = [self SetTime:tfOnHH2.text Minute:tfOnMM2.text AMPM:strOnAMPM2];
        NSString *strOnTime3 = [self SetTime:tfOnHH3.text Minute:tfOnMM3.text AMPM:strOnAMPM3];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tfReminderCountBeforeDay.text,@"startDay",strAllDaysCheckUncheck,@"isEveryDay",strBeforeTime1,@"beforeDueDateTime1",strBeforeTime2,@"beforeDueDateTime2",strBeforeTime3,@"beforeDueDateTime3",strOnTime1,@"onDueDateTime1",strOnTime2,@"onDueDateTime2",strOnTime3,@"onDueDateTime3",strBeforChannelID,@"beforeDueDateChannelId",strOnChannelID,@"onDueDateChannelId",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetReminderData" object:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//Check All Fields are empty or not
-(BOOL)checkallfields
{
    BOOL SendFlag;
    NSString *strhr1 = [tfBeforeHH1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strhr2 = [tfBeforeHH2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strhr3 = [tfBeforeHH3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strhr4 = [tfOnHH1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strhr5 = [tfOnHH2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strhr6 = [tfOnHH3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([strhr1 length] == 0 && [strhr2 length] == 0 && [strhr3 length] == 0 && [strhr4 length] == 0 && [strhr5 length] == 0 && [strhr6 length] == 0)
    {
        SendFlag = YES;
    }
    else
    {
        SendFlag = NO;
    }
    return SendFlag;
}

//Check Time and set Time
-(NSString*)SetTime:(NSString*)strHr Minute:(NSString*)strMin AMPM:(NSString*)strAmPmFormate
{
    NSString *strFinalTime;
    if ([[strHr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        strFinalTime = @"";
    }
    else if ([[strMin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        if ([[strAmPmFormate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            strFinalTime = [NSString stringWithFormat:@"%@:00",strHr];
        }
        else
        {
            strFinalTime = [NSString stringWithFormat:@"%@:00 %@",strHr,strAmPmFormate];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSDate *finaldate = [df dateFromString:strFinalTime];
            [df setDateFormat:@"HH:mm"];
            strFinalTime = [df stringFromDate:finaldate];
        }
    }
    else
    {
        if ([[strAmPmFormate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            strFinalTime = [NSString stringWithFormat:@"%@:%@",strHr,strMin];
        }
        else
        {
            strFinalTime = [NSString stringWithFormat:@"%@:%@ %@",strHr,strMin,strAmPmFormate];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSDate *finaldate = [df dateFromString:strFinalTime];
            [df setDateFormat:@"HH:mm"];
            strFinalTime = [df stringFromDate:finaldate];
        }
    }
    return strFinalTime;
}

// Seperate String with :
-(NSArray*)ArrayFromString:(NSString*)strTime
{
    NSArray *Arry = [strTime componentsSeparatedByString:@":"];
    return Arry;
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
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        if([UserLanguage isEqualToString:@"de"])
        {
                lblSendReminder.frame = CGRectMake(17, 154, 163, 21);
                tfReminderCountBeforeDay.frame = CGRectMake(197, 151, 33, 30);
        }
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
    }
    
}


#pragma mark - SBTableAlertDataSource

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
		return ArryChannel.count;
}

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert {
		return 1;
}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [[ArryChannel objectAtIndex:indexPath.row]valueForKey:@"channelName"];
    
    return cell;
}

#pragma mark - SBTableAlertDelegate

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (ChannelSelectedTag == 101)
    {
        lblContactBeforeDueDate.text = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:indexPath.row]valueForKey:@"channelName"]];
        strBeforChannelID = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:indexPath.row]valueForKey:@"channelId"]];
    }
    else
    {
        lblContactOnDueDate.text = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:indexPath.row]valueForKey:@"channelName"]];
        strOnChannelID = [NSString stringWithFormat:@"%@",[[ArryChannel objectAtIndex:indexPath.row]valueForKey:@"channelId"]];
    }
    [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
}


#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textField.layer setBorderWidth: 2.0];
    [textField.layer setMasksToBounds:YES];
    // Below code is used for scroll up View with navigation baar
    CGRect textVWRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == tfReminderCountBeforeDay)
    {
        if ([tfReminderCountBeforeDay.text length] == 0)
        {
            btnAllDayCheckUnCheck.selected = NO;
            strAllDaysCheckUncheck = @"0";
            [btnAllDayCheckUnCheck setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        }
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"123456789"];
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            if (![myCharSet characterIsMember:c] || [textField.text intValue] > 9)
            {
                DisplayAlertWithTitle(App_Name, @"Enter Only Between 1 to 9");
                textField.text = @"";
            }
            
        }
    }
    else if (textField == tfBeforeHH1 || textField == tfBeforeHH2 || textField == tfBeforeHH3 || textField == tfOnHH1 || textField == tfOnHH2 || textField == tfOnHH3)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            
            NSString *strTimeSetting = [[NSUserDefaults standardUserDefaults] stringForKey:@"TimeSetting"];
            if ([strTimeSetting intValue] == 0)
            {
                if (![myCharSet characterIsMember:c] || [textField.text intValue] < 0 || [textField.text intValue] > 23)
                {
                    DisplayAlertWithTitle(App_Name, @"Enter Only Between 0 to 23");
                    textField.text = @"";
                }
                else if ([textField.text intValue] < 10)
                {
                    NSString *strNumber = [NSString stringWithFormat:@"%02.00f",[textField.text floatValue]];
                    textField.text = [NSString stringWithFormat:@"%@",strNumber];
                }
            }
            else
            {
                if (![myCharSet characterIsMember:c] || [textField.text intValue] < 1 || [textField.text intValue] > 12)
                {
                    DisplayAlertWithTitle(App_Name, @"Enter Only Between 1 to 12");
                    textField.text = @"";
                }
                else if ([textField.text intValue] < 10)
                {
                    NSString *strNumber = [NSString stringWithFormat:@"%02.00f",[textField.text floatValue]];
                    textField.text = [NSString stringWithFormat:@"%@",strNumber];
                }
            }
        }
    }
    else if (textField == tfBeforeMM1 || textField == tfBeforeMM2 || textField == tfBeforeMM3 || textField == tfOnMM1 || textField == tfOnMM2 || textField == tfOnMM3)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            if (![myCharSet characterIsMember:c] || [textField.text intValue] < 0 || [textField.text intValue] > 59)
            {
                DisplayAlertWithTitle(App_Name, @"Enter Only Between 0 to 59");
                textField.text = @"";
            }
            else if ([textField.text intValue] < 10)
            {
                NSString *strNumber = [NSString stringWithFormat:@"%02.00f",[textField.text floatValue]];
                textField.text = [NSString stringWithFormat:@"%@",strNumber];
            }
        }
    }
    
    [textField.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [textField.layer setBorderWidth: 2.0];
    [textField.layer setMasksToBounds:YES];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
/*-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfReminderCountBeforeDay)
    {
        if ([tfReminderCountBeforeDay.text intValue] > 10 || [tfReminderCountBeforeDay.text length] > 0)
        {
            DisplayAlertWithTitle(App_Name, @"Enter Only Between 1 to 9");
            tfReminderCountBeforeDay.text = @"";
            return NO;
        }
        else
        {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"123456789"];
            for (int i = 0; i < [string length]; i++)
            {
                unichar c = [string characterAtIndex:i];
                if (![myCharSet characterIsMember:c])
                    return NO;
                else
                    return YES;
            }
        }
    }
    return YES;
}*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Remove Null
-(NSString *)removeNull:(NSString *)str
{
    if (!str || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"])
    {
        return @"";
    }
    else
    {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
                                         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
