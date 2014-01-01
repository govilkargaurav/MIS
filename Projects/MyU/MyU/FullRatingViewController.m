//
//  FullRatingViewController.m
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "FullRatingViewController.h"
#import "Constants.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "ProffesorRateCustomCell.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"

@interface FullRatingViewController () <UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewTBLHeader;
    IBOutlet UILabel *lblProfessorName;
    NSInteger selectedrate_id;
}
@end

@implementation FullRatingViewController
@synthesize dictProfessor,selectedratingindex,isNotificationRating;
@synthesize _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isNotificationRating)
    {
        lblProfessorName.text=[[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"professor_info"] objectForKey:@"name"]removeNull];
    }
    else
    {
        lblProfessorName.text=[[dictProfessor objectForKey:@"professor_name"] removeNull];
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0;
        lpgr.delegate = self;
        [tblView addGestureRecognizer:lpgr];
    }

    tblView.tableHeaderView=viewTBLHeader;
    tblView.tableFooterView=viewTBLHeader;
    
    [tblView reloadData];
}

-(IBAction)btnBackClicked:(id)sender
{
    if (isNotificationRating)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertIfGuestMode
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Guest Mode" message:kGuestPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-Up", nil];
    alert.tag=24;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==24)
    {
        if (buttonIndex==1)
        {
            shouldInviteToSignUp=YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - TABLEVIEW METHODS
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    ProffesorRateCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ProffesorRateCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.isCommentCell=YES;
    cell.lblattributed.delegate=self;
    
    NSDictionary *dictRatingTemp;
    
    if (isNotificationRating)
    {
        dictRatingTemp=[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"];
    }
    else
    {
        dictRatingTemp=[arrProfessorRatings objectAtIndex:selectedratingindex];
    }
    
    cell.lblSubject.text=[NSString stringWithFormat:@"%@ - %@",[dictRatingTemp objectForKey:@"course_name"],[dictRatingTemp objectForKey:@"year"]];
    cell.lblTime.text=[[[dictRatingTemp objectForKey:@"timestamp"] removeNull] formattedTime];
    
    NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[dictRatingTemp objectForKey:@"user_comment"] removeNull]];
    [attrStrFull setFont:kFONT_HOMECELL];
    [attrStrFull setTextColor:[UIColor darkGrayColor]];
    cell.lblattributed.attributedText=attrStrFull;
    
    cell.lblLikeCount.text=[[dictRatingTemp objectForKey:@"like_count"] removeNull];
    cell.imgRate1.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[dictRatingTemp objectForKey:@"easy_rating"] removeNull]]];
    cell.imgRate2.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[dictRatingTemp objectForKey:@"explain_rating"] removeNull]]];
    cell.imgRate3.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[dictRatingTemp objectForKey:@"interest_rating"] removeNull]]];
    cell.imgRate4.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[dictRatingTemp objectForKey:@"available_rating"] removeNull]]];
    
    [cell.btnLike setTitle:([[[dictRatingTemp objectForKey:@"canLike"] removeNull] integerValue])?@"  Like":@"Unlike" forState:UIControlStateNormal];
    
    cell.btnReport.enabled=([[[dictRatingTemp objectForKey:@"canReport"] removeNull] integerValue])?YES:NO;
    
    
    if (!cell.btnReport.enabled) {
        [cell.btnReport setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    cell.btnLike.tag=selectedratingindex;
    cell.btnReport.tag=selectedratingindex;
    [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReport addTarget:self action:@selector(btnReportClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictRatingTemp;
    
    if (isNotificationRating)
    {
        dictRatingTemp=[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"];
    }
    else
    {
        dictRatingTemp=[arrProfessorRatings objectAtIndex:selectedratingindex];
    }
    
    NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[dictRatingTemp objectForKey:@"user_comment"] removeNull]];
    [attrStrFull setFont:kFONT_HOMECELL];
    float theHeight=[[attrStrFull heightforAttributedStringWithWidth:280.0]floatValue];
    float thecellheight=0;
    
    thecellheight+=30.0;
    thecellheight+=theHeight;
    thecellheight+=105.0;
    thecellheight+=10.0;
    return thecellheight;
}

-(void)btnReportClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }

    NSInteger btnindex=[(UIButton *)sender tag];
    
    NSDictionary *dictRatingTemp;
    
    ProffesorRateCustomCell *cell=(ProffesorRateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (isNotificationRating)
    {
        [[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"] setObject:@"0" forKey:@"canReport"];
        dictRatingTemp=[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"];
    }
    else
    {
        [[arrProfessorRatings objectAtIndex:btnindex] setObject:@"0" forKey:@"canReport"];
        dictRatingTemp=[arrProfessorRatings objectAtIndex:btnindex];
    }
    
    cell.btnReport.enabled=NO;
    [cell.btnReport setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //&professor_id=415&rated_by=3
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictRatingTemp objectForKey:@"rating_id"],@"rating_id",[dictRatingTemp objectForKey:@"rated_by"],@"rated_by",[dictRatingTemp objectForKey:@"professor_id"],@"professor_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:kRatingReportURL] postPara:dictPara postData:nil withsucessHandler:@selector(reportsuccessfullydone:) withfailureHandler:@selector(reportfailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)reportsuccessfullydone:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)reportfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

/*
 professor_id: "415",
 easy_rating: "4",
 explain_rating: "3",
 interest_rating: "5",
 available_rating: "3",
 course_name: "toc",
 year: "2008",
 user_comment: "Comment goes here",
 rating_id: "5",
 timestamp: "1376464726",
 like_count: "0",
 canLike: "1",
 canReport: "1"
 */

-(void)btnLikeClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    NSInteger btnindex=[(UIButton *)sender tag];
    
    NSMutableDictionary *dictRatingTemp;
    if (isNotificationRating)
    {
        dictRatingTemp=[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"];
    }
    else
    {
        dictRatingTemp=[arrProfessorRatings objectAtIndex:selectedratingindex];
    }
    
    BOOL shouldLike=([[dictRatingTemp objectForKey:@"canLike"] isEqualToString:@"1"])?YES:NO;
    NSInteger likecount=[[dictRatingTemp objectForKey:@"like_count"] integerValue];
    
    ProffesorRateCustomCell *cell=(ProffesorRateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"Like" forState:UIControlStateNormal];
    cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
    
    if (isNotificationRating)
    {
        [[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"] setObject:(shouldLike)?@"0":@"1" forKey:@"canLike"];
        [[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
        dictRatingTemp=[[[arrNotifications objectAtIndex:selectedratingindex] objectForKey:@"additional_dic"] objectForKey:@"professor_ratings"];
    }
    else
    {
        [[arrProfessorRatings objectAtIndex:btnindex] setObject:(shouldLike)?@"0":@"1" forKey:@"canLike"];
        [[arrProfessorRatings objectAtIndex:btnindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
        dictRatingTemp=[arrProfessorRatings objectAtIndex:selectedratingindex];
    }
    
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictRatingTemp objectForKey:@"rating_id"],@"rating_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kRatingLikeURL:kRatingDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ratinglikedislikeddone:) withfailureHandler:@selector(ratinglikedislikefailed:) withCallBackObject:self];
    [obj startRequest];

}
-(void)ratinglikedislikeddone:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)ratinglikedislikefailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - Delete Rating
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:tblView];
        NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:p];
        if (indexPath != nil)
        {
            NSLog(@"long press on table view at row %d", indexPath.row);
            //if user can post news...
            
            NSDictionary *dictNewsSelected=(NSDictionary *)[arrProfessorRatings objectAtIndex:selectedratingindex];
            NSLog(@"%@",dictNewsSelected);
            if ([[[dictNewsSelected objectForKey:@"rated_by"] removeNull] isEqualToString:strUserId])
            {
                selectedrate_id=[[[dictNewsSelected objectForKey:@"rating_id"] removeNull] integerValue];
                [self performSelector:@selector(promptfordelete) withObject:nil afterDelay:0.5];
            }
        }
    }
}
-(void)promptfordelete
{
    UIActionSheet *actSheet=[[UIActionSheet alloc]initWithTitle:@"Do you want to delete this rating?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil,nil];
    actSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [actSheet showInView:self.view];
}
-(void)setZoomInEffect:(ProffesorRateCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:@"cellbg_header-h"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}
-(void)setZoomOutEffect:(ProffesorRateCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:@"cellbg_header"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self._delegate removeRateNOW_With_rating_id:selectedrate_id];
    }
    else if (buttonIndex==1)
    {
        //Cancel: Do Nothing..
    }
}



#pragma mark - DEFAULT
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
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
