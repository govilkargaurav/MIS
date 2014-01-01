//
//  EditProfileViewController.m
//  MyU
//
//  Created by Vijay on 7/18/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UIImage+Utilities.h"
#import "ALPickerView.h"

typedef enum
{
    University,
    Gender
}
PickerType;

@interface EditProfileViewController () <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ALPickerViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollViewProfile;
    IBOutlet UIView *viewProfile;
    
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UITextField *txtnewpwd;
    IBOutlet UITextField *txtoldpwd;
    IBOutlet UITextField *txtconfpwd;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtNickName;
    IBOutlet UITextField *txtUniversityName;
    IBOutlet UITextField *txtDepartment;
    IBOutlet UITextField *txtBio;
    IBOutlet UITextView *txtViewBio;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtMobile;
    IBOutlet UITextField *txtGender;
    IBOutlet UITextField *txtBirthdate;
    UIDatePicker *datePickerView;
    ALPickerView *pickerView;
    
    NSMutableArray *arrUniversityNames;
    NSMutableArray *arrGenders;
    NSInteger selecteduni;
    NSInteger selecteduni_id;
    NSInteger selectedgender;
    NSDate *selectedDate;
    PickerType selectedPicker;
    UIView *viewDatePicker;
    
    IBOutlet UIView *viewChangePassword;
    
}

@end

@implementation EditProfileViewController
#pragma mark - View Did Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollViewProfile addSubview:viewProfile];
    scrollViewProfile.contentSize=viewProfile.frame.size;
    
    selecteduni=-1;
    selecteduni_id=0;
    selectedgender=-1;
    
    txtName.text=[[dictUserInfo objectForKey:@"name"] removeNull];
    txtNickName.text=[[dictUserInfo objectForKey:@"username"] removeNull];
    txtUniversityName.text=[[dictUserInfo objectForKey:@"universityname"] removeNull];
    txtDepartment.text=[[dictUserInfo objectForKey:@"department"] removeNull];
    txtViewBio.text=[[dictUserInfo objectForKey:@"bio"] removeNull];
    
    if ([txtViewBio.text length]!=0) {
        txtBio.alpha=0.0;
    }
    
    imgProfilePic.opaque=YES;
    imgProfilePic.clipsToBounds=YES;
    [imgProfilePic setImageWithURL:[NSURL URLWithString:[[[dictUserInfo objectForKey:@"thumbnail"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];

    txtEmail.text=([[[dictUserInfo objectForKey:@"faculty"] removeNull] isEqualToString:@"yes"])?[[dictUserInfo objectForKey:@"university_email"] removeNull]:[[dictUserInfo objectForKey:@"email"] removeNull];
    txtMobile.text=[[dictUserInfo objectForKey:@"phone_number"] removeNull];
    txtGender.text=[[dictUserInfo objectForKey:@"gender"] removeNull];
    txtBirthdate.text=[[dictUserInfo objectForKey:@"birthday"] removeNull];
    
    arrUniversityNames=[[NSMutableArray alloc]init];
    [self performSelector:@selector(syncuniversities)];
    
    arrGenders=[[NSMutableArray alloc]init];
    [arrGenders addObject:@"Male"];
    [arrGenders addObject:@"Female"];
    
    selectedPicker=University;
    
    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,460+iPhone5ExHeight+iOS7, 320.0, 216.0)];
    [self.view addSubview:pickerView];
    pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    pickerView.delegate=self;
    [pickerView reloadAllComponents];
    
    viewDatePicker=[[UIView alloc]init];
    
    UIBarButtonItem *btncancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnDateCanceleClicked:)];
    UIBarButtonItem *fxspace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btndone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDateDoneClicked:)];
    
    NSArray *arrToolbar= [NSArray arrayWithObjects:btncancel,fxspace,btndone,nil];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0+iOS7, 320.0, 44.0)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar setItems:arrToolbar];
    [viewDatePicker addSubview:toolBar];

    datePickerView= [[UIDatePicker alloc]init];
    [datePickerView setFrame:CGRectMake(0.0,44.0+iOS7, 320.0, 216.0)];
    [viewDatePicker addSubview:datePickerView];
    datePickerView.datePickerMode=UIDatePickerModeDate;
    [datePickerView setDate:[NSDate date]];
    
    [viewDatePicker setFrame:CGRectMake(0,460+iPhone5ExHeight,320.0,260.0)];
    [self.view addSubview:viewDatePicker];
    
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePicker)];
    tapGest.numberOfTapsRequired=1;
    [scrollViewProfile addGestureRecognizer:tapGest];
    
    scrollViewProfile.contentSize=viewProfile.frame.size;
}
-(void)syncuniversities
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObject:@"" forKey:@"lastsyncedtimestamp"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLoadUniversityURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(universitysynced:) withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)universitysynced:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([dictResponse objectForKey:@"university_list"])
        {
            [arrUniversityNames removeAllObjects];
            [arrUniversityNames addObjectsFromArray:[dictResponse objectForKey:@"university_list"]];
            [pickerView reloadAllComponents];
        }
    }
}

