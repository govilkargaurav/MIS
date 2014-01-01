//
//  MessageThreadViewCtr.m
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "MessageThreadViewCtr.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"
#import "CCellMessage.h"
#import "MessageReplyViewCtr.h"

@implementation MessageThreadViewCtr
@synthesize striToId,striFromId;

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
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [tbl_MessagesThred removeFromSuperview];
    tbl_MessagesThred = [[UITableView alloc]initWithFrame:CGRectMake(10, 134, 300, 260) style:UITableViewStylePlain];
    tbl_MessagesThred.delegate = self;
    tbl_MessagesThred.dataSource = self;
    tbl_MessagesThred.backgroundColor = [UIColor clearColor];
    tbl_MessagesThred.separatorColor = [UIColor clearColor];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointstblbg1.png"]];
    tbl_MessagesThred.backgroundView = tempImageView;
    [self.view addSubview:tbl_MessagesThred];
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    ArryDicResult = [[NSMutableArray alloc] init];
    NSString *strpass = [[NSString stringWithFormat:@"%@webservices/inboxthred.php?iFromID=%@&iToID=%@",APP_URL,striFromId,striToId]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [super viewWillAppear:animated];
}

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    ArryDicResult = [responseString JSONValue];
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArryDicResult valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no data found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        [tbl_MessagesThred reloadData];
    }
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

#pragma mark- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryDicResult count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == Nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableDictionary *d = [ArryDicResult objectAtIndex:indexPath.row];

        CCellMessage *obj_CCellMessage=[[CCellMessage alloc] initWithNibName:@"CCellMessage" bundle:nil andD:d type:@"Thread" rowint:indexPath.row];
        [cell addSubview:obj_CCellMessage.view];
        obj_CCellMessage=nil;

        if (indexPath.row == 0)
        {
            UIButton *btnReply = [UIButton buttonWithType:UIButtonTypeCustom];
            btnReply.frame = CGRectMake(8, 78, 60, 25);
            [btnReply setBackgroundImage:[UIImage imageNamed:@"buttonAll.png"] forState:UIControlStateNormal];
            [btnReply setTitle:@"Reply" forState:UIControlStateNormal];
            [btnReply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnReply.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [btnReply addTarget:self action:@selector(btnReplyPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnReply];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *someText = [NSString stringWithFormat:@"%@",[[ArryDicResult objectAtIndex:indexPath.row] valueForKey:@"tMessageText"]];
	someText = [someText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGSize constraintSize;
    constraintSize.width = 224.0f;
    constraintSize.height = MAXFLOAT;
    CGSize stringSize =[someText sizeWithFont: [UIFont systemFontOfSize: 14] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    stringSize.height = stringSize.height + 35;
    if (stringSize.height < 80)
    {
        if (indexPath.row == 0)
            return 110;
        else
            return 80;
    }
    else
    {
        if (indexPath.row == 0)
        {
            if (stringSize.height + 3 < 111)
                return 110;
            else
                return stringSize.height + 3;
        }
        else
             return stringSize.height + 3;
    }
}
-(IBAction)btnReplyPressed:(id)sender
{
    MessageReplyViewCtr *obj_MessageReplyViewCtr = [[MessageReplyViewCtr alloc]initWithNibName:@"MessageReplyViewCtr" bundle:nil];
    obj_MessageReplyViewCtr.strToMessageID = striToId;
    obj_MessageReplyViewCtr.strFromMessageID = striFromId;
    [self.navigationController pushViewController:obj_MessageReplyViewCtr animated:YES];
    obj_MessageReplyViewCtr = nil;
}
#pragma mark - Remove NULL

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
