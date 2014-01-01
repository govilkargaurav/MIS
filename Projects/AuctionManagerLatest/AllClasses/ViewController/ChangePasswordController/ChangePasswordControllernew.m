//
//  ChangePasswordControllernew.m
//  PropertyInspector
//
//  Created by apple on 11/8/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "ChangePasswordControllernew.h"
#import "CustomCell.h"
#import "LoginModel.h"
#import "ThreadManager.h"
#import "AlertManger.h"
#import "ChangePasswordModel.h"
#import "BusyAgent.h"
#import "GetTrusteesListModel.h"

@interface ChangePasswordControllernew ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITextField *globaltexctField;
    NSString *oldPassword;
    NSString *newPassword;
    NSString *retypePassword;
    
    
}

@end

@implementation ChangePasswordControllernew

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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE"
                                                                    style:UIBarButtonSystemItemDone
                                                                   target: self
                                                                   action: @selector(settingButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
        cell=nil;
        [cell removeFromSuperview];
        
    }
    
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChangePassword" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell *) currentObject;
				break;
			}
		}
	}
    
    
    if (indexPath.section == 0) {
        
        if(indexPath.row == 0)
        {
            cell.titleStatus.text=@"Old Password";
            cell.cellTextField.tag = 0;
                        
            
        }
        if (indexPath.row == 1) {
            
            [[cell titleStatus] setText:@"New Password:"];
            
            cell.cellTextField.tag = 1;
            
        }
        if (indexPath.row == 2) {
            
            [[cell titleStatus] setText:@"Re-type Password:"];
            
            cell.cellTextField.tag = 2;
            
        }
        
    }

    
    cell.selectionStyle=FALSE;
    return cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    globaltexctField=textField;
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    switch (textField.tag)
    {
        case 0:
            oldPassword = textField.text;
            break;
            
        case 1:
            newPassword = textField.text;
            break;
        
        case 2:
            retypePassword = textField.text;
            break;
    }
    return YES;
}


-(void)settingButtonClicked{
    
    
    [globaltexctField resignFirstResponder];
    
    if (oldPassword!=nil && newPassword!=nil && retypePassword!=nil) {
        
        
        [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
        
        if ([newPassword isEqualToString:retypePassword]) {
            
        
            
            NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&currPW=%@&newPW=%@",WEB_POST_CHANGE_PASSWORD,sessionID,oldPassword,newPassword]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
                        
            [[ThreadManager getInstance]makeRequest:POST_CHANGE_PASSWORD:soapMessage:[NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_POST_CHANGE_PASSWORD object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
            
        }else{
            
            [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Password not matched." cancelButtonTitle:@"OK"];
            
            [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
            
        }
        
    }else{
        
        
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Try again later." cancelButtonTitle:@"OK"];
        
        [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
        
    }
    
    
     
    
    
}


-(void)busyViewinSecondryThread:(id)sender{
    
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

-(void)getDeviceAunthnticityResponse{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_POST_CHANGE_PASSWORD object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        ////NSLog(@"%@",changepasswordStatus);
        
        if ([changepasswordStatus isEqualToString:@"true"]) {
            
             [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"Password has changed." cancelButtonTitle:@"INSTALL" okButtonTitle:nil parentController:self];
            
        }else{
            
             [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Try again later." cancelButtonTitle:@"OK"];
            
        }
        
    });

    
     [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
    
}


@end
