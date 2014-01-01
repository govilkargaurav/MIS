//
//  Help.m
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "Help.h"

@implementation Help

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Help";
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"easy AIS" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickBack:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
    
    NSString *path =  [[NSBundle	mainBundle] pathForResource:@"HelpData" ofType:@"plist"];
    NSDictionary *dicData = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *arr=[[NSArray alloc] initWithArray:[dicData valueForKey:@"key"]];
    
    font=[UIFont fontWithName:@"Helvetica" size:15];
    txtVAry=[[NSMutableArray alloc] init];
    for (int i=0; i<[arr count]; i++) {
        
        NSDictionary *dic = [arr objectAtIndex:i];
        
        if ([[dic valueForKey:@"type"] isEqualToString:@"text"]) {
            //text
            NSString *txt = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"content"]];
            [self addTextViewWithText:txt];
            
        }else{
            //image
            NSString *txt = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"content"]];
            [self addImageViewWithImage:[UIImage imageNamed:txt]];
            
        }
        
        
    }
}

-(void)ClickBack:(id)sender{
//	[self.navigationController popViewControllerAnimated:YES];
    
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    
    
}


-(void)addTextViewWithText:(NSString*)text{

    UITextView *txtV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    txtV.font=font;
    txtV.text=text;
    float y;
    y=scrollV.contentSize.height+20;

    txtV.editable=NO;
    txtV.scrollEnabled=NO;
    txtV.userInteractionEnabled=NO;
    
    CGSize size =[txtV.text sizeWithFont:txtV.font constrainedToSize:CGSizeMake(320, 99999)];
    txtV.frame=CGRectMake(0, y, size.width, size.height+20);
    [scrollV addSubview:txtV];
    scrollV.contentSize=CGSizeMake(320, scrollV.contentSize.height+20+txtV.frame.size.height);
    
    [txtVAry addObject:txtV];
}
-(void)addImageViewWithImage:(UIImage*)image{

    UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
    
    float y;
    y=scrollV.contentSize.height+20;
    
    imgV.frame=CGRectMake(0, y, image.size.width, image.size.height);
    [scrollV addSubview:imgV];
    scrollV.contentSize=CGSizeMake(320, scrollV.contentSize.height+20+imgV.frame.size.height);

    [txtVAry addObject:imgV];
    
}


/*
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView=nil;
    request=nil;
    
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
