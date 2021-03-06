//
//  SetResponsibilityViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "SetResponsibilityViewCtr.h"
#import "DatabaseAccess.h"
#import "AppDelegate.h"

#pragma mark - KeyBoard Methods
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
CGFloat animatedDistance;

@interface SetResponsibilityViewCtr ()

@end

@implementation SetResponsibilityViewCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(BOOL)viewDeckControllerWillCloseRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
//{
//    return NO;
//}
-(void)viewDeckControllerDidCloseRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    NSArray *vList = [self.navigationController viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i)
    {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"TempRightViewCtr"])
        {
            [self.navigationController popToViewController:view animated:YES];
            break;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  AppDel.deckController.panningMode = IIViewDeckNoPanning;
    
    [self updateui];
    
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"assignVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblassign"]];
        lblOption1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblOwnCont"]];
        lblOption2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblOrgCont"]];
        lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblmsg"]];
    }
    
    
    
    // Set Scroll Border
    // [self sclName:scl_OwnContact];
    // [self sclName:scl_OrgContact];
    
    // Set UITextView Border
    [self txtName:txtMessage];
    txtMessage.userInteractionEnabled = NO;
    
    YAxis = 94;
    // Get Own Contact From Local DB
    NSString *strQuerySelectOwn = @"SELECT * FROM tbl_own_contact";
    ArryOwnContact = [[NSMutableArray alloc] init];
    NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"contactid",@"Assigned to",@"firstName",@" you",@"lastName",nil];
    [ArryOwnContact addObject:d];
    NSMutableArray *ArryTempOwnContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_own_contact:strQuerySelectOwn]];
    for (int i = 0; i < [ArryTempOwnContact count]; i++)
    {
        [ArryOwnContact addObject:[ArryTempOwnContact objectAtIndex:i]];
    }
    // Get Org Contact From Local DB
    NSString *strQuerySelectOrg = @"SELECT * FROM tbl_org_contact";
    ArryOrgContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_org_contact:strQuerySelectOrg]];
    
    ArryAssign = [[NSMutableArray alloc] init];
    [self LoadOwnContact];
    // Do any additional setup after loading the view from its nib.
}
-(void)LoadOwnContact
{
    YAxis1 = 8;
    for (int i = 0; i < [ArryOwnContact count]; i++)
    {
        UILabel *lblContactName = [[UILabel alloc] initWithFrame:CGRectMake(5, YAxis1, 230, 21)];
        lblContactName.textColor = [UIColor blackColor];
        NSString *strFNAme = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryOwnContact objectAtIndex:i]valueForKey:@"firstName"]]];
        NSString *strLNAme = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryOwnContact objectAtIndex:i]valueForKey:@"lastName"]]];
        lblContactName.text = [NSString stringWithFormat:@"%@ %@",strFNAme,strLNAme];
        lblContactName.font = [UIFont fontWithName:@"ArialMT" size:16.0f];
        lblContactName.backgroundColor = [UIColor clearColor];
        lblContactName.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        lblContactName.textAlignment = NSTextAlignmentLeft;
        [scl_OwnContact addSubview:lblContactName];
        
        UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSelect.frame = CGRectMake(240, YAxis1, 25, 25);
        btnSelect.tag = i;
        btnSelect.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [btnSelect setTitle:lblContactName.text forState:UIControlStateNormal];
        [btnSelect setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btnSelect addTarget:self action:@selector(btnSelectOwnPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            strResponsible = [btnSelect currentTitle];
            strResponsibleID = [[ArryOwnContact objectAtIndex:i]valueForKey:@"contactid"];
            strContactFrom = @"Own";
            strSenderId = @"0";
            strRecieveId = @"0";
            strtaskCategoryType = @"GENEREL";
            strAssignedTo = 0;
            [btnSelect setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btnSelect setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        }
        [scl_OwnContact addSubview:btnSelect];
        
        [ArryAssign addObject:btnSelect];
        
        YAxis1 = YAxis1 + 36;
        YAxis = YAxis + 36;
    }
    YAxis1 = YAxis1 + 5;
    YAxis = YAxis + 5;
    scl_OwnContact.contentSize = CGSizeMake(280, YAxis1);
    scl_OwnContact.frame = CGRectMake(20, 94, 280, YAxis1 - 5);
    imgtrans1.frame = CGRectMake(20, 0, 280, YAxis1 - 5 + 94);
    
    YAxis1 = YAxis1 + 10;
    YAxis = YAxis + 10;
    lblOption2.frame = CGRectMake(20, YAxis, 280, 21);
    
    
    YAxis1 = YAxis1 + 31;
    YAxis = YAxis + 31;
    scl_OrgContact.frame = CGRectMake(20, YAxis, 280, 90);
    
    
    [self LoadOrgContact];
}
-(void)LoadOrgContact
{
    YAxis11 = 8;
    for (int i = 0; i < [ArryOrgContact count]; i++)
    {
        UILabel *lblContactName = [[UILabel alloc] initWithFrame:CGRectMake(5, YAxis11, 230, 21)];
        lblContactName.textColor = [UIColor blackColor];
        NSString *strFNAme = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryOrgContact objectAtIndex:i]valueForKey:@"firstName"]]];
        NSString *strLNAme = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryOrgContact objectAtIndex:i]valueForKey:@"lastName"]]];
        lblContactName.text = [NSString stringWithFormat:@"%@ %@",strFNAme,strLNAme];
        lblContactName.font = [UIFont fontWithName:@"ArialMT" size:16.0f];
        lblContactName.backgroundColor = [UIColor clearColor];
        lblContactName.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        lblContactName.textAlignment = NSTextAlignmentLeft;
        [scl_OrgContact addSubview:lblContactName];
        
        UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSelect.frame = CGRectMake(240, YAxis11, 25, 25);
        btnSelect.tag = i;
        btnSelect.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [btnSelect setTitle:lblContactName.text forState:UIControlStateNormal];
        [btnSelect setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btnSelect addTarget:self action:@selector(btnSelectOrgPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnSelect setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        [scl_OrgContact addSubview:btnSelect];
        
        [ArryAssign addObject:btnSelect];
        
        YAxis11 = YAxis11 + 36;
        YAxis = YAxis + 36;
    }
    YAxis11 = YAxis11 + 5;
    YAxis = YAxis + 5;
    scl_OrgContact.contentSize = CGSizeMake(280, YAxis11);
    scl_OrgContact.frame = CGRectMake(20, scl_OrgContact.frame.origin.y, 280, YAxis11 - 5);
    imgtrans2.frame = CGRectMake(20, scl_OrgContact.frame.origin.y - 34, 280, YAxis11 - 5 + 31);
    
    YAxis11 = YAxis11 + 10;
    YAxis = YAxis + 10;
    lblMessage.frame = CGRectMake(20, YAxis, 280, 21);
    
    
    imgtrans3.frame = CGRectMake(20, YAxis - 6, 280, 500);
    
    YAxis11 = YAxis11 + 31;
    YAxis = YAxis + 31;
    
    txtMessage.frame = CGRectMake(20, YAxis, 280, 90);
    
    btnSave.frame = CGRectMake(btnSave.frame.origin.x, YAxis + 120, btnSave.frame.size.width, btnSave.frame.size.height);
    btnCancel.frame = CGRectMake(btnCancel.frame.origin.x, YAxis + 120, btnCancel.frame.size.width, btnCancel.frame.size.height);

    scl_bg.contentSize = CGSizeMake(320, YAxis + 150);
}

