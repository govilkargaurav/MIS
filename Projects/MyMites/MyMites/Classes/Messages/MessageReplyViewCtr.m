//
//  MessageReplyViewCtr.m
//  MyMites
//
//  Created by apple on 2/14/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "MessageReplyViewCtr.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"

@interface MessageReplyViewCtr ()

@end

@implementation MessageReplyViewCtr
@synthesize strToMessageID,strFromMessageID;

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
    CALayer *l=[txtMessage layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor clearColor] CGColor];
    l.backgroundColor=[[UIColor whiteColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
    
    [txtMessage becomeFirstResponder];

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSendPressed:(id)sender
{
    NSString *strMessage = [txtMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strMessage length] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:@"You can not send blank message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"] isEqualToString:strFromMessageID])
        {
            strSendMsgID = strToMessageID;
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"] isEqualToString:strToMessageID])
        {
            strSendMsgID = strFromMessageID;
        }
        
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        responseData = [[NSMutableData alloc] init];
        ArryDicResult = [[NSMutableArray alloc] init];
        NSString *strpass = [[NSString stringWithFormat:@"%@webservices/reply.php?iFromID=%@&iToID=%@&tMessageText=%@&eType=inbox",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],strSendMsgID,strMessage]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
        ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
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
    
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArryDicResult valueForKey:@"message"]]];
    if ([strMsg isEqualToString:@"sent"])
    {
        txtMessage.text = @"";
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Message sent successfully!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
