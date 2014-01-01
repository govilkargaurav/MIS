//
//  TwitterFollowerList.m
//  LogInAndSignUpDemo
//
//  Created by Apple on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TwitterFollowerList.h"
#import "AppDelegate.h"
#import "AppUtilityClass.h"

@implementation TwitterFollowerList
@synthesize tblTwitter;
@synthesize footerActivityIndicator;
@synthesize activityIndicator;
@synthesize activityIndicatorView;

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
    
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.title=@"Followers";
    pagingIndexForTwitterFollowers = [[NSString alloc]init];
    arrMyFollowers = [[NSMutableArray alloc]init];
    isLoading=YES;
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
}

// Pop viewcontroller for back action
-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
        NSString *strRequestUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=%@&skip_status=true&include_user_entities=false",[PFTwitterUtils twitter].screenName];
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strRequestUrl]];
        [[PFTwitterUtils twitter] signRequest:postRequest];
        [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
         {
             if (!error) {
                 NSError *error1;
//                  = [[NSMutableDictionary alloc]init];
                 NSMutableDictionary *dictTwitterFollwersResponse = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:&error1];
                 NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dictTwitterFollwersResponse objectForKey:@"users"]];
                 if ([arr isKindOfClass:[NSArray class]])
                     for (int i = 0; i<[arr count] ; i++)
                     {
                         NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                         [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                         [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"screen_name"] forKey:@"screen_name"];
                         [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"NO"] forKey:@"isInvited"];
                         [arrMyFollowers addObject:dictTemp];
                         pagingIndexForTwitterFollowers = [dictTwitterFollwersResponse objectForKey:@"next_cursor"];
                         isLoading=NO;
                     }
                 [tblTwitter reloadData];
             }else{
             }
         }];
        
    }else{
        [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL isLinked,NSError *userLinkedError){
           // if(!userLinkedError){
                NSString *strRequestUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=%@&skip_status=true&include_user_entities=false",[PFTwitterUtils twitter].screenName];
                
                //[NSString stringWithFormat:@"http://api.twitter.com/1.1/statuses/followers.json?screen_name=%@&user_id=%@&count=%d&cursor=-1",[PFTwitterUtils twitter].screenName,[PFTwitterUtils twitter].userId,[arrMyFollowers count]+20]
                NSURLRequest *postRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strRequestUrl]];
                [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                 {
                     if (!error) {
                         NSError *error1;
                         
//                         NSMutableDictionary *dictTwitterFollwersResponse = [[NSMutableDictionary alloc]init];
                         
                         NSMutableDictionary *dictTwitterFollwersResponse = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:&error1];
                         
                         NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dictTwitterFollwersResponse objectForKey:@"users"]];
                         
                         if ([arr isKindOfClass:[NSArray class]])
                             for (int i = 0; i<[arr count] ; i++)
                             {
                                 NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                                 [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                                 [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"screen_name"] forKey:@"screen_name"];
                                 [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"NO"] forKey:@"isInvited"];
                                 
                                 [arrMyFollowers addObject:dictTemp];
                                 pagingIndexForTwitterFollowers = [dictTwitterFollwersResponse objectForKey:@"next_cursor"];
                                 isLoading=NO;
                             }
                         [tblTwitter reloadData];
                     }else{
                     }
                 }];
         //   }else{
            //    DisplayAlertWithTitle(@"FitTag", @"There is some problem occur. Please try again")
            //}
        }];
    }
}

