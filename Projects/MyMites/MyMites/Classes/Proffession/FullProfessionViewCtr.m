//
//  FullProfessionViewCtr.m
//  MyMites
//
//  Created by apple on 11/20/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "FullProfessionViewCtr.h"
#import "AppConstat.h"
#import "BusyAgent.h"
#import "JSON.h"
#import "GlobalClass.h"
#import "Proffession.h"

@implementation FullProfessionViewCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DicResults = DValue;
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
    //Request For get data
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    DicResults =[[NSDictionary alloc]init];
    NSString *strLogin=[[NSString stringWithFormat:@"%@webservices/profession.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
    [super viewWillAppear:animated];
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
    DicResults = [responseString JSONValue];
    
    y= 5;
    
    lblProfession.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vOccupation"]]];
    lblBusinessName.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vBusiness"]]];
    lblBusinessCategory.text= [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vBusinessCategory"]]];
    lblDesc.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"bDescription"]]];
    lblExp.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vExperience"]]];
    lblWorkEmail.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vWorkEmail"]]];
    lblWebsite.text = [self stringVerification:[NSString stringWithFormat:@"%@",[DicResults valueForKey:@"vWebsite"]]];
    
    CGSize stringSize1 = [self text:lblProfession.text];
    lblProfession.frame = CGRectMake(115, y+2, 200, MAX(stringSize1.height, 21));
    lblProfessionHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblProfession.frame.size.height + 10;
    
    CGSize stringSize2 = [self text:lblBusinessName.text];
    lblBusinessName.frame = CGRectMake(115, y+2, 200, MAX(stringSize2.height, 21));
    lblBusinessNameHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblBusinessName.frame.size.height + 10;
    
    CGSize stringSize3 = [self text:lblBusinessCategory.text];
    lblBusinessCategory.frame = CGRectMake(115, y+2, 200, MAX(stringSize3.height, 21));
    lblBusinessCategoryHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblBusinessCategory.frame.size.height + 10;
    
    CGSize stringSize4 = [self text:lblDesc.text];
    lblDesc.frame = CGRectMake(115, y+2, 200, MAX(stringSize4.height, 21));
    lblDescHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblDesc.frame.size.height + 10;
    
    CGSize stringSize5 = [self text:lblExp.text];
    lblExp.frame = CGRectMake(115, y+2, 200, MAX(stringSize5.height, 21));
    lblExpHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblExp.frame.size.height + 10;
    
    
    CGSize stringSize7 = [self text:lblWorkEmail.text];
    lblWorkEmail.frame = CGRectMake(115, y+2, 200, MAX(stringSize7.height, 21));
    lblWorkEmailHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblWorkEmail.frame.size.height + 10;
    
    CGSize stringSize8 = [self text:lblWebsite.text];
    lblWebsite.frame = CGRectMake(115, y+2, 200, MAX(stringSize8.height, 21));
    lblWebsiteHeading.frame = CGRectMake(5, y, 105, 21);
    y = y + lblWebsite.frame.size.height + 10;
    
    btnEditProfession.frame = CGRectMake(100, y, 120, 30);
    
    scrlFullDetail.contentSize = CGSizeMake(320, y + 35 + 20);
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

-(CGSize)text:(NSString*)strTextContent
{
    CGSize constraintSize;
    constraintSize.width = 200.0f;
    constraintSize.height = MAXFLOAT;
    CGSize stringSize1 = [strTextContent sizeWithFont: [UIFont boldSystemFontOfSize: 14] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    return stringSize1;
}
#pragma - mark String Verification Method

-(NSString*)stringVerification:(NSString*)str
{
    str = [[self removeNull:str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0)
    {
        str = @"---";
    }
    return str;
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

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnEditPressed:(id)sender
{
    Proffession *obj_Proffession = [[Proffession alloc]initWithNibName:@"Proffession" bundle:nil Dic:DicResults];
    [self.navigationController pushViewController:obj_Proffession animated:YES];
    obj_Proffession = nil;
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