-(void)btnDateCanceleClicked:(id)sender
{
    [self hidePicker];
}
-(void)btnDateDoneClicked:(id)sender
{
    [[[MyAppManager sharedManager] dateFormatter]  setDateFormat:@"yyyy-MM-dd"];
    txtBirthdate.text=[[[MyAppManager sharedManager] dateFormatter] stringFromDate:datePickerView.date];
    [self hidePicker];
}
-(IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

-(IBAction)btnSaveProfileClicked:(id)sender
{
    [self updateprofilecall];
    [self hidePicker];
    [viewProfile endEditing:YES];
}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [viewProfile endEditing:YES];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    txtBio.alpha=(textView.text.length!=0)?0.0:1.0;
    
    [self hidePicker];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    scrollViewProfile.contentSize=CGSizeMake(320.0,viewProfile.frame.size.height+216.0);
    
    float contentoffset=0.0;
    
    if(textView ==txtViewBio)
    {
        contentoffset=162.0-iPhone5ExHeight;
    }
        
    if (contentoffset>0.0)
    {
        if (scrollViewProfile.contentOffset.y<contentoffset)
        {
            scrollViewProfile.contentOffset=CGPointMake(0.0,contentoffset);
        }
    }
    
    [UIView commitAnimations];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];

    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height+216.0);

    float contentoffset=0.0;
    
    if(textField ==txtDepartment)
    {
        contentoffset=39.0-iPhone5ExHeight;
    }
    else if(textField ==txtBio)
    {
        contentoffset=164.0-iPhone5ExHeight;
    }
    else if(textField ==txtEmail)
    {
        contentoffset=283.0-iPhone5ExHeight;
    }
    else if(textField ==txtMobile)
    {
        contentoffset=326.0-iPhone5ExHeight;
    }
    
    if (contentoffset>0.0)
    {
        if (scrollViewProfile.contentOffset.y<contentoffset)
        {
            scrollViewProfile.contentOffset=CGPointMake(0.0,contentoffset);
        }
    }
    
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    txtBio.alpha=(range.location>0 || text.length!=0)?0.0:1.0;
    
    return (newLength>150)?NO:YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    txtBio.alpha=(textView.text.length!=0)?0.0:1.0;

    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"the scroll:%f",scrollViewProfile.contentOffset.y);
}
-(IBAction)btnUpdateProfileImageClicked:(id)sender
{
    [self hidePicker];
    [viewProfile endEditing:YES];
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height);
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actsheet=[[UIActionSheet alloc]initWithTitle:@"Please select source." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Photo Library", nil];
        actsheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        actsheet.tag=101;
        [actsheet showInView:self.view];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([actionSheet tag]) {
        case 101:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    //Cancel
                }
                    break;
                case 1:
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        kGRAlert(@"\nThis device doesn't contain\ncamera.");
                    }
                    else
                    {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.delegate = self;
                        picker.allowsEditing=YES;
                        [self presentViewController:picker animated:YES completion:^{}];
                    }
                }
                    break;
                case 2:
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.allowsEditing=YES;
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:^{}];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [imgProfilePic setImage:[image cropCenterToSize:CGSizeMake(80.0, 80.0)]];
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"id",nil];
    NSDictionary *dictData=[NSDictionary dictionaryWithObjectsAndKeys:UIImagePNGRepresentation([image scaleAndRotateImage]),@"profile_picture",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChangeProfilePicURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:dictData withsucessHandler:@selector(profilepichanged:) withfailureHandler:@selector(profilepicupdatefailed:) withCallBackObject:self];
    [[MyAppManager sharedManager] showLoader];
    [obj startRequest];
    
	[picker dismissViewControllerAnimated:YES completion:^{}];
}
-(void)profilepichanged:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [dictUserInfo setObject:[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"profile_picture"]] forKey:@"profile_picture"];
        [dictUserInfo setObject:[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"thumbnail"]] forKey:@"thumbnail"];
        
        strUserProfilePic=[[NSString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"thumbnail"] removeNull]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateProfilePicProfilveVC" object:Nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateProfilePicLeftSide" object:Nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"user_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)profilepicupdatefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)updateprofilecall
{
    NSInteger pre_uni_id=[[dictUserInfo objectForKey:@"university"] integerValue];
    NSString *strUniIdUpdated;
    
    if ((pre_uni_id==0) && (selecteduni_id==0))
    {
        strUniIdUpdated=[NSString stringWithFormat:@""];
    }
    else if(selecteduni_id!=0)
    {
        strUniIdUpdated=[NSString stringWithFormat:@"%d",selecteduni_id];
    }
    else
    {
        strUniIdUpdated=[NSString stringWithFormat:@"%d",pre_uni_id];
    }
    
    if ([[[txtName.text removeNull] removeNull]length]==0)
    {
        kGRAlert(@"Please enter name.");
        return;
    }
    else if ([[[txtEmail.text removeNull] removeNull]length]==0)
    {
        kGRAlert(@"Please enter email.");
        return;
    }
    else if (![[txtEmail.text removeNull] isValidEmail])
    {
        kGRAlert(@"Please enter valid email.");
        return;
    }
        
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"id",[txtName.text removeNull],@"name",[txtUniversityName.text removeNull],@"uni_name",strUniIdUpdated,@"university",[txtDepartment.text removeNull],@"department",[txtViewBio.text removeNull],@"bio",[txtMobile.text removeNull],@"phone_number",[txtGender.text removeNull],@"gender",[txtBirthdate.text removeNull],@"birthday",nil];

    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kUpdateProfileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(profileupdated:) withfailureHandler:@selector(profileupdatefailed:) withCallBackObject:self];
    [[MyAppManager sharedManager] showLoader];
    [obj startRequest];
}
-(void)profileupdated:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Profile updated successfully");
        
        NSMutableDictionary *dictUserInfos =[[NSMutableDictionary alloc]initWithDictionary:[dictResponse objectForKey:@"user_data"]];
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfos forKey:@"user_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [dictUserInfo removeAllObjects];
        [dictUserInfo addEntriesFromDictionary:dictUserInfos];
        
        strUserId=[[NSString alloc]initWithFormat:@"%@",[dictUserInfo valueForKey:@"id"]];
        strUserUniId=[[NSString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"university"] removeNull]];
        strUserProfilePic=[[NSString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"thumbnail"] removeNull]];
        strSubscribedUni=[[NSMutableString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"uni_list"] removeNull]];
        NSString *canAddNews=[[[NSString alloc]initWithFormat:@"%@",[dictUserInfo valueForKey:@"can_add_news"]] removeNull];
        canPostNews=([canAddNews isEqualToString:@"1"])?YES:NO;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)profileupdatefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
}

