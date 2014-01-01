//
//  RatingsViewController.m
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RatingsViewController.h"
#import "ProfessorAllRateViewController.h"
#import "RatingsCustomCell.h"
#import "ALPickerView.h"
#import "NSString+Utilities.h"
#import "CustomBadge.h"

@interface RatingsViewController () <UITextFieldDelegate,ALPickerViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIButton *btnChat;
    IBOutlet UIView *viewAddProffesor;
    IBOutlet UIView *viewAddProBox;
    IBOutlet UIView *viewDisabler;
    IBOutlet UITextField *txtProfName;
    IBOutlet UILabel *lblUniversity;
    IBOutlet UITextField *txtEmail;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIActivityIndicatorView *actIndicator;
    NSInteger selecteduni;
    ALPickerView *pickerView;
    NSMutableArray *arrProfessorsLocal;
    NSMutableArray *arrUniversityNames;
    NSMutableDictionary *dictProfessor;
}
@end

@implementation RatingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [arrProfessors removeAllObjects];
    [self loadprofessorlist];
//    if ([arrProfessors count]==0) {
//        [self loadprofessorlist];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromRightNavigationCnTlR:) name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClosesearchFromRightNavigationCnTlR:) name:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    arrProfessorsLocal=[[NSMutableArray alloc]initWithArray:arrProfessors];
    dictProfessor=[[NSMutableDictionary alloc]init];
    arrUniversityNames=[[NSMutableArray alloc]init];
    [self performSelector:@selector(syncuniversities)];
    
    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,460.0+iPhone5ExHeight+iOS7, 320.0,216.0)];
    [viewAddProffesor addSubview:pickerView];
    pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    pickerView.delegate=self;
    [pickerView reloadAllComponents];
    
    searchBar.tintColor=kCustomGRBLDarkColor;
    searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
    searchBar.alpha=1.0;
}
-(void)alertIfGuestMode
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Guest Mode" message:kGuestPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-Up", nil];
    alert.tag=24;
    [alert show];
}


#pragma mark - WS METHODS
-(void)showLoader
{
    [actIndicator startAnimating];
}
-(void)hideLoader
{
    [actIndicator stopAnimating];
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

-(void)loadprofessorlist
{
    //university_id
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strSubscribedUni,@"university_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRatingListURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(professorlistloaded:) withfailureHandler:@selector(loadprofessorlistfailed:) withCallBackObject:self];
    [self showLoader];
    [obj startRequest];
}
-(void)professorlistloaded:(id)sender
{
    [self hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrProfessors removeAllObjects];
//        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"total_ratings" ascending:NO];
//        NSMutableArray *arrSorted=[[NSMutableArray   alloc]initWithArray:[[dictResponse objectForKey:@"professor_info"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        
        NSMutableArray *arrSorted=[[NSMutableArray   alloc]initWithArray:[dictResponse objectForKey:@"professor_info"]];
        [arrProfessors addObjectsFromArray:arrSorted];
        [arrProfessorsLocal removeAllObjects];
        [arrProfessorsLocal addObjectsFromArray:arrProfessors];
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    NSLog(@"Hiii the error:%@",arrProfessors);
}
-(void)loadprofessorlistfailed:(id)sender
{
    [self hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
-(void)addprofessor
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[txtProfName.text removeNull],@"professor_name",[NSString stringWithFormat:@"%@",[[arrUniversityNames objectAtIndex:selecteduni] objectForKey:@"universityid"]],@"university_id",[txtEmail.text removeNull],@"professor_email",  nil];

    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRatingAddProffesorURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(addprofessordone:) withfailureHandler:@selector(addprofessorfailed:) withCallBackObject:self];
    [obj startRequest];
    
    txtProfName.text=@"";
    lblUniversity.text=@"";
    txtEmail.text=@"";
    selecteduni=-1;
    [pickerView reloadAllComponents];
}
-(void)addprofessordone:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [dictProfessor removeAllObjects];
        [dictProfessor addEntriesFromDictionary:dictResponse];
        
        [self performSelector:@selector(continueprofessor)];

        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)addprofessorfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


