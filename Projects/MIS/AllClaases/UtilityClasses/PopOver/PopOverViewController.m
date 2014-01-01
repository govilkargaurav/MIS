//
//  PopOverViewController.m
//  MinutesInSeconds
//
//  Created by KPIteng on 10/7/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "PopOverViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "DAL.h"
#import <MessageUI/MessageUI.h>

@interface PopOverViewController ()

@end

@implementation PopOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lblTitel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    [btnCancel.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    [btnDone.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    lblTitel.text=self.popOverType;
}
-(IBAction)closePopUp:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Done"])
    {
        for (int i=0;  i< self.subMeentingList.count; i++)
        {
            UITableViewCell   *cell=[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                if ([self.popOverType isEqualToString:@"Send Mail"])
                {
                    self.SelectedSubMeeting=[self.subMeentingList objectAtIndex:i];
                }
                else
                {
                    //DELETE  Meeting
                    NSString *query = [NSString stringWithFormat:@"DELETE from tblSubMeetings where submeetingID= %@",[[self.subMeentingList objectAtIndex:i] valueForKey:SUBMEETING_ID]];
                    [[DAL getInstance] lookupAllForSQL:query];
                }
            }
        }
    }
    else
        self.popOverType=@"";
     [self.delegate cancelButtonClicked:self];
}
#pragma mark UITableViewControllerDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.subMeentingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, 0,270,40)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
    label.textColor=[UIColor blackColor];
    label.text=[[self.subMeentingList objectAtIndex:indexPath.row] valueForKey:MEETING_TITLE];
    [cell addSubview:label];
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
//    if ([self.popOverType isEqualToString:@"Send Mail"])
//    {
//        if (self.indexPath) {
//            UITableViewCell *Uncheckcell=[tableView cellForRowAtIndexPath:self.indexPath];
//             Uncheckcell.accessoryType=UITableViewCellAccessoryNone;
//        }
//        
//       cell.accessoryType=UITableViewCellAccessoryCheckmark;
//        self.indexPath=indexPath;
//    }
//    else
//    {
        if (cell.accessoryType ==UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
   //}
}
@end
