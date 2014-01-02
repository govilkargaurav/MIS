//
//  SettingsViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "SettingsViewController.h"
#import "SLPickerViewLabel.h"

@implementation SettingsViewController
@synthesize popoverController;

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
    arrEdition = [[NSMutableArray alloc]init];
    arrZone = [[NSMutableArray alloc]init];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateui];

    
        
    strEditionIdFinal = [[NSUserDefaults standardUserDefaults]valueForKey:@"iEditionID"];
    strZoneIdFinal = [[NSUserDefaults standardUserDefaults] valueForKey:@"iZoneID"];
    
    if ([AppDel checkConnection])
    {
        if (arrEdition.count == 0 || arrZone.count == 0)
        {
            [AppDel doshowHUD];
        }
        [self performSelector:@selector(CallWebServices) withObject:nil afterDelay:0.2];
    }
    
    // Check Push Noti button is On/Off
    NSString *strNotiOnOff = [[NSUserDefaults standardUserDefaults] valueForKey:@"NotificationOnOff"];
    if ([strNotiOnOff intValue] == 1)
    {
        [btnPushOnOff setImage:[UIImage imageNamed:@"settingsOn.png"] forState:UIControlStateNormal];
    }
    else if ([strNotiOnOff intValue] == 0)
    {
        [btnPushOnOff setImage:[UIImage imageNamed:@"settingsOff.png"] forState:UIControlStateNormal];
    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [btnOnOff setImage:[UIImage imageNamed:@"settingsOn.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnOnOff setImage:[UIImage imageNamed:@"settingsOff.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Web Service

-(void)CallWebServices
{
    NSString *str_2 =[NSString stringWithFormat:@"%@c=data&func=getallzone",WebURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_2 stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             [AppDel dohideHUD];
             DisplayAlertWithTitle(App_Name, [error localizedDescription]);
         }
         else
         {
             NSError* err;
             NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
             
             if ([dictData valueForKey:@"edition"])
             {
                 
                 if ([[dictData valueForKey:@"edition"]valueForKey:@"msg"])
                 {
                     arrEdition = [[NSMutableArray alloc]init];
                     if ([[[dictData valueForKey:@"edition"] valueForKey:@"msg"] isEqualToString:@"SUCCESS"])
                     {
                         [arrEdition setArray:[[dictData valueForKey:@"edition"] valueForKey:@"data"]];
                     }
                 }
                 
             }
             if ([dictData valueForKey:@"zone"])
             {
                 
                 if ([[dictData valueForKey:@"zone"] valueForKey:@"msg"])
                 {
                     arrZone = [[NSMutableArray alloc]init];
                     if ([[[dictData valueForKey:@"zone"] valueForKey:@"msg"] isEqualToString:@"SUCCESS"])
                     {
                         [arrZone setArray:[[dictData valueForKey:@"zone"] valueForKey:@"data"]];
                     }
                 }
             }
         }
         
         for (int i = 0; i < [arrEdition count]; i++)
         {
             NSString *strEditionIdFromArry = [[arrEdition objectAtIndex:i]valueForKey:@"iEditionID"];
             if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"iEditionID"] isEqualToString:strEditionIdFromArry])
             {
                 EditionIndex = i;
                 lblEdition.text = [[arrEdition objectAtIndex:i]valueForKey:@"vEdition"];
                 strEditionIdFinal = [[arrEdition objectAtIndex:i]valueForKey:@"iEditionID"];
                 break;
             }
         }
         
         for (int i = 0; i < [arrZone count]; i++)
         {
             NSString *strZoneIdFromArry = [[arrZone objectAtIndex:i]valueForKey:@"iZoneID"];
             if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"iZoneID"] isEqualToString:strZoneIdFromArry])
             {
                 ZoneIndex = i;
                 lblZone.text = [[arrZone objectAtIndex:i]valueForKey:@"vZone"];
                 strZoneIdFinal = [[arrZone objectAtIndex:i]valueForKey:@"iZoneID"];
                 break;
             }
         }
         [AppDel dohideHUD];
     }];
}

#pragma mark - Button Action

