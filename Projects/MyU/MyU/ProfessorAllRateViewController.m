//
//  ProfessorAllRateViewController.m
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ProfessorAllRateViewController.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

#import "ProffesorRateCustomCell.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"

#import "FullRatingViewController.h"
#import "RateProfessorViewController.h"


@interface ProfessorAllRateViewController () <UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,fullRatingDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewTBLHeader;
    IBOutlet UIView *viewSectionHeader;
    IBOutlet UILabel *lblProfessorName;
    IBOutlet UIImageView *imgBeTheFirst;
    NSInteger selectedrate_id;
}

@end

@implementation ProfessorAllRateViewController
@synthesize dictProfessor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
    viewTBLHeader.alpha=0.0;
    tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
    
    lblProfessorName.text=[[dictProfessor objectForKey:@"professor_name"] removeNull];
    [arrProfessorRatings removeAllObjects];
    
    imgBeTheFirst.hidden=NO;
    
    if([[[dictProfessor objectForKey:@"total_ratings"] removeNull]integerValue]>0)
    {
        imgBeTheFirst.hidden=YES;
    }

    if (!isAppInGuestMode) {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0;
        lpgr.delegate = self;
        [tblView addGestureRecognizer:lpgr];
    }

    [self performSelector:@selector(getallratings)];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (shouldInviteToSignUp)
    {
        [[MyAppManager sharedManager] signOutFromApp];
        shouldInviteToSignUp=YES;
        [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        return;
    }
    
    if ([[[dictProfessorRatings objectForKey:@"canrate_time"] removeNull]integerValue]>0)
    {
        viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=1.0;
        tblView.frame=CGRectMake(0.0,84.0+iOS7,320.0,416.0+iPhone5ExHeight-40.0);
    }
    else
    {
        viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=0.0;
        tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
    }
    
    if (isAppInGuestMode) {
        viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=0.0;
        tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
    }

    [tblView reloadData];
}
-(void)getallratings
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictProfessor objectForKey:@"professor_id"],@"professor_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRatingViewAllURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ratingreceived:) withfailureHandler:@selector(ratingnotreceived:) withCallBackObject:self];
    [obj startRequest];
}
-(void)ratingreceived:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    @try {
        [dictProfessorRatings removeAllObjects];
        [dictProfessorRatings setObject:[dictResponse objectForKey:@"canrate_time"] forKey:@"canrate_time"];
    }
    @catch (NSException *exception) {
        NSLog(@"Got the exception:%@",exception);
    }

    if ([[[dictProfessorRatings objectForKey:@"canrate_time"] removeNull]integerValue]>0)
    {
        viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=1.0;
        tblView.frame=CGRectMake(0.0,84.0+iOS7,320.0,416.0+iPhone5ExHeight-40.0);
    }
    else
    {
        viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=0.0;
        tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
    }
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrProfessorRatings removeAllObjects];
        [arrProfessorRatings addObjectsFromArray:[dictResponse objectForKey:@"professor_ratings"]];
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    if([arrProfessorRatings count]>0)
    {
        imgBeTheFirst.hidden=YES;
    }

    [tblView reloadData];
}
-(void)ratingnotreceived:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnRateProffesorClicked:(id)sender
{
    RateProfessorViewController *obj=[[RateProfessorViewController alloc]initWithNibName:@"RateProfessorViewController" bundle:nil];
    obj.dictProfessor=[[NSMutableDictionary alloc]initWithDictionary:dictProfessor];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
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
            [[MyAppManager sharedManager] signOutFromApp];
            shouldInviteToSignUp=YES;
            [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        }
    }
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProfessorRatings count];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    ProffesorRateCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ProffesorRateCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    imgBeTheFirst.hidden=YES;
    
    cell.isCommentCell=NO;
    cell.lblSubject.text=[NSString stringWithFormat:@"%@ - %@",[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"course_name"],[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"year"]];
    cell.lblTime.text=[[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"timestamp"] removeNull] formattedTime];
    
    cell.lblattributed.delegate=self;
    

    NSMutableAttributedString *attrStrFull=[[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"user_comment"] removeNull] attributedStringForHomeCellForFrame:CGRectMake(0, 0, 280.0,48.0) andFont:kFONT_HOMECELL andTag:[NSString stringWithFormat:@"homecr:%d",indexPath.row]];
    [attrStrFull setFont:kFONT_HOMECELL];
    [attrStrFull setTextColor:[UIColor darkGrayColor]];
    cell.lblattributed.attributedText=attrStrFull;
    
    cell.lblLikeCount.text=[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"like_count"] removeNull];
    cell.imgRate1.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"easy_rating"] removeNull]]];
    cell.imgRate2.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"explain_rating"] removeNull]]];
    cell.imgRate3.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"interest_rating"] removeNull]]];
    cell.imgRate4.image=[UIImage imageNamed:[NSString stringWithFormat:@"rat%@.png",[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"available_rating"] removeNull]]];
    
    cell.btnLike.tag=indexPath.row;
    [cell.btnLike setTitle:([[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"canLike"] removeNull] integerValue])?@"  Like":@"Unlike" forState:UIControlStateNormal];
    
    cell.btnReport.tag=indexPath.row;
    cell.btnReport.enabled=([[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"canReport"] removeNull] integerValue])?YES:NO;
    if (!cell.btnReport.enabled) {
        [cell.btnReport setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReport addTarget:self action:@selector(btnReportClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableAttributedString *attrStrFull=[[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"user_comment"] removeNull] attributedStringForHomeCellForFrame:CGRectMake(0, 0, 280.0,48.0) andFont:kFONT_HOMECELL andTag:[NSString stringWithFormat:@"homecr:%d",indexPath.row]];
    [attrStrFull setFont:kFONT_HOMECELL];
    float theHeight=[[[[[[arrProfessorRatings objectAtIndex:indexPath.row] objectForKey:@"user_comment"] removeNull] attributedStringForHomeCellForFrame:CGRectMake(0, 0, 280.0,48.0) andFont:kFONT_HOMECELL andTag:[NSString stringWithFormat:@"homecr:%d",indexPath.row]] heightforAttributedStringWithWidth:280.0]floatValue];
    
    float thecellheight=0;
    thecellheight+=30.0;
    thecellheight+=MIN(theHeight,48.0);
    thecellheight+=105.0;
    thecellheight+=10.0;
    return thecellheight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return viewSectionHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullRatingViewController *obj=[[FullRatingViewController alloc]initWithNibName:@"FullRatingViewController" bundle:nil];
    obj.selectedratingindex=indexPath.row;
    obj.dictProfessor=dictProfessor;
    obj._delegate = self;
    [self.navigationController pushViewController:obj animated:YES];
}
-(void)btnReportClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    NSInteger btnindex=[(UIButton *)sender tag];
    
    ProffesorRateCustomCell *cell=(ProffesorRateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnindex inSection:0]];
    [[arrProfessorRatings objectAtIndex:btnindex] setObject:@"0" forKey:@"canReport"];
    cell.btnReport.enabled=NO;
    [cell.btnReport setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //&professor_id=415&rated_by=3
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"rating_id"],@"rating_id",[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"rated_by"],@"rated_by",[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"professor_id"],@"professor_id", nil];
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
    BOOL shouldLike=([[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"canLike"] isEqualToString:@"1"])?YES:NO;
    NSInteger likecount=[[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"like_count"] integerValue];
    
    ProffesorRateCustomCell *cell=(ProffesorRateCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnindex inSection:0]];
    [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"  Like" forState:UIControlStateNormal];
    cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];

    [[arrProfessorRatings objectAtIndex:btnindex] setObject:(shouldLike)?@"0":@"1" forKey:@"canLike"];
    [[arrProfessorRatings objectAtIndex:btnindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrProfessorRatings objectAtIndex:btnindex] objectForKey:@"rating_id"],@"rating_id", nil];
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

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
	if ([[linkInfo.URL scheme] isEqualToString:@"homecr"])
    {
		NSString *theTAG = [linkInfo.URL resourceSpecifier];
        NSLog(@"Continue Reading Clicked With TAG:%@",theTAG);
        
        FullRatingViewController *obj=[[FullRatingViewController alloc]initWithNibName:@"FullRatingViewController" bundle:nil];
        obj.selectedratingindex=[theTAG integerValue];
        obj.dictProfessor=dictProfessor;
        [self.navigationController pushViewController:obj animated:YES];
        
		return NO;
	}
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",linkInfo.URL]]];
        return NO;
	}
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([[[dictProfessorRatings objectForKey:@"canrate_time"] removeNull]integerValue]>0)
    {
        if ((scrollView.contentOffset.y>=0) && (scrollView.contentOffset.y<(scrollView.contentSize.height-scrollView.frame.size.height)))
        {
            viewTBLHeader.alpha=((velocity.y<=0.0))?0.0:1.0;
            tblView.frame=CGRectMake(0.0, ((velocity.y<=0.0)?84.0:44.0)+iOS7,320.0,416.0+iPhone5ExHeight-((velocity.y<=0.0)?40.0:0.0));
            
            if (velocity.y<=0.0)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:0.3];
                viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7,320.0,40.0);
                viewTBLHeader.alpha=1.0;
                [UIView commitAnimations];
            }
            else
            {
                viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7,320.0,40.0);
                viewTBLHeader.alpha=0.0;
            }
        }
        else if(scrollView.contentOffset.y<=0)
        {
            viewTBLHeader.alpha=0.0;
            tblView.frame=CGRectMake(0.0,84.0+iOS7,320.0,416.0+iPhone5ExHeight-40.0);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7,320.0,40.0);
            viewTBLHeader.alpha=1.0;
            [UIView commitAnimations];
        }
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
            NSDictionary *dictNewsSelected=(NSDictionary *)[arrProfessorRatings objectAtIndex:indexPath.row];
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
    NSLog(@"the selebtn :%d",buttonIndex);
    if (buttonIndex==0)
    {
        
        [self removeRateNOW_With_rating_id:selectedrate_id];
    }
    else if (buttonIndex==1)
    {
        //Cancel: Do Nothing..
    }
}
-(void)removeRateNOW_With_rating_id:(NSInteger)ratingid
{
    selectedrate_id = ratingid;
    //Delete
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedrate_id],@"rating_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kRatingRemoveURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ratedeleted:) withfailureHandler:@selector(ratedeletefailed:) withCallBackObject:self];
    [[MyAppManager sharedManager] showLoaderWithtext:@"Deleting Rating..." andDetailText:@"Please Wait..."];
    [obj startRequest];
}
-(void)ratedeleted:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        BOOL entryFound=NO;
        NSInteger selectednews_index=0;
        for (int i=0; i<[arrProfessorRatings count];i++)
        {
            if ([[[[arrProfessorRatings objectAtIndex:i]objectForKey:@"rating_id"] removeNull] integerValue]==selectedrate_id)
            {
                entryFound=YES;
                selectednews_index=i;
                break;
            }
        }
        if (entryFound)
        {
            for (int i=0; i<[arrProfessors count]; i++)
            {
                if ([[[[arrProfessors objectAtIndex:i]objectForKey:@"professor_id"] removeNull] isEqualToString:[[dictProfessor objectForKey:@"professor_id"] removeNull]])
                {
                    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]initWithDictionary:[arrProfessors objectAtIndex:i]];
                    NSInteger rating_count = [[dictTemp objectForKey:@"total_ratings"] integerValue];
                    rating_count = MAX(0, rating_count - 1) ;
                    [dictTemp setObject:[NSString stringWithFormat:@"%d",rating_count] forKey:@"total_ratings"];
                    [arrProfessors replaceObjectAtIndex:i withObject:dictTemp];
                    break;
                }
            }
            [arrProfessorRatings removeObjectAtIndex:selectednews_index];
        }
        
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)ratedeletefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    //[pull setState:PullToRefreshViewStateNormal];
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
