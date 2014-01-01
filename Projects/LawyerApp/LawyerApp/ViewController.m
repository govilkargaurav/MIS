//
//  ViewController.m
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "SearchResultViewController.h"
#import "SearchListViewController.h"
#import "DejalActivityView.h"
#import "JSONParsingAsync.h"
#import "LoginViewController.h"

@interface ViewController (){
    
    UITextField *globalTextField;
    
}

@end

@implementation ViewController

@synthesize searchBar;
@synthesize imgViewLabel;
@synthesize dictLawyerInfo;
@synthesize ArrLawyerInfo;
@synthesize _tableView;
@synthesize _searchTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];
    searchBar.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *imgUserFakeUser = [[UIImageView alloc] initWithFrame:CGRectMake(4, 26, 36, 40)];
    [imgUserFakeUser setImage:[UIImage imageNamed:@"fakeuser.png"]];
    [imgViewLabel addSubview:imgUserFakeUser];
    _searchTextField.layer.borderWidth = 1.0f;
    [_searchTextField.layer setCornerRadius:14.0f];
    arraySearchText= [[NSMutableArray alloc] init];
    NSLog(@"%@",ArrLawyerInfo);
}


-(void)viewDidAppear:(BOOL)animated{
    
    APP_DELEGATE;
    INTERNET_NOT_AVAILABLE
        
//    [_queue addOperationWithBlock:^{
//        
//        id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=getlawyerslist",WEBSERVICE_HEADER]];
//        NSDictionary *jsonDictionary;
//        NSArray *jsonArray;
//        
//        if ([jsonObject isKindOfClass:[NSArray class]]) {
//            jsonArray = (NSArray *)jsonObject;
//        }else if([jsonObject isKindOfClass:[NSDictionary class]]){
//            jsonDictionary = (NSDictionary *)jsonObject;
//        }
//        
//        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            
//        ArrLawyerInfo = [[NSMutableArray alloc] init];
//        ArrLawyerInfo = [[jsonDictionary valueForKey:@"list"] mutableCopy];
//                    
//            [_tableView reloadData];
//            
//        }];
//        
//    }];
    
}
     

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarLocal{
    
    id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=user&func=searchlawyer&what=%@&where=%@",WEBSERVICE_HEADER,searchBarLocal.text,appdelegate.strCityName]];
    
    NSDictionary *jsonDictionary;
    NSArray *jsonArray;
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)jsonObject;
    }else if([jsonObject isKindOfClass:[NSDictionary class]]){
        jsonDictionary = (NSDictionary *)jsonObject;
    }
    if ([[jsonDictionary valueForKey:@"message"] isEqualToString:@"No Lawyers found"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Sorry ! No Records available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        
    }else{
        
        NSArray *arrGetAllData = nil ;
        SearchListViewController *searchResult= [[SearchListViewController alloc] initWithNibName:@"SearchListViewController" bundle:[NSBundle mainBundle]];
        searchResult.ArrJsonResponse = arrGetAllData = [jsonDictionary objectForKey:@"list"];
        [self.navigationController pushViewController:searchResult animated:YES];
        
    }
    
}



#pragma mark UIVIEWDelegate




-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
    globalTextField= textField;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==_searchTextField) {
        
        if ([arraySearchText count]>0) {
            [arraySearchText removeAllObjects];
        }
        NSInteger counter = 0;
        
        for(NSDictionary *s in ArrLawyerInfo) {
            
            if ([string isEqualToString:@""]) {
                
                NSString *strCC = [_searchTextField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
                
                if (strCC.length==0) {
                    
                    [arraySearchText addObject:s];
                    
                }else
                {
                    NSString *strS = [s valueForKey:@"vFirstName"];
                    NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                    if(r.location != NSNotFound && r.location==0) {
                        [arraySearchText addObject:s];
                    }
                    counter++;
                    
                }
            }else if ([string isEqualToString:@"\n"])
            {
                
            }else{
                NSString *strCC = [textField.text stringByAppendingString:string];
                NSString *strS = [s valueForKey:@"vFirstName"];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {
                    [arraySearchText addObject:s];
                }
                counter++;
                
            }
        }
        
   
    [_tableView reloadData];
    }

    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.searchBar.text= @"";
    [self.searchBar resignFirstResponder];
    [globalTextField resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [globalTextField resignFirstResponder];
    globalTextField=nil;
    return YES;
}

-(IBAction)loginScreen:(id)sender{
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:login animated:YES];
    
}

#pragma mark-
#pragma mark UITABLEVIEWCONTROLLER


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
        return 101;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (globalTextField==_searchTextField) {
        
        return [arraySearchText count];
    }else{
    
        return [ArrLawyerInfo count];
    }
    
    return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSMutableDictionary *d;
           
    if (globalTextField==_searchTextField) {
        
        if ([arraySearchText count]>0)
            d=[arraySearchText objectAtIndex:indexPath.row];
        else
            d=[ArrLawyerInfo objectAtIndex:indexPath.row];
        
    }else{
        
        if ([ArrLawyerInfo count]>0)
            d=[ArrLawyerInfo objectAtIndex:indexPath.row];
    }
        
        SearchListCell *cellSearch=[[SearchListCell alloc] initWithNibName:@"SearchListCell" bundle:nil dict:d];
            [cell.contentView addSubview:cellSearch.view];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultViewController *viewCtrL = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:[NSBundle mainBundle]];
    
     if (globalTextField==_searchTextField) {
         
         viewCtrL._strlawyerId = [[arraySearchText objectAtIndex:indexPath.row] valueForKey:@"iUserID"];
         
     }else{
         
         viewCtrL._strlawyerId = [[ArrLawyerInfo objectAtIndex:indexPath.row] valueForKey:@"iUserID"];
         
     }
    
    [self.navigationController pushViewController:viewCtrL animated:YES];
    
}

-(IBAction)dismiss:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
