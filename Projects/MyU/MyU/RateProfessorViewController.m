//
//  RateProfessorViewController.m
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RateProfessorViewController.h"

@interface RateProfessorViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableDictionary *dictRateStatus;
    IBOutlet UIView *viewRateBox;
    IBOutlet UIView *viewRateButtons;
    IBOutlet UITextField *txtSubject;
    IBOutlet UITextField *txtYear;
    IBOutlet UITextView *txtComment;
    IBOutlet UILabel *lblProfessorName;
    IBOutlet UIImageView *imgbgbox;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnRule;
    BOOL canGoBack;
}

@end

@implementation RateProfessorViewController
@synthesize dictProfessor,selectedratingindex,isNotificationRating;
@synthesize _delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    canGoBack=YES;
    imgbgbox.image=[[UIImage imageNamed:@"bg_rateprof"] resizableImageWithCapInsets:UIEdgeInsetsMake(280,0.0, 65.0, 0.0)];
    
    if (isNotificationRating)
    {
        lblProfessorName.text=[[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"professor_info"] objectForKey:@"name"]removeNull];
    }
    else
    {
        lblProfessorName.text=[[dictProfessor objectForKey:@"professor_name"] removeNull];
    }
    dictRateStatus=[[NSMutableDictionary alloc]init];
    [self resetratebuttons];
}
-(void)resetratebuttons
{
    for (UIButton *btn in [viewRateButtons subviews])
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            UIButton *thebtn=(UIButton *)[viewRateButtons viewWithTag:btn.tag];
            [thebtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"unrat%d.png",(btn.tag)%100]] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)btnBackClicked:(id)sender
{
    if (canGoBack)
    {
        [self backtopreviousview];
    }
}
-(void)backtopreviousview
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
-(IBAction)btnRulesClicked:(id)sender
{
    if ([strRules length]>0) {
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Rules" message:strRules delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        [self loadrules];
    }
}

-(void)loadrules
{
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRulesURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:nil postData:nil withsucessHandler:@selector(rulesloaded:) withfailureHandler:@selector(rulesfailed:) withCallBackObject:self];
    [obj startRequest];
}

-(void)rulesloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([dictResponse objectForKey:@"content"])
    {
        [strRules setString:[dictResponse objectForKey:@"content"]];
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Rules" message:[dictResponse objectForKey:@"content"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        kGRAlert(@"Server Error");
    }
}
-(void)rulesfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}