-(IBAction)btnUniversityClicked:(id)sender
{
    if ([arrUniversityNames count]>0)
    {
        [viewProfile endEditing:YES];
        [viewDatePicker setFrame:CGRectMake(0,self.view.frame.size.height,320,260.0)];
        selectedPicker=University;
        [pickerView reloadAllComponents];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
        [UIView commitAnimations];
        scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height+216.0);
    }
    else
    {
        kGRAlert(kUniversityNotLoadedAlert);
    }
    
}
-(IBAction)btnDepartmentClicked:(id)sender
{
    [viewProfile endEditing:YES];

    [viewDatePicker setFrame:CGRectMake(0,self.view.frame.size.height,320,260.0)];
    [pickerView reloadAllComponents];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height+216.0);
    
    if (!IS_DEVICE_iPHONE_5)
    {
        if (scrollViewProfile.contentOffset.y<49.0)
        {
            scrollViewProfile.contentOffset=CGPointMake(0.0,49.0);
        }
    }
    
    [UIView commitAnimations];
}
-(IBAction)btnGenderClicked:(id)sender
{
    [viewProfile endEditing:YES];

    [viewDatePicker setFrame:CGRectMake(0,self.view.frame.size.height,326-iPhone5ExHeight,260.0)];
    selectedPicker=Gender;
    [pickerView reloadAllComponents];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height+216.0);
    if (scrollViewProfile.contentOffset.y<326.0-iPhone5ExHeight)
    {
        scrollViewProfile.contentOffset=CGPointMake(0.0,326.0-iPhone5ExHeight);
    }
    
    [UIView commitAnimations];
}
-(IBAction)btnBirthdateClicked:(id)sender
{
    [viewProfile endEditing:YES];
    [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [viewDatePicker setFrame:CGRectMake(0,460+iPhone5ExHeight-260.0,320,260.0)];
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height+260.0);
    if (scrollViewProfile.contentOffset.y<415.0-iPhone5ExHeight)
    {
        scrollViewProfile.contentOffset=CGPointMake(0.0,415.0-iPhone5ExHeight);
    }
    
    [UIView commitAnimations];
}


