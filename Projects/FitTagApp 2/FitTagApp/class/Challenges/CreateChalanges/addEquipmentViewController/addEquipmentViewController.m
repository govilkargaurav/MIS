//
//  addEquipmentViewController.m
//  FitTag
//
//  Created by Shivam on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "addEquipmentViewController.h"
#import "AddEquipmentCell.h"


@implementation addEquipmentViewController
@synthesize tblViewEquipmen;
@synthesize delegate;
@synthesize mutArrPreviouseAddedEquipment;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tblViewEquipmen.dataSource = self;
    self.tblViewEquipmen.delegate   = self;
    
    //done button
    //navigation back Button- Arrow
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
    //Done Button
    
    UIButton *btnBarDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBarDone addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnBarDone setFrame:CGRectMake(0, 0, 52, 30)];
    [btnBarDone setImage:[UIImage imageNamed:@"btnSmallDone"] forState:UIControlStateNormal];
    [btnBarDone setImage: [UIImage imageNamed:@"btnSmallDoneSel"] forState:UIControlStateHighlighted];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52, 30)];
    [view addSubview:btnBarDone];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-13;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    mutArrEquipmentList = [[NSMutableArray alloc]init];
    
    for (NSString *strEqup in self.mutArrPreviouseAddedEquipment){
        [mutArrEquipmentList addObject:strEqup];
    }
    
    //[mutArrEquipmentList addObject:@"Add Equipment"];
    [mutArrEquipmentList insertObject:@"Add Equipment" atIndex:0];
}

#pragma mark Done button pressed

-(void)doneButtonPressed:(id)sender{
    [mutArrEquipmentList removeObject:@"Add Equipment"];
    [self.delegate sendEquipmentListToParentView:mutArrEquipmentList];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidUnload{
    [self setTblViewEquipmen:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark- TableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;     
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mutArrEquipmentList count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
         
    static NSString *CellIdentifier = @"UserCell";
    AddEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddEquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([[mutArrEquipmentList objectAtIndex:indexPath.row] isEqualToString:@"Add Equipment"]){
    }else{
        cell.btnAddEquipment.enabled = NO;
        cell.btnAddEquipment.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.btnAddEquipment addTarget:self action:@selector(addMoreEquipmentForUser:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblEquipment.text = [mutArrEquipmentList objectAtIndex:indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

#pragma Mark- TableView Delegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// Delete the row on the swipe on cell

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[mutArrEquipmentList objectAtIndex:indexPath.row] isEqualToString:@"Add Equipment"]){
        return NO;
    }else{
        return YES;
    }   
    
    return YES;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) { 
            [delegate deleteEquipmentFromModelClass:[mutArrEquipmentList objectAtIndex:indexPath.row]];
            [mutArrEquipmentList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
    }    
}

#pragma mark add more Equipment

-(void)addMoreEquipmentForUser:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fittag" message:@"Add your equipment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    txtfldEquipment = [alert textFieldAtIndex:0];
    txtfldEquipment.delegate = self;
    
    [txtfldEquipment setFont:[UIFont systemFontOfSize:17]];
    [txtfldEquipment setBorderStyle:UITextBorderStyleRoundedRect];
    [txtfldEquipment setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtfldEquipment.placeholder = @"Add Equipment";
    [txtfldEquipment becomeFirstResponder];
   // [txtfldEquipment setBackgroundColor:[UIColor blackColor]];
    [alert addSubview:txtfldEquipment];

    [alert show];
}

#pragma mark UIAlertView Deleagte

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self addQeuipmentInTableView];
            break;
        case 1:
            break;
        default:
            break;
    }
}

-(void)addQeuipmentInTableView{
    if([[txtfldEquipment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length ]>0){
        [mutArrEquipmentList insertObject:txtfldEquipment.text atIndex:1];
        [tblViewEquipmen reloadData];
    }
}

#pragma Mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [txtfldEquipment resignFirstResponder];
    return YES;
        
}
-(IBAction)btnHeaderbackPressed:(id)sender{
    [mutArrEquipmentList removeObject:@"Add Equipment"];
    [self.delegate sendEquipmentListToParentView:mutArrEquipmentList];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