-(IBAction)btnEditionPressed:(id)sender
{
    if([AppDel checkConnection] && [arrEdition count] > 0)
    {
        btnFrame = btnEdition;
        strType = @"Edition";
        [self CustomPickerView:arrEdition btnname:btnFrame];
    }
    else if ([arrEdition count] == 0 && [AppDel checkConnection])
    {
        DisplayAlertWithTitle(App_Name, @"Edition not found.");
        return;
    }
    else
    {
        DisplayAlertconnection;
        return;
    }

}
-(IBAction)btnZonePressed:(id)sender
{
    if([AppDel checkConnection] && [arrZone count] > 0)
    {
        btnFrame = btnZone;
        strType = @"Zone";
        [self CustomPickerView:arrZone btnname:btnFrame];
    }
    else if ([arrZone count] == 0 && [AppDel checkConnection])
    {
        DisplayAlertWithTitle(App_Name, @"Zone not found.");
        return;
    }

    else
    {
        DisplayAlertconnection;
        return;
    }
}

-(IBAction)ClickedBtnPushOnOff:(id)sender
{
    if (![AppDel checkConnection])
    {
        DisplayAlertconnection;
        return;
    }
    else
    {
        [AppDel doshowHUD];
        [self CallOnOffPushNoti];
    }
}