#pragma mark - IBAction Methods
-(IBAction)btnSelectOwnPressed:(id)sender
{
    txtMessage.userInteractionEnabled = NO;
    for (int i = 0; i < [ArryAssign count]; i++)
    {
        [[ArryAssign objectAtIndex:i] setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    strResponsible = [sender currentTitle];
    strResponsibleID = [[ArryOwnContact objectAtIndex:[sender tag]]valueForKey:@"contactid"];
    strContactFrom = @"Own";
    strSenderId = @"0";
    strRecieveId = @"0";
    strtaskCategoryType = @"GENEREL";
    if ([strResponsibleID intValue] == 0)
    {
        strAssignedTo = @"0";
    }
    else
    {
        strAssignedTo = @"1";
    }
}
-(IBAction)btnSelectOrgPressed:(id)sender
{
    txtMessage.userInteractionEnabled = YES;
    for (int i = 0; i < [ArryAssign count]; i++)
    {
        [[ArryAssign objectAtIndex:i] setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    strResponsible = [sender currentTitle];
    strResponsibleID = [[ArryOrgContact objectAtIndex:[sender tag]]valueForKey:@"contactRequestId"];
    strContactFrom = @"Org";
    strSenderId = [[ArryOrgContact objectAtIndex:[sender tag]]valueForKey:@"senderId"];
    strRecieveId = [[ArryOrgContact objectAtIndex:[sender tag]]valueForKey:@"receiverId"];
    strtaskCategoryType = @"OUTBOX_NOT_ACCEPTED";
    strAssignedTo = @"2";
}
-(IBAction)btnSavePressed:(id)sender
{
    if (!strResponsible)
    {
        DisplayAlertWithTitle(App_Name, @"Please select conatct");
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strResponsible,@"Name",strResponsibleID,@"id",strContactFrom,@"From",strSenderId,@"SenderId",strRecieveId,@"RecieveId",strtaskCategoryType,@"CategoryType",txtMessage.text,@"Message",strAssignedTo,@"assignto",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetResponsibilityData" object:dic];
        [self CallPopViewCtr];
    }
}
-(IBAction)btnCancelPressed:(id)sender
{
    [self CallPopViewCtr];
}
-(void)CallPopViewCtr
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Set UIScrollView Border
-(void)sclName:(UIScrollView*)scl
{
    [scl.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [scl.layer setBorderWidth: 1.0];
    [scl.layer setMasksToBounds:YES];
}
#pragma mark - Set UITextView Border
-(void)txtName:(UITextView*)txt
{
    [txt.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txt.layer setBorderWidth: 1.0];
    [txt.layer setMasksToBounds:YES];
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
}
#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([txtMessage.text isEqualToString:@"Message..."])
    {
        txtMessage.text=@"";
    }
    CGRect textVWRect = [self.view.window convertRect:textView.bounds fromView:textView];
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



-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *strString = [txtMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] == 0)
    {
        txtMessage.text=@"Message...";
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
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
