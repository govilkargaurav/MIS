//
//  FindALawyerViewController.m
//  LawyerApp
//
//  Created by ChintaN on 7/26/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "FindALawyerViewController.h"
#import "LoginViewController.h"
#import "JSONParsingAsync.h"
#import "ViewController.h"
#import "GlobalClass.h"
#import "MBProgressHUD.h"

#pragma mark - KeyBoard Methods
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 200;
@interface FindALawyerViewController ()
{
    
    UITextField *globalTextField;
}


@end

@implementation FindALawyerViewController
CGFloat animatedDistance;
@synthesize _dictJsonArr;
@synthesize tblViewCity;
@synthesize tblViewState;
@synthesize tblViewLaw;

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
    // Do any additional setup after loading the view from its nib.
    [btnTypeOfPane addTarget:self action:@selector(paneSelector:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden=TRUE;
    // Do any additional setup after loading the view from its nib.
    for (int i = 0; i < 3; i++) {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        
        if (i==0) {
            View3.frame = frame;
            [scrollView addSubview:View3];
            
        }else if (i==1){
            View2.frame= frame;
            [scrollView addSubview:View2];
            
        }else if (i==2){
            View1.frame = frame;
            [scrollView addSubview:View1];
        }
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,scrollView.frame.size.height);
    
    dispatch_async(kBgQueue, ^{
        
            _dictJsonArr = [[NSMutableDictionary alloc] init];
            [self popularList:nil];
        
    });
}
-(void)paneSelector:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSNavigationPaneOpenDirectionTop" object:nil];
}

#pragma Mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControll.currentPage = page;
    
    // self.pageControl.currentPage=page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (pageControll.currentPage==0) {
        lblTblInfo.text=@"Browse Law Firms By Popular Area Of Law";
        [tblViewLaw reloadData];
    }else if(pageControll.currentPage==1){
        lblTblInfo.text=@"Browse Law Firms By Popular State";
        [tblViewState reloadData];
    }else if (pageControll.currentPage==2)
    { 
        lblTblInfo.text=@"Browse Law Firms By Popular City";
        [tblViewCity reloadData];
    }
    pageControlBeingUsed = NO;
    
}
#pragma Mark - Button Action Methods

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * pageControll.currentPage;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark UITABLEVIEW DELEGATE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblViewLaw) {
        return [[_dictJsonArr valueForKey:@"law_list"] count];
    }else if (tableView==tblViewState){
        
        return [[_dictJsonArr valueForKey:@"state_list"] count];
    }else if (tableView==tblViewCity){
        
        return [[_dictJsonArr valueForKey:@"city_list"] count];
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14.0];
    if (tableView==tblViewLaw) {
        cell.textLabel.text = [[[[_dictJsonArr valueForKey:@"law_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable];
       // cell.textLabel.text = [];
        
        
    }else if (tableView==tblViewState){
        
        cell.textLabel.text = [[[[_dictJsonArr valueForKey:@"state_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable];
        
    }else if (tableView==tblViewCity){
        
        cell.textLabel.text = [[[[_dictJsonArr valueForKey:@"city_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable];
        
    }
    
    cell.selectionStyle=FALSE;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APP_DELEGATE;
    INTERNET_NOT_AVAILABLE
    
    id jsonObject ;
     if (tableView==tblViewLaw) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=getbypopularlist&area_of_law=%@",WEBSERVICE_HEADER,[[[[_dictJsonArr valueForKey:@"law_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable]]];
         
     }else if (tableView == tblViewState){
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=getbypopularlist&state=%@",WEBSERVICE_HEADER,[[[[_dictJsonArr valueForKey:@"state_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable]]];
         
     }else if (tableView == tblViewLaw){
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=getbypopularlist&city=%@",WEBSERVICE_HEADER,[[[[_dictJsonArr valueForKey:@"city_list"] objectAtIndex:indexPath.row] RemoveNull] infoNotAvailable]]];
     }
    
    NSDictionary *jsonDictionary;
    NSArray *jsonArray;
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)jsonObject;
    }else if([jsonObject isKindOfClass:[NSDictionary class]]){
        jsonDictionary = (NSDictionary *)jsonObject;
    }
    
    if ([[jsonDictionary valueForKey:@"message"] isEqualToString:@"No Lawyers found"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Sorry ! No Records available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ViewController *resultViewCtrl=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            resultViewCtrl.ArrLawyerInfo = [jsonDictionary objectForKey:@"list"];
            resultViewCtrl.modalPresentationStyle=UIModalPresentationFullScreen;
            UINavigationController* navObj = [[UINavigationController alloc] initWithRootViewController:resultViewCtrl];
            navObj.navigationBarHidden = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:navObj animated:YES completion:nil];
        });
    }
    
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
   // [globalTextField resignFirstResponder];
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(kBgQueue, ^{
    
        [self searchViewController:nil];
    });
    
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    globalTextField = textField;
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

#pragma mark-
#pragma mark LoginViewController

-(IBAction)loginScreen:(id)sender{
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:login animated:YES];
    
}

#pragma mark SearchViewController

-(void)searchViewController:(id)sender{
    
    
    APP_DELEGATE;
    INTERNET_NOT_AVAILABLE

    id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=searchlawyer&what=%@&where=%@",WEBSERVICE_HEADER,txtFldLawFirm.text,txtFldStateCity.text]];
    
    NSDictionary *jsonDictionary;
    NSArray *jsonArray;
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)jsonObject;
    }else if([jsonObject isKindOfClass:[NSDictionary class]]){
        jsonDictionary = (NSDictionary *)jsonObject;
    }
        

    if ([[jsonDictionary valueForKey:@"message"] isEqualToString:@"No Lawyers found"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Sorry ! No Records available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
            
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
       
            ViewController *resultViewCtrl=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            resultViewCtrl.ArrLawyerInfo = [jsonDictionary objectForKey:@"list"];
            resultViewCtrl.modalPresentationStyle=UIModalPresentationFullScreen;
            UINavigationController* navObj = [[UINavigationController alloc] initWithRootViewController:resultViewCtrl];            
            navObj.navigationBarHidden = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:navObj animated:YES completion:nil];
        });        
    }
}



#pragma mark SearchViewController

-(void)browseLawyer:(id)sender{
    
    
    }




-(void)popularList:(id)sender{


        APP_DELEGATE;
        INTERNET_NOT_AVAILABLE
        
        id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=getpopularlist",WEBSERVICE_HEADER]];
        
        NSDictionary *jsonDictionary;
        NSArray *jsonArray;
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            jsonArray = (NSArray *)jsonObject;
        }else if([jsonObject isKindOfClass:[NSDictionary class]]){
            jsonDictionary = (NSDictionary *)jsonObject;
        }
        
        
        if (![[jsonDictionary valueForKey:@"message"] isEqualToString:@"Success"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Sorry ! No Records available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _dictJsonArr = [jsonDictionary mutableCopy];
                [tblViewLaw reloadData];
                
            });
            
        }
    
}



@end