-(IBAction)ClickedBtnAdMobOnOff:(id)sender
{
    if(btnOnOff.imageView.image == [UIImage imageNamed:@"settingsOff.png"])
    {
        [btnOnOff setImage:[UIImage imageNamed:@"settingsOn.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"AdMobOnOff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if (![AppDel checkConnection])
        {
            DisplayAlertconnection;
            return;
        }
        else
        {
            [btnOnOff setImage:[UIImage imageNamed:@"settingsOff.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AdMobOnOff"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

-(IBAction)btnSetPressed:(id)sender
{
    if (![AppDel checkConnection])
    {
        DisplayAlertconnection;
        return;
    }
    else
    {
        if ([AppDel.downloadingArray count] > 0)
        {
            DisplayAlertWithTitle(App_Name, @"Download in progress. Please complete or cancel all downloads.");
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:strEditionIdFinal forKey:@"iEditionID"];
            [[NSUserDefaults standardUserDefaults] setInteger:EditionIndex forKey:@"EditionIndex"];
            [[NSUserDefaults standardUserDefaults] setObject:strEditionNameFinal forKey:@"vEdition"];
            
            [[NSUserDefaults standardUserDefaults] setObject:strZoneIdFinal forKey:@"iZoneID"];
            [[NSUserDefaults standardUserDefaults] setInteger:ZoneIndex forKey:@"ZoneIndex"];
            [[NSUserDefaults standardUserDefaults] setObject:strZoneNameFinal forKey:@"vZone"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
        }
    }
}

-(void)CallOnOffPushNoti
{
    NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=notificationswitch&vDeviceToken=%@",WebURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             DisplayAlertWithTitle(App_Name, [error localizedDescription]);
             return;
         }
         else
         {
             NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
             NSString *strMsg = [dicResult valueForKey:@"msg"];
             if ([strMsg isEqualToString:@"SUCCESS"])
             {
                 [self performSelector:@selector(PassNoti:) withObject:[dicResult valueForKey:@"eNotification"] afterDelay:0.1f];
             }
             else
             {
                 [AppDel dohideHUD];
             }
         }         
     }];
}

-(void)PassNoti:(NSString*)str
{
    [AppDel dohideHUD];

    if ([str isEqualToString:@"off"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotificationOnOff"];
        [btnPushOnOff setImage:[UIImage imageNamed:@"settingsOff.png"] forState:UIControlStateNormal];
    }
    else if ([str isEqualToString:@"on"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NotificationOnOff"];
        [btnPushOnOff setImage:[UIImage imageNamed:@"settingsOn.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - Single Selection Picker
-(void)CustomPickerView:(NSMutableArray*)arry btnname:(UIButton*)btn
{
    if ([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:NO];
    }
    _currentPick = -1;
    if ([strType isEqualToString:@"Edition"])
    {
        _currentPick = EditionIndex;
    }
    else
    {
        _currentPick = ZoneIndex;
    }
    _pickerData = [[NSMutableArray alloc]initWithArray:arry];
    // Set up the custom pickerview
    _pickerView = [[SLPickerView alloc] init];
    _pickerView.showsSelectionIndicator = NO;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.exclusiveTouch = NO;
        
    // Add a gesture recognizer to detect taps in pickerview
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInPickerView:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [_pickerView addGestureRecognizer:singleTap];
    
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    [popoverView addSubview:_pickerView];
    
    popoverContent.view = popoverView;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverController.delegate=self;
    
    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popoverController presentPopoverFromRect:btn.frame inView:viewBack permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)tapInPickerView:(UIGestureRecognizer *)sender
{
    NSMutableSet *deselectLabels = [NSMutableSet set];
    BOOL shouldDeselectOthers = NO;
    
    for (int i = 0; i < [_pickerView numberOfRowsInComponent:0]; i++)
    {
        SLPickerViewLabel *label = (SLPickerViewLabel *)[_pickerView viewForRow:i forComponent:0];
        
        // Is tap contained in the label?
        CGPoint point = [sender locationInView:label];
        if (CGRectContainsPoint(label.frame, point))
        {
            // Move pickerview to tapped row
            [_pickerView selectRow:i inComponent:0 animated:YES];
            if ([strType isEqualToString:@"Edition"])
            {
                EditionIndex = i;
                strEditionIdFinal = [[arrEdition objectAtIndex:i]valueForKey:@"iEditionID"];
                strEditionNameFinal = [[arrEdition objectAtIndex:i]valueForKey:@"vEdition"];
                lblEdition.text = strEditionNameFinal;
            }
            else
            {
                ZoneIndex = i;
                strZoneIdFinal = [[arrZone objectAtIndex:i]valueForKey:@"iZoneID"];
                strZoneNameFinal = [[arrZone objectAtIndex:i]valueForKey:@"vZone"];
                lblZone.text = strZoneNameFinal;
            }
            _currentPick = i;
            label.checkMarkView.hidden = NO;
            shouldDeselectOthers = YES;
        }
        else if (label != nil)
        {
            [deselectLabels addObject:label];
        }
    }
    
    if (shouldDeselectOthers)
    {
        for (SLPickerViewLabel *label in deselectLabels)
        {
            label.checkMarkView.hidden = YES;
        }
    }
    
    if ([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - UIPickerView data source and delegate protocols methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerData count];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    SLPickerViewLabel *label = (SLPickerViewLabel *)view;
    
    if (!label)
    {
        // Customize your label (or any other type UIView) here
        label = [[SLPickerViewLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerView.bounds.size.width * 0.8, 44.0f)];
    }
    
    if (row < [_pickerData count])
    {
        if ([strType isEqualToString:@"Edition"])
        {
            label.label.text = [(NSString *)[_pickerData objectAtIndex:row] valueForKey:@"vEdition"];
        }
        else
        {
            label.label.text = [(NSString *)[_pickerData objectAtIndex:row] valueForKey:@"vZone"];
        }
        label.checkMarkView.hidden = !(row == _currentPick);
    }
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 52.0f;
}


#pragma mark - orientations

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


-(void)setOrientation
{
    if(flagOrientation == 0)
    {
        imgHeader.image = [UIImage imageNamed:@"TopBar.png"];
        viewBack.frame = CGRectMake(20, 194, 729, 623);
    }
    else
    {
        imgHeader.image = [UIImage imageNamed:@"L-TopBar.png"];
        viewBack.frame = CGRectMake(147, 63, 729, 623);
    }
    
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
    
    if ([popoverController isPopoverVisible])
    {
        [popoverController presentPopoverFromRect:btnFrame.frame inView:viewBack permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}
-(IBAction)ClickBtnRestore:(id)sender
{
    if( ![AppDel checkConnection])
    {
        DisplayAlertconnection;
        return;
    }
    else
    {
        [AppDel doshowHUD];
        [[SubclassInAppHelper sharedInstance] RestoreProduct];
    }
}
@end