#pragma mark - PICKERVIEW
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
    switch (selectedPicker)
    {
        case University:
        {
            return [arrUniversityNames count];
        }
            break;
            
        case Gender:
        {
            return [arrGenders count];
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
    switch (selectedPicker)
    {
        case University:
        {
            return [[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
        }
            break;
            
        case Gender:
        {
            return [arrGenders objectAtIndex:row];
        }
            break;
            
        default:
            break;
    }
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
    switch (selectedPicker)
    {
        case University:
        {
            return ((row==selecteduni)?YES:NO);
        }
            break;
            
        case Gender:
        {
            return ((row==selectedgender)?YES:NO);
        }
            break;
            
        default:
            break;
    }
}

- (void)pickerView:(ALPickerView *)pickerViews didCheckRow:(NSInteger)row
{
    switch (selectedPicker)
    {
        case University:
        {
            selecteduni=row;
            selecteduni_id=[[[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityid"] removeNull] integerValue];
            txtUniversityName.text=[[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
        }
            break;
            
        case Gender:
        {
            selectedgender=row;
            txtGender.text=[arrGenders objectAtIndex:selectedgender];
        }
            break;
            
        default:
            break;
    }
    
    [self hidePicker];
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{
    
}

-(void)hidePicker
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
    [viewDatePicker setFrame:CGRectMake(0,self.view.frame.size.height,320,260.0)];
    scrollViewProfile.contentSize=CGSizeMake(320.0, viewProfile.frame.size.height);
    [UIView commitAnimations];
}

-(void)showpasswordchangealert
{
    [viewProfile endEditing:YES];
    
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Change Password" message:@" \n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil];
    alert.tag=201;
    txtoldpwd = [[UITextField alloc] initWithFrame:CGRectMake(12, 40, 260, 27)];
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 0);
    [alert setTransform:myTransform];
    txtoldpwd.delegate=self;
    txtoldpwd.placeholder=@"Old Password";
    txtoldpwd.secureTextEntry=YES;
    txtoldpwd.keyboardAppearance = UIKeyboardAppearanceAlert;
    txtoldpwd.borderStyle=UITextBorderStyleRoundedRect;
    txtoldpwd.font=[UIFont systemFontOfSize:14.0f];
    [txtoldpwd becomeFirstResponder];
    [txtoldpwd setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:txtoldpwd];
    
    txtnewpwd = [[UITextField alloc] initWithFrame:CGRectMake(12, 70, 260, 27)];
    txtnewpwd.delegate=self;
    txtnewpwd.secureTextEntry=YES;
    txtnewpwd.placeholder=@"New Password";
    txtnewpwd.keyboardAppearance = UIKeyboardAppearanceAlert;
    txtnewpwd.borderStyle=UITextBorderStyleRoundedRect;
    txtnewpwd.font=[UIFont systemFontOfSize:14.0f];
    [txtnewpwd setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:txtnewpwd];
    
    txtconfpwd = [[UITextField alloc] initWithFrame:CGRectMake(12, 100, 260, 27)];
    txtconfpwd.delegate=self;
    txtconfpwd.secureTextEntry=YES;
    txtconfpwd.placeholder=@"Confirm Password";
    txtconfpwd.keyboardAppearance = UIKeyboardAppearanceAlert;
    txtconfpwd.borderStyle=UITextBorderStyleRoundedRect;
    txtconfpwd.font=[UIFont systemFontOfSize:14.0f];
    [txtconfpwd setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:txtconfpwd];
    
    [alert show];
}
#pragma mark - Change Password
-(IBAction)btnChangePasswordClicked:(id)sender
{
    //[self showpasswordchangealert];
    txtoldpwd.text = @"";
    txtnewpwd.text = @"";
    txtconfpwd.text = @"";
    [txtoldpwd becomeFirstResponder];
    //[self.view addSubview:viewChangePassword];
    //[self.view bringSubviewToFront:viewChangePassword];

    viewChangePassword.alpha=0;
    viewChangePassword.transform = CGAffineTransformScale(viewChangePassword.transform ,1.5, 1.5);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    viewChangePassword.alpha = 1;
    viewChangePassword.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
}
-(IBAction)btnOKChangePasswordClicked
{
    
    if ([[txtoldpwd.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter old password");
    }
    else if ([[txtnewpwd.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter new password");
    }
    else if ([[txtconfpwd.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter confirm password");
    }
    else if (![[txtnewpwd.text removeNull] isEqualToString:[txtconfpwd.text removeNull]])
    {
        kGRAlert(@"Password and confirm password should match.");
    }
    else if ([[txtoldpwd.text removeNull] isEqualToString:[txtconfpwd.text removeNull]])
    {
        kGRAlert(@"Old Password and confirm password should not same.");
    }
    else
    {
        [self btnCancelChangePassword:nil];
        [self performSelector:@selector(changepasswordcalled) withObject:nil afterDelay:0.0];
    }
}
-(IBAction)btnCancelChangePassword:(id)sender
{
    [viewChangePassword endEditing:YES];
    viewChangePassword.transform = CGAffineTransformScale(viewChangePassword.transform ,1.0, 1.0);
    viewChangePassword.alpha=1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    viewChangePassword.alpha = 0;
    viewChangePassword.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView commitAnimations];
    //[self performSelector:@selector(RemoveChangePasswordView) withObject:nil afterDelay:0.5];
}
-(void)RemoveChangePasswordView
{
    [viewChangePassword removeFromSuperview];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==201)
    {
        if (buttonIndex==1)
        {
            if ([[txtoldpwd.text removeNull] length]==0)
            {
                [self showpasswordchangealert];
                kGRAlert(@"Please enter old password");
            }
            else if ([[txtnewpwd.text removeNull] length]==0)
            {
                [self showpasswordchangealert];
                kGRAlert(@"Please enter new password");
            }
            else if ([[txtconfpwd.text removeNull] length]==0)
            {
                [self showpasswordchangealert];
                kGRAlert(@"Please enter confirm password");
            }
            else if (![[txtnewpwd.text removeNull] isEqualToString:[txtconfpwd.text removeNull]])
            {
                [self showpasswordchangealert];
                kGRAlert(@"Password and confirm password should match.");
            }
            else if ([[txtoldpwd.text removeNull] isEqualToString:[txtconfpwd.text removeNull]])
            {
                [self showpasswordchangealert];
                kGRAlert(@"Old Password and confirm password should not same.");
            }
            else
            {
                [self performSelector:@selector(changepasswordcalled) withObject:nil afterDelay:0.0];
            }
        }
    }
}

-(void)changepasswordcalled
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[txtoldpwd.text removeNull],@"old_password",[txtnewpwd.text removeNull],@"new_password",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChangePasswordURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(passwordchanged:) withfailureHandler:@selector(passwordchangefailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)passwordchanged:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Password Changed Successfully.")
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"MESSAGE"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)passwordchangefailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - DEFAULT METHODS
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

- (void)viewDidUnload {
    viewChangePassword = nil;
    [super viewDidUnload];
}
@end