-(IBAction)btnRateClicked:(id)sender
{
    NSInteger rowid=([(UIButton *)sender tag]/100);
    for (UIButton *btn in [viewRateButtons subviews])
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            if (([btn tag]>(rowid*100)) && ([btn tag]<=((rowid*100)+5)))
            {
                if ([btn tag]==[(UIButton *)sender tag])
                {
                    [dictRateStatus setObject:[NSString stringWithFormat:@"%d",(btn.tag)%100] forKey:[NSString stringWithFormat:@"%d",rowid]];
                }
                
                UIButton *thebtn=(UIButton *)[viewRateButtons viewWithTag:btn.tag];
                [thebtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@rat%d.png",([(UIButton *)sender tag]==btn.tag)?@"":@"un",(btn.tag)%100]] forState:UIControlStateNormal];
            }
        }
    }
}
-(IBAction)btnSubjectClicked:(id)sender
{
    [txtSubject becomeFirstResponder];
}
-(IBAction)btnYearClicked:(id)sender
{
    [txtYear becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField==txtYear)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs;

        
        if (newLength==1)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"12"] invertedSet];
        }
        else if (newLength==2)
        {
            if ([textField.text isEqualToString:@"1"])
            {
                cs= [[NSCharacterSet characterSetWithCharactersInString:@"9"] invertedSet];
            }
            else
            {
                cs= [[NSCharacterSet characterSetWithCharactersInString:@"0"] invertedSet];
            }
        }
        else
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];           
        }
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        while (newLength < 4)
        {
            return [string isEqualToString:filtered];
        }
        
        return (newLength>4)?NO:YES;
    }
    else
    {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if ((theTouch.view==viewRateBox) || (theTouch.view==self.view))
    {
        [viewRateBox endEditing:YES];
        [self.view endEditing:YES];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [viewRateBox setFrame:CGRectMake(0,44.0-((IS_DEVICE_iPHONE_5)?81.0:169.0),320,460+iPhone5ExHeight-38.0)];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [viewRateBox setFrame:CGRectMake(0,38.0+iOS7,320,460+iPhone5ExHeight-38.0)];
    [UIView commitAnimations];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    //[viewRateBox setFrame:CGRectMake(0,44.0-((IS_DEVICE_iPHONE_5)?81.0:169.0),320,460+iPhone5ExHeight)];
    [viewRateBox setFrame:CGRectMake(0,-165.0,320,460+iPhone5ExHeight-38.0)];
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [viewRateBox setFrame:CGRectMake(0,38.0+iOS7,320,460+iPhone5ExHeight-38.0)];
    [UIView commitAnimations];
}
-(IBAction)btnDoneClicked:(id)sender
{
    [[[MyAppManager sharedManager]dateFormatter] setDateFormat:@"yyyy"];
    
    NSString *strYearCount=[[[MyAppManager sharedManager]dateFormatter] stringFromDate:[NSDate date]];
    
    if ((![[dictRateStatus objectForKey:@"1"] integerValue]) || (![[dictRateStatus objectForKey:@"2"] integerValue]) || (![[dictRateStatus objectForKey:@"3"] integerValue]) || (![[dictRateStatus objectForKey:@"4"] integerValue]))
    {
        kGRAlert(@"Please complete all fields.");
    }
    else if([[txtSubject.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter course.");
    }
    else if([[txtYear.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter year.");
    }
    else if([[txtYear.text removeNull] length]!=4)
    {
        kGRAlert(@"Please enter valid year.");
    }
    else if([strYearCount integerValue]<[[txtYear.text removeNull] integerValue])
    {
        kGRAlert(@"Please enter valid year.");
    }
    else if([[txtComment.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter comment.");
    }
    else
    {
        NSString *strProfessior_id,*strNotification_id;
        if (isNotificationRating)
        {
            strProfessior_id = [NSString stringWithFormat:@"%@",[[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"professor_info"] objectForKey:@"id"] removeNull]];
            strNotification_id = [NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"notification_id"] removeNull]];
        }
        else
        {
            strProfessior_id = [NSString stringWithFormat:@"%@",[[dictProfessor objectForKey:@"professor_id"] removeNull]];
            strNotification_id= @"";
        }
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strProfessior_id,@"professor_id",[dictRateStatus objectForKey:@"1"],@"easy_rating",[dictRateStatus objectForKey:@"2"],@"explain_rating",[dictRateStatus objectForKey:@"3"],@"interest_rating",[dictRateStatus objectForKey:@"4"],@"available_rating",[txtSubject.text removeNull],@"course_name",[txtYear.text removeNull],@"year",[txtComment.text removeNull],@"user_comment",strNotification_id,@"notification_id",  nil];
        canGoBack=NO;
        self.view.userInteractionEnabled=NO;
        btnDone.enabled=NO;

        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRatingAddRatingURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(rateprofessordone:) withfailureHandler:@selector(rateprofessorfailed:) withCallBackObject:self];
        [obj startRequest];
    }
}

-(void)rateprofessordone:(id)sender
{
    self.view.userInteractionEnabled=YES;
    btnDone.enabled=YES;
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Professor successfully rated!");
        
        if (isNotificationRating)
        {
            [arrNotifications removeObjectAtIndex:selectedratingindex];
            [self backtopreviousview];
            [self._delegate ReloadNotiFicationData];
            return;
        }
        
        NSInteger canrate_time=[[[dictProfessorRatings objectForKey:@"canrate_time"] removeNull]integerValue];
        canrate_time--;
        [dictProfessorRatings setObject:[NSString stringWithFormat:@"%d",canrate_time] forKey:@"canrate_time"];
        [arrProfessorRatings addObject:[[dictResponse objectForKey:@"professor_ratings"] objectAtIndex:0]];
        
        for (int i=0; i<[arrProfessors count]; i++)
        {
            if ([[[[arrProfessors objectAtIndex:i]objectForKey:@"professor_id"] removeNull] isEqualToString:[[dictProfessor objectForKey:@"professor_id"] removeNull]])
            {
                [arrProfessors replaceObjectAtIndex:i withObject:[[dictResponse objectForKey:@"prof_rate"] objectAtIndex:0]];
                break;
            }
        }
        
        [self backtopreviousview];
    }
    else
    {
        canGoBack=YES;
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)rateprofessorfailed:(id)sender
{
    self.view.userInteractionEnabled=YES;
    btnDone.enabled=YES;

    canGoBack=YES;
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


#pragma mark - EXTRA METHODS
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
    [super didReceiveMemoryWarning];
}

@end