-(void)viewDidUnload{
    [self setTblTwitter:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITabelViewDelegate
#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMyFollowers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton *btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    [btnInvite setFrame:CGRectMake(250.0,8.0,50.0,30.0)];
    [btnInvite setTag:indexPath.row];
    if([[[arrMyFollowers objectAtIndex:indexPath.row]objectForKey:@"isInvited"] isEqualToString:@"YES"]){
        [btnInvite setImage:[UIImage imageNamed:@"invited.png"] forState:UIControlStateNormal];
    }else{
        [btnInvite setImage:[UIImage imageNamed:@"Invite.png"] forState:UIControlStateNormal];
        [btnInvite addTarget:self action:@selector(onClick_TwitterInviteSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // [btnInvite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cell addSubview:btnInvite];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgView.image = [UIImage imageNamed:@"cellbg.png"];
    [cell.contentView addSubview:imgView];
    
    cell.textLabel.font = [UIFont fontWithName:@"DynoRegular" size:15];
    cell.textLabel.text = [[arrMyFollowers objectAtIndex:indexPath.row] valueForKey:@"screen_name"];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!isLoading){
        if (([scrollView contentOffset].y + scrollView.frame.size.height) >= [scrollView contentSize].height){
            isLoading = YES;
            
            [[NSBundle mainBundle] loadNibNamed:@"FooterLoadingViewTwitter" owner:self options:nil];
            self.footerActivityIndicator = self.activityIndicator;
            [tblTwitter setTableFooterView:[self activityIndicatorView]];;
            [self startAnimation];
            dispatch_async(kBgQueue,^{
                if([pagingIndexForTwitterFollowers intValue] == 0){
                    dispatch_async(dispatch_get_main_queue(),^{
                        [[self activityIndicatorView]setHidden:YES];
                        [[self footerActivityIndicator] stopAnimating];
                        DisplayAlertWithTitle(@"FitTag", @"No more followers to load")
                    });
                }else{
                    [self getTwitterFollowersOnScrolling];
                }
            });
        }
    }
}

-(void)getTwitterFollowersOnScrolling{
    
    NSString *strRequestUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json?cursor=%@&screen_name=%@&skip_status=true&include_user_entities=false",pagingIndexForTwitterFollowers,[PFTwitterUtils twitter].screenName];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strRequestUrl]];
    [[PFTwitterUtils twitter] signRequest:postRequest];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
     {
         if (!error){
             NSError *error1;
             
//             NSMutableDictionary *dictTwitterFollwersResponse = [[NSMutableDictionary alloc]init];
             
             NSMutableDictionary *dictTwitterFollwersResponse = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:&error1];
             
             NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dictTwitterFollwersResponse objectForKey:@"users"]];
             
             if ([arr isKindOfClass:[NSArray class]])
                 for (int i = 0; i<[arr count] ; i++)
                 {
                     NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                     [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                     [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"screen_name"] forKey:@"screen_name"];
                     [dictTemp setValue:[[arr objectAtIndex:i]valueForKey:@"NO"] forKey:@"isInvited"];
                     
                     [arrMyFollowers addObject:dictTemp];
                     pagingIndexForTwitterFollowers = [dictTwitterFollwersResponse objectForKey:@"next_cursor"];
                 }
             isLoading = NO;
             
             dispatch_async(dispatch_get_main_queue(),^{
                 [self stopAnimation];
                 [tblTwitter reloadData];
             });
         }
     }];
}

#pragma mark Paging methods

-(void)startAnimation{
    [[self activityIndicatorView] setHidden:NO];
    [[self footerActivityIndicator] startAnimating];
}

-(void)stopAnimation{
    [[self activityIndicatorView]setHidden:YES];
    [[self footerActivityIndicator] stopAnimating];
    isLoading = NO;
}

#pragma mark -
#pragma mark - UIButton Actions

-(IBAction)onClick_TwiterInviteAll:(id)sender {
    
}

-(IBAction)onClick_TwitterInviteSelected:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIButton *btnInv = (UIButton *)sender;
    
    NSString *user_id = [[arrMyFollowers objectAtIndex:btnInv.tag] valueForKey:@"id"];
    NSString *user_message = [NSString stringWithFormat:@"%@ just challenged you on FitTag App",[PFUser currentUser].username];
    
    NSString *postBody = [NSString stringWithFormat:@"&user_id=%@&text=%@",user_id,user_message];
    
    postBody = [postBody stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    postBody = [postBody stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json?"];
    NSMutableURLRequest *tweetRequest = [NSMutableURLRequest requestWithURL:url];
    tweetRequest.HTTPMethod = @"POST";
    tweetRequest.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [[PFTwitterUtils twitter] signRequest:tweetRequest];
    
    //[Utilities showActivityIndicator:YES];
    [NSURLConnection sendAsynchronousRequest:tweetRequest queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         
         if (!err) {
             
             NSMutableDictionary *dictResult = [AppUtilityClass DictionaryFromNSData:data];
             if ([dictResult isKindOfClass:[NSDictionary class]]) {
                 NSString *str_1 = [dictResult valueForKey:@"recipient_id"];
                 NSString *str_2 = [dictResult valueForKey:@"recipient_screen_name"];
                 if (str_1 && str_2 ) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     
                     [[arrMyFollowers objectAtIndex:btnInv.tag]removeObjectForKey:@"isInvited"];
                     [[arrMyFollowers objectAtIndex:btnInv.tag]setObject:@"YES" forKey:@"isInvited"];
                     [tblTwitter reloadData];
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"User Invited successfuly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }else if ([dictResult valueForKey:@"errors"]){
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     NSString *str_1 = [[[dictResult valueForKey:@"errors"] objectAtIndex:0]valueForKey:@"code"];
                     NSString *str_2 = [[[dictResult valueForKey:@"errors"] objectAtIndex:0]valueForKey:@"message"];
                     if (str_1 && str_2 ){
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"There is some problem occur please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                     }else{
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:[NSString stringWithFormat:@"Twitter Message posting Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }else{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:[NSString stringWithFormat:@"Twitter Message posting Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
         }
         else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Not able to sent invitation,please try later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [errorAlertView show];
             
         }
     }];
}


@end
