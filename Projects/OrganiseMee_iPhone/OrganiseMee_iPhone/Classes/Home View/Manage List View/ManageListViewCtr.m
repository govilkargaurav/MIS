//
//  ManageListViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/18/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "ManageListViewCtr.h"
#import "DatabaseAccess.h"
#import "GlobalMethods.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

@interface ManageListViewCtr ()

@end

@implementation ManageListViewCtr

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
        lblTitle.frame = CGRectMake(lblTitle.frame.origin.x, lblTitle.frame.origin.y + 20, lblTitle.frame.size.width, lblTitle.frame.size.height);
        imgtopTrans.frame = CGRectMake(imgtopTrans.frame.origin.x, imgtopTrans.frame.origin.y, imgtopTrans.frame.size.width, imgtopTrans.frame.size.height+20);
    }
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
    if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"ManageListVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblCreate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblcreatenewlist"]];
        [btnCreate setTitle:@"Erstellen" forState:UIControlStateNormal];
    }
    
/*    [btnCreate.layer setBorderColor: [[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor]];
    [btnCreate.layer setBorderWidth: 2.0];
    [btnCreate.layer setMasksToBounds:YES];*/
    
    [self updateui];
    
    [self tfName:tfCreate];
    [self SetInsetToTextField:tfCreate];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
}

#pragma mark - Set label Border
-(void)tfName:(UITextField*)tf
{
    [tf.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [tf.layer setBorderWidth: 1.0];
    [tf.layer setMasksToBounds:YES];
}
-(void)SetInsetToTextField:(UITextField*)tf
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}