-(IBAction)btnScrollToTopClicked:(id)sender
{
    [searchBar resignFirstResponder];
    if([arrProfessors count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionTop
                               animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MyAppManager sharedManager] updatenotificationbadge];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateNotificationBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatenotificationbadge) name:kNotifyUpdateNotificationBadge object:nil];
    [self updatenotificationbadge];
    
    if (shouldInviteToSignUp)
    {
        [[MyAppManager sharedManager] signOutFromApp];
        shouldInviteToSignUp=YES;
        [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        return;
    }
    
    NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"total_ratings" ascending:NO];
    NSMutableArray *arrSorted=[[NSMutableArray   alloc]initWithArray:[arrProfessors sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
    [arrProfessors removeAllObjects];
    [arrProfessors addObjectsFromArray:arrSorted];
    [arrProfessorsLocal removeAllObjects];
    [arrProfessorsLocal addObjectsFromArray:arrProfessors];
    
    [self searchRatingsLocally];
    [tblView reloadData];
}
-(void)updatenotificationbadge
{
    NSString *strBadgeCount = [NSString stringWithFormat:@"%d",unread_notificationcount];
    [UIApplication sharedApplication].applicationIconBadgeNumber=unread_notificationcount;

    if ([strBadgeCount intValue] > 0)
    {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[CustomBadge class]])
            {
                [subview removeFromSuperview];
            }
        }
        
        CustomBadge *theBadge = [CustomBadge customBadgeWithString:strBadgeCount withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.80 withShining:YES];
        [theBadge setFrame:CGRectMake(318.0-theBadge.frame.size.width,btnChat.frame.origin.y-(theBadge.frame.size.height/2.0),theBadge.frame.size.width,theBadge.frame.size.height)];
        [self.view addSubview:theBadge];
    }
    else
    {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[CustomBadge class]])
            {
                [subview removeFromSuperview];
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)searchBar:(UISearchBar *)searchBars textDidChange:(NSString *)searchText
{
    [self searchRatingsLocally];
}
-(void)searchRatingsLocally
{
    [arrProfessorsLocal removeAllObjects];

    if ([[searchBar.text removeNull] length]==0)
    {
        [arrProfessorsLocal addObjectsFromArray:arrProfessors];
        [tblView reloadData];
        return;
    }


    for (int i=0; i<[arrProfessors count]; i++)
    {
        NSRange range =[[[NSString stringWithFormat:@"%@",[[arrProfessors objectAtIndex:i] objectForKey:@"professor_name"]]  stringByReplacingOccurrencesOfString:@"-" withString:@" "] rangeOfString:[[searchBar.text removeNull] stringByReplacingOccurrencesOfString:@"-" withString:@" "] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrProfessorsLocal addObject:[arrProfessors objectAtIndex:i]];
        }
    }
    
    
    [tblView reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBars
{
    searchBars.showsCancelButton=YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBars
{
    searchBar.showsCancelButton=NO;
    [searchBars resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}

#pragma mark - NAVBAR METHODS

-(void)searchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:320];
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL Finished){
        
    }];
}
-(void)ClosesearchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:250];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (IBAction)btnMenuOptionsClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)btnFriendsSectionClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    [searchBar resignFirstResponder];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(IBAction)btnAddProffessorClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    [searchBar resignFirstResponder];

    if(!IS_DEVICE_iPHONE_5)
    {
        CGRect theRect=viewAddProBox.frame;
        theRect.origin.y=53;
        viewAddProBox.frame=theRect;
    }
    
    [self.view addSubview:viewAddProffesor];
    [self.view bringSubviewToFront:viewAddProffesor];
    viewAddProffesor.alpha=0;
    viewAddProffesor.transform = CGAffineTransformScale(viewAddProffesor.transform ,1.5, 1.5);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    viewAddProffesor.alpha = 1;
    viewAddProffesor.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
}
-(IBAction)btnCancelProffessorClicked
{
    viewAddProffesor.transform = CGAffineTransformScale(viewAddProffesor.transform ,1.0, 1.0);
    viewAddProffesor.alpha=1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    viewAddProffesor.alpha = 0;
    viewAddProffesor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView commitAnimations];
    [self performSelector:@selector(RemoveNewProffessorView) withObject:nil afterDelay:0.5];
}
-(void)RemoveNewProffessorView
{
    [viewAddProffesor removeFromSuperview];
}
-(void)continueprofessor
{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Thank you!" message:@"Tap Continue to rate the\nprofessor now or Finish." delegate:self cancelButtonTitle:@"Finish" otherButtonTitles:@"Continue", nil];
    alert.tag=300;
    [alert show];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if ((theTouch.view==viewAddProffesor) || (theTouch.view==viewDisabler) ||(theTouch.view==viewAddProBox))
    {
        [self hidePicker];
    }
}

