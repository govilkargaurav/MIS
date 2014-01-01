//
//  AddTypeViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTypeViewCtr.h"

@implementation AddTypeViewCtr
@synthesize strSet;

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
        
    btnSave.enabled=NO;
    [tftype becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 0)
    {
        btnSave.enabled=YES;
    }
    else
    {
        btnSave.enabled=NO;
    }
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveiAdBannerView" object:nil];
}

#pragma mark - IBAction Methods
-(IBAction)btnSavePressed:(id)sender
{
    NSString *strQuery_Insert;
    if ([strSet isEqualToString:@"Password"])
    {
        strQuery_Insert = [NSString stringWithFormat:@"insert into tbl_typePass(typename) values('%@')",tftype.text];
    }
    else
    {
        strQuery_Insert = [NSString stringWithFormat:@"insert into tbl_typeContact(typename) values('%@')",tftype.text];
    }
    [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Insert];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