-(void)SetManageList
{
    UILabel *lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 242, 21)];
    lblHeading.textColor = [UIColor blackColor];
    if([UserLanguage isEqualToString:@"de"])
    {
        lblHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllisttitle"]];
    }
    else
    {
        lblHeading.text = @"Change or delete a list :";
    }
    lblHeading.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
    lblHeading.backgroundColor = [UIColor clearColor];
    lblHeading.textAlignment = NSTextAlignmentLeft;
    [ViewList addSubview:lblHeading];
    
    NSString *strQuerySelect = @"SELECT * FROM tbl_lists where listCategory=1 and liststatus!=3";
    ArryManageList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
    YAxis = 35;
    for (int i = 0; i < [ArryManageList count]; i++)
    {
        UILabel *lblListName = [[UILabel alloc] init];
        lblListName.textColor = [UIColor blackColor];
        lblListName.text = [NSString stringWithFormat:@"%@",[[ArryManageList objectAtIndex:i]valueForKey:@"listName"]];
        lblListName.font = [UIFont fontWithName:@"ArialMT" size:14.0f];
        lblListName.backgroundColor = [UIColor clearColor];
        lblListName.textAlignment = NSTextAlignmentLeft;
        [ViewList addSubview:lblListName];
        
        UITextField *tfListName = [[UITextField alloc]init];
        tfListName.textColor = [UIColor blackColor];
        tfListName.text = [NSString stringWithFormat:@"%@",[[ArryManageList objectAtIndex:i]valueForKey:@"listName"]];
        tfListName.backgroundColor = [UIColor whiteColor];
        tfListName.textAlignment = NSTextAlignmentLeft;
        tfListName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfListName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tfListName.borderStyle = UITextBorderStyleLine;
        [self tfName:tfListName];
        [self SetInsetToTextField:tfListName];
        tfListName.font = [UIFont fontWithName:@"ArialMT" size:14.0f];
        tfListName.delegate = self;
        tfListName.tag = i+1;
        [ViewList addSubview:tfListName];
        tfListName.hidden = YES;
        
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnEdit.tag = i+11;
        [btnEdit addTarget:self action:@selector(btnEditPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnEdit setImage:[UIImage imageNamed:@"pencil.png"] forState:UIControlStateNormal];
        [btnEdit setImage:[UIImage imageNamed:@"pencil_sel.png"] forState:UIControlStateHighlighted];
        [ViewList addSubview:btnEdit];
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.tag = i+21;
        [btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [btnDelete setImage:[UIImage imageNamed:@"delete_sel.png"] forState:UIControlStateHighlighted];
        [ViewList addSubview:btnDelete];
        
        UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.tag = i+31;
        [btnSave addTarget:self action:@selector(btnSavePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnSave setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [btnSave setImage:[UIImage imageNamed:@"ok_sel.png"] forState:UIControlStateHighlighted];
        [ViewList addSubview:btnSave];
        btnSave.hidden = YES;
        
        CGFloat width = [GlobalMethods CheckIphoneAndReturnWidth:180.0f Landscap5:428.0f Landscap:340.f Orientation:OrientationFlag];
        
        lblListName.frame = CGRectMake(10, YAxis, width, 31);
        tfListName.frame = CGRectMake(10, YAxis, width, 31);
        btnEdit.frame = CGRectMake(width + 20, YAxis, 30, 30);
        btnDelete.frame = CGRectMake(width + 60, YAxis, 30, 30);
        btnSave.frame = CGRectMake(width + 40, YAxis, 30, 30);
        
        YAxis = YAxis + 37;
    }
    
    CGFloat width1 = [GlobalMethods CheckIphoneAndReturnWidth:280.0f Landscap5:528.0f Landscap:440.f Orientation:OrientationFlag];
    
    
        ViewList.frame = CGRectMake(0, 0, width1, YAxis + 2);
    
    UIImageView *imgbg = [[UIImageView alloc]init];
    imgbg.frame = CGRectMake(0, 0, ViewList.frame.size.width, ViewList.frame.size.height);
    imgbg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imgbg.image = [UIImage imageNamed:@"bgTrans.png"];
    [ViewList addSubview:imgbg];
    [ViewList sendSubviewToBack:imgbg];

    
    ViewCreate.frame = CGRectMake(0, YAxis + 6, width1, 460);
    
    scl_bg.contentSize = CGSizeMake(width1, YAxis + 130);
    
        
   
    
}

#pragma mark - Remove SubViews
-(void)RemoveSubViews
{
    while ([ViewList.subviews count] > 0) {
        
        [[[ViewList subviews] objectAtIndex:0] removeFromSuperview];
    }
}

#pragma mark - IBAction Methods

-(IBAction)btnCreatePressed:(id)sender
{
    if ([ArryManageList count] >= 5)
    {
        NSString *strAlertMsg;
        if([UserLanguage isEqualToString:@"de"])
        {
            strAlertMsg = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"maxlimitmsg"]];
        }
        else
        {
            strAlertMsg = @"You have reached the maximum number of task lists for a basic account in Organisemee. In the premium account you will be able to create an unlimited number of task lists. Currently the premium version is not available yet. Stay tuned for news.";
        }
        DisplayAlertWithTitle(App_Name, strAlertMsg);
        return;
        
    }
    else if ([[tfCreate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please enter list name");
        return;
    }
    else
    {
        NSString *strMaxListID = @"SELECT max(listid) FROM tbl_lists";
        int listID = [DatabaseAccess getMaxid:strMaxListID];
        listID = listID + 1;
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_lists(listId,listName,listActiveColor,listCategory,liststatus,islistnew) values(%d,'%@','%@',%d,%d,%d)",listID,tfCreate.text,@"",1,1,1];
        [DatabaseAccess updatetbl:strQueryInsert];
                
        tfCreate.text = @"";
        [tfCreate resignFirstResponder];
        [self RemoveSubViews];
        [self SetManageList];
    }
}
-(IBAction)btnEditPressed:(id)sender
{
    int Sendertag = [sender tag];
    UITextField *tfEdit = (UITextField*)[ViewList viewWithTag:Sendertag-10];
    tfEdit.hidden = NO;
    
    UIButton *btnEdit = (UIButton*)[ViewList viewWithTag:Sendertag];
    btnEdit.hidden = YES;
    
    UIButton *btnDelete = (UIButton*)[ViewList viewWithTag:Sendertag+10];
    btnDelete.hidden = YES;
    
    UIButton *btnSave = (UIButton*)[ViewList viewWithTag:Sendertag+20];
    btnSave.hidden = NO;
    
    
}
-(IBAction)btnDeletePressed:(id)sender
{
    int Sendertag = [sender tag];
    NSString *strAlertMsg,*strDelete,*strCancel;
    if([UserLanguage isEqualToString:@"de"])
    {
        strAlertMsg = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"deleteConfirm"]];
        strDelete = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"btndelete"]];
        strCancel = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"btncancel"]];
    }
    else
    {
        strAlertMsg = @"Do you really want to delete the task list and all it’s tasks?";
        strDelete = @"Delete";
        strCancel = @"Cancel";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:strAlertMsg delegate:self cancelButtonTitle:strCancel otherButtonTitles:strDelete,nil];
    alert.tag = Sendertag;
    [alert show];
}
-(IBAction)btnSavePressed:(id)sender
{
    int Sendertag = [sender tag];
    UITextField *tfEdit = (UITextField*)[ViewList viewWithTag:Sendertag-30];
    NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_lists Set listName='%@',liststatus=2 Where listId=%d",tfEdit.text,[[[ArryManageList objectAtIndex:Sendertag-31]valueForKey:@"listId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdate];
    
    [self RemoveSubViews];
    [self SetManageList];
}


#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        if ([[[ArryManageList objectAtIndex:alertView.tag-21]valueForKey:@"islistnew"] intValue] == 1)
        {
            NSString *strQueryUpdate = [NSString stringWithFormat:@"DELETE FROM tbl_lists Where listId=%d",[[[ArryManageList objectAtIndex:alertView.tag-21]valueForKey:@"listId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdate];
        }
        else
        {
            NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_lists Set liststatus=3 Where listId=%d",[[[ArryManageList objectAtIndex:alertView.tag-21]valueForKey:@"listId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdate];
        }
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_tasks Where listId=%d",[[[ArryManageList objectAtIndex:alertView.tag-21]valueForKey:@"listId"] intValue]];
        [DatabaseAccess updatetbl:strQueryDelete];
        
        [self RemoveSubViews];
        [self SetManageList];
    }
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
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (id textField in ViewCreate.subviews) {
        
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
        else if ([textField isKindOfClass:[UITextView class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
    for (id textField in ViewList.subviews) {
        
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
        else if ([textField isKindOfClass:[UITextView class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        OrientationFlag = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        OrientationFlag = 1;
    }
    [self RemoveSubViews];
    [self SetManageList];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textField.layer setBorderWidth: 1.0];
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
    [self tfName:textField];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