#pragma mark - PICKERVIEW
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
	return [arrUniversityNames count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
	return [[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
	return ((row==selecteduni)?YES:NO);
	//return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==300)
    {
        if (buttonIndex==1)
        {
            ProfessorAllRateViewController *obj=[[ProfessorAllRateViewController alloc]initWithNibName:@"ProfessorAllRateViewController" bundle:nil];
            obj.dictProfessor=[[NSMutableDictionary alloc]initWithDictionary:dictProfessor];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else
        {
            NSLog(@"no ....");
        }
    }
    else if (alertView.tag==24)
    {
        if (buttonIndex==1)
        {
            [[MyAppManager sharedManager] signOutFromApp];
            shouldInviteToSignUp=YES;
            [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)pickerView:(ALPickerView *)pickerViews didCheckRow:(NSInteger)row
{
    NSLog(@"the sel row:%d",row);
    selecteduni=row;
    lblUniversity.text=[[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
    [self hidePicker];
    
    //[self performSelector:@selector(openhomeview) withObject:nil afterDelay:0.5];
    /*
     // Check whether all rows are checked or only one
     if (row == -1)
     for (id key in [selectionStates allKeys])
     [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
     else
     [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
     */
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{
    
    NSLog(@"the selgg row:%d",row);
    
    /*
     // Check whether all rows are unchecked or only one
     if (row == -1)
     for (id key in [selectionStates allKeys])
     [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
     else
     [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
     */
}

-(IBAction)btnDoneProffesorClicked
{
    if ([[txtProfName.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter professor name.");
    }
    else if ([[lblUniversity.text removeNull]length]==0)
    {
        kGRAlert(@"Please select university.");
    }
    else if (([[txtEmail.text removeNull]length]!=0) && ![[txtEmail.text removeNull] isValidEmail])
    {
        kGRAlert(@"Please enter valid email-id.");
    }
    else
    {
        viewAddProffesor.transform = CGAffineTransformScale(viewAddProffesor.transform ,1.0, 1.0);
        viewAddProffesor.alpha=1;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        viewAddProffesor.alpha = 0;
        viewAddProffesor.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView commitAnimations];
        [self performSelector:@selector(RemoveNewProffessorView) withObject:nil afterDelay:0.5];
        [self addprofessor];
    }
}
-(IBAction)btnUniversityClicked:(id)sender
{
    if ([arrUniversityNames count]>0)
    {
        [viewAddProffesor endEditing:YES];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
        [UIView commitAnimations];
    }
    else
    {
        kGRAlert(kUniversityNotLoadedAlert)
    }
}
-(void)hidePicker
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProfessorsLocal count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RatingsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[RatingsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    cell.lblProffessorName.text=[[[arrProfessorsLocal objectAtIndex:indexPath.row] objectForKey:@"professor_name"] removeNull];
    cell.lblRatings.text=[NSString stringWithFormat:@"%d Ratings",[[[[arrProfessorsLocal objectAtIndex:indexPath.row] objectForKey:@"total_ratings"] removeNull] integerValue]];
    
    float avg_rat=[[[[arrProfessorsLocal objectAtIndex:indexPath.row] objectForKey:@"average_rating"] removeNull] floatValue];
    NSInteger theimageindex=0;
    if ((avg_rat>=1.0f) && (avg_rat<1.5f))
    {
        theimageindex=1;
    }
    else if ((avg_rat>=1.5f) && (avg_rat<2.5f))
    {
        theimageindex=2;
    }
    else if ((avg_rat>=2.5f) && (avg_rat<3.5f))
    {
        theimageindex=3;
    }
    else if ((avg_rat>=3.5f) && (avg_rat<4.5f))
    {
        theimageindex=4;
    }
    else if ((avg_rat>=4.5f) && (avg_rat<=5.0f))
    {
        theimageindex=5;
    }
    
    cell.imgRate.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%d.png",theimageindex]];    
    cell.imgMainBG.image=[UIImage imageNamed:[NSString stringWithFormat:@"bg_rating_%d.png",((indexPath.row%2==0)?0:1)]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    ProfessorAllRateViewController *obj=[[ProfessorAllRateViewController alloc]initWithNibName:@"ProfessorAllRateViewController" bundle:nil];
    obj.dictProfessor=[[NSMutableDictionary alloc]initWithDictionary:[arrProfessorsLocal objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:obj animated:YES];
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([arrProfessorsLocal count]>0)
    {
        NSMutableArray *charactersForSort = [[NSMutableArray alloc] init];
        for (NSDictionary *item in arrProfessorsLocal)
        {
            if (![charactersForSort containsObject:[[item valueForKey:@"professor_name"] substringToIndex:1]])
            {
                [charactersForSort addObject:[[item valueForKey:@"professor_name"] substringToIndex:1]];
            }
        }
        
        return charactersForSort;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    BOOL found = NO;
    NSInteger b = 0;
    for (NSDictionary *item in arrProfessorsLocal)
    {
        if ([[[item valueForKey:@"professor_name"] substringToIndex:1] isEqualToString:title])
            if (!found)
            {
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:b inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                found = YES;
            }
        b++;
    }
}
*/
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ((scrollView.contentOffset.y>=0) && (scrollView.contentOffset.y<(scrollView.contentSize.height-scrollView.frame.size.height)))
    {
        searchBar.alpha=((velocity.y<=0.0))?0.0:1.0;
        tblView.frame=CGRectMake(0.0, ((velocity.y<=0.0)?88.0:44.0)+iOS7,320.0,416.0+iPhone5ExHeight-((velocity.y<=0.0)?44.0:0.0));
        
        if (velocity.y<=0.0)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
            searchBar.alpha=1.0;
            [UIView commitAnimations];
        }
        else
        {
            searchBar.frame=CGRectMake(0.0,0.0+iOS7,320.0,44.0);
            searchBar.alpha=0.0;
        }
    }
    else if(scrollView.contentOffset.y<=0)
    {
        searchBar.alpha=0.0;
        tblView.frame=CGRectMake(0.0,88.0+iOS7,320.0,416.0+iPhone5ExHeight-44.0);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
        searchBar.alpha=1.0;
        [UIView commitAnimations];
    }
}


#pragma mark - DEFAULT
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
