//
//  ResourceFilesViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/2/12.
//
//

#import "ResourceFilesViewController.h"


@interface UITextView (extended)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface ResourceFilesViewController ()

@end

@implementation ResourceFilesViewController
@synthesize aryResourceFiles;

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
    NSLog(@"%@",aryResourceFiles);
    lbl_1.text = [aryResourceFiles valueForKey:@"UnitName"];
    [lbl_2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",[aryResourceFiles valueForKey:@"UnitCode"],[aryResourceFiles valueForKey:@"Version"],[aryResourceFiles valueForKey:@"Status"]]];
    aryResourceFiles =  [aryResourceFiles valueForKey:@"text"];
    NSLog(@"%@",aryResourceFiles);
    aryTextViewHeight = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int yAxis = 0;
    
    [tvWebContent resignFirstResponder];
    [tvWebContent setContentToHTMLString:[[aryResourceFiles objectAtIndex:indexPath.row] valueForKey:@"text"]];
    [tvWebContent setEditable:NO];
    [tvWebContent setTag:NO];
    tvWebContent.scrollEnabled = NO;
    tvWebContent.opaque = NO;
    [tvWebContent setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    tvWebContent.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0); //UIEdgeInsetsMake(-4,-8,0,0);
     
     
    CGRect frame = tvWebContent.frame;
    frame.size.height = tvWebContent.contentSize.height;
    tvWebContent.frame = frame;
    NSLog(@"%f",tvWebContent.frame.size.height);
    
    yAxis = yAxis + tvWebContent.frame.size.height + 5;
    
    for(int j=0;j<[[[aryResourceFiles objectAtIndex:indexPath.row] valueForKey:@"files"] count];j++)
    {
        yAxis = yAxis + 210;
    }
    [aryTextViewHeight insertObject:[NSString stringWithFormat:@"%f",tvWebContent.frame.size.height+5] atIndex:indexPath.row];
    return yAxis;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryResourceFiles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    
    UITableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    tablecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    int yAxis = 0;
    
    float fHeight = [[aryTextViewHeight objectAtIndex:indexPath.row] floatValue];
    UITextView *tvWeb = [[UITextView alloc]initWithFrame:CGRectMake(0,yAxis,768,fHeight)];
    [tvWeb setBackgroundColor:[UIColor clearColor]];
    [tvWeb setTextColor:[UIColor blackColor]];
    [tvWeb resignFirstResponder];
    [tvWeb setContentToHTMLString:[[aryResourceFiles objectAtIndex:indexPath.row] valueForKey:@"text"]];
    [tvWeb setEditable:NO];
    [tvWeb setTag:NO];
    tvWeb.scrollEnabled = NO;
    tvWeb.opaque = NO;
    [tvWeb setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    tvWeb.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    [tablecell addSubview:tvWeb];
    
    yAxis = yAxis + fHeight + 5;
    
    for(int j=0;j<[[[aryResourceFiles objectAtIndex:indexPath.row] valueForKey:@"files"] count];j++)
    {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(134, yAxis, 500, 200)];
        x=[[ImageViewURL alloc] init];
        x.imgV=iv;            
        x.strUrl=[NSURL URLWithString:[[[[aryResourceFiles objectAtIndex:indexPath.row] valueForKey:@"files"] objectAtIndex:j] valueForKey:@"text"]];
        [iv setContentMode:UIViewContentModeScaleToFill];
        [iv setBackgroundColor:[UIColor lightGrayColor]];
        [tablecell addSubview:iv];
        
        yAxis = yAxis + 210;
        
    }
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, yAxis)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:226/255.f green:228/255.f blue:230/255.f alpha:1].CGColor,(id)[UIColor colorWithRed:212/255.f green:213/255.f blue:215/255.f alpha:1].CGColor, nil];
    layer.frame = backgroundView.frame;
    [backgroundView.layer addSublayer:layer];
    tablecell.backgroundView=backgroundView;
    tablecell.selectionStyle=FALSE;
    return tablecell;
}

-(IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
