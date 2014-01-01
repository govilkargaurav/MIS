//
//  CommentViewController.m
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "CommentViewController.h"
#import "ProfileViewController.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "GlobalCustomCell.h"
#import "CommentCustomCell.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "ImageZoomViewController.h"
#import "HPGrowingTextView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyAppManager.h"
#import "WSManager.h"
#import "BlogFeed.h"
#import "NewsFeed.h"

@interface CommentViewController ()<HPGrowingTextViewDelegate,UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
	UIView *containerView;
    HPGrowingTextView *textView;
    IBOutlet UIImageView *imgNavBar;
    IBOutlet UILabel *lblNavTitle;
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewTBLHeader;
    IBOutlet UIView *viewTBLFooter;
    NSInteger selectedpost_id;
    BOOL isDeletedContentTypeComment;

    NSMutableArray *arrComments;
}
@end

@implementation CommentViewController
@synthesize selectedindex,commenttype;

- (void)viewDidLoad
{
    [super viewDidLoad];

    arrComments=[[NSMutableArray alloc]init];
    
    if (commenttype==CommentTypeBlog)
    {
        lblNavTitle.text=@"";
        [imgNavBar setImage:[UIImage imageNamed:@"bg_navbar.png"]];
        [arrComments addObjectsFromArray:[[arrHome objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
    }
    else if(commenttype==CommentTypeNews)
    {
        [arrComments addObjectsFromArray:[[arrNews objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
    }
    else if(commenttype==CommentTypeProfileNews)
    {
        [arrComments addObjectsFromArray:[[arrPosts objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
    }
    else if (commenttype == CommentTypeNotification)
    {
        
    }

    tblView.tableHeaderView=viewTBLHeader;
    tblView.tableFooterView=viewTBLHeader;
    [tblView reloadData];
    tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
    CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
    [tblView setContentOffset:offset animated:NO];
    
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidekeyboard:)];
    tapGest.numberOfTapsRequired=1;
    [tblView addGestureRecognizer:tapGest];
    
    [self OneButton];
    
    switch (commenttype)
    {
        case CommentTypeBlog:
        {
            [self loadblogcomments];
        }
            break;
            
        case CommentTypeNews:
        {
            [self loadnewscomments];
        }
            break;
            
        case CommentTypeProfileNews:
        {
            [self loadprofilenewscomments];
        }
            break;
        case CommentTypeNotification:
        {
            [self loadnotificationcomments];
        }
            break;
            
        default:
            break;
    }
    
    if (!isAppInGuestMode)
    {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0;
        lpgr.delegate = self;
        [tblView addGestureRecognizer:lpgr];
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
            [self dismissViewControllerAnimated:NO completion:^{}];
        }
    }
}

-(void)hidekeyboard:(UIGestureRecognizer *)gest
{
    [textView resignFirstResponder];
}
- (IBAction)btnDoneClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark - BLOG WS METHODS
-(void)loadblogcomments
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogAllCommentsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(blogcommentloaded:) withfailureHandler:@selector(blogcommnentloadfailed:) withCallBackObject:self];
    [obj startRequest];
}

-(void)blogcommentloaded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictBlog=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"blog_data"] objectAtIndex:0]];
        [arrHome replaceObjectAtIndex:selectedindex withObject:dictBlog];
        
        NSDictionary *dictBlogModel=(NSDictionary *)[arrHome objectAtIndex:selectedindex];
        BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:selectedindex];
        objBlog.strLikeCount=[[dictBlogModel objectForKey:@"like_count"] removeNull];
        objBlog.strCommentCount=[[dictBlogModel objectForKey:@"comment_count"] removeNull];
        objBlog.canLike=([[[dictBlogModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objBlog.isUpdated=([[[dictBlogModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrHomeModel replaceObjectAtIndex:selectedindex withObject:objBlog];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrHome objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
                
        [tblView reloadData];
        
        tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
        CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
        [tblView setContentOffset:offset animated:NO];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)blogcommnentloadfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)addblogcomment
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id",[textView.text removeNull],@"comment", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogAddCommentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(blogcommentadded:) withfailureHandler:@selector(blogcommnentaddfailed:) withCallBackObject:self];
    [obj startRequest];
    
    textView.text=@"";
}

-(void)blogcommentadded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
        
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictBlog=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"blog_data"] objectAtIndex:0]];
        [arrHome replaceObjectAtIndex:selectedindex withObject:dictBlog];
        
        NSDictionary *dictBlogModel=(NSDictionary *)[arrHome objectAtIndex:selectedindex];
        BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:selectedindex];
        objBlog.strLikeCount=[[dictBlogModel objectForKey:@"like_count"] removeNull];
        objBlog.strCommentCount=[[dictBlogModel objectForKey:@"comment_count"] removeNull];
        objBlog.canLike=([[[dictBlogModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objBlog.isUpdated=([[[dictBlogModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrHomeModel replaceObjectAtIndex:selectedindex withObject:objBlog];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrHome objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
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
-(void)blogcommnentaddfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - NEWS WS METHODS
-(void)loadnewscomments
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAllCommentsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(newscommentloaded:) withfailureHandler:@selector(newscommnentloadfailed:) withCallBackObject:self];
    [obj startRequest];
}

-(void)newscommentloaded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
        [arrNews replaceObjectAtIndex:selectedindex withObject:dictNews];
        
        NSDictionary *dictNewsModel=(NSDictionary *)[arrNews objectAtIndex:selectedindex];
        NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:selectedindex];
        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrNews objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
        [tblView reloadData];
        
        tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
        CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
        [tblView setContentOffset:offset animated:NO];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)newscommnentloadfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)addnewscomment
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id",[textView.text removeNull],@"comment", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAddCommentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(newscommentadded:) withfailureHandler:@selector(newscommnentaddfailed:) withCallBackObject:self];
    [obj startRequest];
    
    textView.text=@"";
}

-(void)newscommentadded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
        
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
        [arrNews replaceObjectAtIndex:selectedindex withObject:dictNews];
        
        NSDictionary *dictNewsModel=(NSDictionary *)[arrNews objectAtIndex:selectedindex];
        NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:selectedindex];
        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrNews objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
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
-(void)newscommnentaddfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


#pragma mark - PROFILE NEWS WS METHODS
-(void)loadprofilenewscomments
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAllCommentsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(profilenewscommentloaded:) withfailureHandler:@selector(profilenewscommnentloadfailed:) withCallBackObject:self];
    [obj startRequest];
}


-(void)profilenewscommentloaded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
        [arrPosts replaceObjectAtIndex:selectedindex withObject:dictNews];
        
        NSDictionary *dictNewsModel=(NSDictionary *)[arrPosts objectAtIndex:selectedindex];
        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrPosts objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
        [tblView reloadData];
        
        tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
        CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
        [tblView setContentOffset:offset animated:NO];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)profilenewscommnentloadfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)addprofilenewscomment
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id",[textView.text removeNull],@"comment", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAddCommentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(profilenewscommentadded:) withfailureHandler:@selector(profilenewscommnentaddfailed:) withCallBackObject:self];
    [obj startRequest];
    
    textView.text=@"";
}

-(void)profilenewscommentadded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
        [arrPosts replaceObjectAtIndex:selectedindex withObject:dictNews];
        
        NSDictionary *dictNewsModel=(NSDictionary *)[arrPosts objectAtIndex:selectedindex];
        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
        [[arrPosts objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
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
-(void)profilenewscommnentaddfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - Notification WS METHODS
-(void)loadnotificationcomments
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNotifications objectAtIndex:selectedindex] valueForKey:@"post_id"],@"news_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAllCommentsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(notificationcommentloaded:) withfailureHandler:@selector(notificationcommnentloadfailed:) withCallBackObject:self];
    [obj startRequest];
}

-(void)notificationcommentloaded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
//        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
//        [arrPosts replaceObjectAtIndex:selectedindex withObject:dictNews];
//        
//        NSDictionary *dictNewsModel=(NSDictionary *)[arrPosts objectAtIndex:selectedindex];
//        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
//        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
//        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
//        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
//        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
//        [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
//        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
//        [[arrPosts objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
        [tblView reloadData];
        
        tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
        CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
        [tblView setContentOffset:offset animated:NO];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)notificationcommnentloadfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)addnotificationcomment
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"post_id"],@"news_id",[textView.text removeNull],@"comment", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsAddCommentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(notificationcommentadded:) withfailureHandler:@selector(notificationcommnentaddfailed:) withCallBackObject:self];
    [obj startRequest];
    
    textView.text=@"";
}

-(void)notificationcommentadded:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
//        NSMutableDictionary *dictNews=[[NSMutableDictionary alloc]initWithDictionary:[[dictResponse objectForKey:@"news_data"] objectAtIndex:0]];
//        [arrPosts replaceObjectAtIndex:selectedindex withObject:dictNews];
//        
//        NSDictionary *dictNewsModel=(NSDictionary *)[arrPosts objectAtIndex:selectedindex];
//        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
//        objNews.strLikeCount=[[dictNewsModel objectForKey:@"like_count"] removeNull];
//        objNews.strCommentCount=[[dictNewsModel objectForKey:@"comment_count"] removeNull];
//        objNews.canLike=([[[dictNewsModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
//        objNews.isUpdated=([[[dictNewsModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
//        [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
//        
        NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"comments_list"]];
        [arrComments removeAllObjects];
        [arrComments addObjectsFromArray:arrCommentList];
//        [[arrPosts objectAtIndex:selectedindex] setObject:arrCommentList forKey:@"comments_list"];
        
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
-(void)notificationcommnentaddfailed:(id)sender
{
    [self performSelector:@selector(updatereadcount)];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma  mark - UPDATE READ COUNT
-(void)updatereadcount
{
    if (isAppInGuestMode)
    {
        return;
    }
    
    switch (commenttype)
    {
        case CommentTypeBlog:
        {
            BOOL shouldUpdate=([[[arrHome objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id", nil];
                [[arrHome objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
        }
            break;
            
        case CommentTypeNews:
        {
            BOOL shouldUpdate=([[[arrNews objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                [[arrNews objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
        }
            break;
            
        case CommentTypeProfileNews:
        {
            BOOL shouldUpdate=([[[arrPosts objectAtIndex:selectedindex] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                [[arrPosts objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
        }
            break;
            
        case CommentTypeNotification:
        {
            BOOL shouldUpdate=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"is_updated"] isEqualToString:@"1"])?NO:YES;
            
            if (shouldUpdate)
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"post_id"],@"news_id", nil];
                [[arrNotifications objectAtIndex:selectedindex] setObject:@"1" forKey:@"is_updated"];
                
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsReadCountURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - DELETE SECTION
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
            
            isDeletedContentTypeComment=(indexPath.row==0)?NO:YES;
            BOOL canDeletePost=NO;
            
            switch (commenttype)
            {
                case CommentTypeBlog:
                {
                    if(isDeletedContentTypeComment)
                    {
                        selectedpost_id=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"id"] removeNull] integerValue];
                        
                        if ([[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                    }
                }
                break;
                    
                case CommentTypeNews:
                {
                    NSDictionary *dictNewsSelected=(NSDictionary *)[arrNews objectAtIndex:selectedindex];
                    
                    if(isDeletedContentTypeComment)
                    {
                        NSLog(@"The data:%@",[arrComments objectAtIndex:(indexPath.row-1)]);
                        selectedpost_id=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"id"] removeNull] integerValue];
                        
                        if ([[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                    }
                    else
                    {
                        if ([[[dictNewsSelected objectForKey:@"professor_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                        
                        selectedpost_id=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"] removeNull] integerValue];
                    }
                }
                break;
                    
                case CommentTypeProfileNews:
                {
                    NSDictionary *dictNewsSelected=(NSDictionary *)[arrPosts objectAtIndex:selectedindex];
                    
                    if(isDeletedContentTypeComment)
                    {
                        NSLog(@"The data:%@",[arrComments objectAtIndex:(indexPath.row-1)]);
                        selectedpost_id=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"id"] removeNull] integerValue];
                        
                        if ([[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                    }
                    else
                    {
                        if ([[[dictNewsSelected objectForKey:@"professor_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                        
                        selectedpost_id=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"] removeNull] integerValue];
                    }
                }
                    break;
                    
                case CommentTypeNotification:
                {
                    if(isDeletedContentTypeComment)
                    {
                        NSLog(@"The data:%@",[arrComments objectAtIndex:(indexPath.row-1)]);
                        selectedpost_id=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"id"] removeNull] integerValue];
                        
                        if ([[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                    }
                    else
                    {
                        if ([[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"professor_id"] removeNull] isEqualToString:strUserId])
                        {
                            canDeletePost=YES;
                        }
                        
                        selectedpost_id=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"id"] removeNull] integerValue];
                    }
                    
                    if (indexPath.row==0) {
                        canDeletePost=NO;
                    }
                }
                    break;

                    
                default:
                    break;
            }

            if (canDeletePost)
            {
                if(selectedpost_id!=0)
                {
                    GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                    [self performSelector:@selector(setZoomInEffect:) withObject:cell];
                    [self performSelector:@selector(setZoomOutEffect:) withObject:cell afterDelay:0.55];
                    [self performSelector:@selector(promptfordelete) withObject:nil afterDelay:0.5];
                }
            }
        }
    }
}

-(void)promptfordelete
{
    [textView resignFirstResponder];

    UIActionSheet *actSheet=[[UIActionSheet alloc]initWithTitle:(isDeletedContentTypeComment)?@"Do you want to delete this comment?":@"Do you want to delete this news?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil,nil];
    actSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [actSheet showInView:self.view];
}

-(void)setZoomInEffect:(GlobalCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:(isDeletedContentTypeComment)?@"cellbg_comment-h":@"cellbg_header-h"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}
-(void)setZoomOutEffect:(GlobalCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:(isDeletedContentTypeComment)?@"cellbg_comment":@"cellbg_header"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSDictionary *dictPara;
        NSString *strTheURL;
        
        if (isDeletedContentTypeComment)
        {
            switch (commenttype)
            {
                case CommentTypeBlog:
                {
                    strTheURL=[[NSString alloc]initWithFormat:@"%@index.php?c=blog&func=removecomment",kBaseURL];
                    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedpost_id],@"comment_id",strUserId,@"user_id",nil];
                }
                    break;
                    
                case CommentTypeNews:
                {
                    strTheURL=[[NSString alloc]initWithFormat:@"%@index.php?c=news&func=removecomment",kBaseURL];
                    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedpost_id],@"comment_id",strUserId,@"user_id",nil];
                }
                    break;
                    
                case CommentTypeProfileNews:
                {
                    strTheURL=[[NSString alloc]initWithFormat:@"%@index.php?c=news&func=removecomment",kBaseURL];
                    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedpost_id],@"comment_id",strUserId,@"user_id",nil];
                }
                    break;
                    
                case CommentTypeNotification:
                {
                    strTheURL=[[NSString alloc]initWithFormat:@"%@index.php?c=news&func=removecomment",kBaseURL];
                    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedpost_id],@"comment_id",strUserId,@"user_id",nil];
                }
                    break;
                    
                default:
                {
                    return;
                }
                    break;
            }

        }
        else
        {
            strTheURL=[[NSString alloc]initWithFormat:@"%@index.php?c=news&func=removenews",kBaseURL];
            dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectedpost_id],@"news_id",nil];
        }
        
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[strTheURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(postdeleted:) withfailureHandler:@selector(postdeletefailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoaderWithtext:@"Deleting..." andDetailText:@"Please Wait..."];
        [obj startRequest];
        
    }
    else if (buttonIndex==1)
    {
        //Cancel: Do Nothing..
    }
}

-(void)postdeleted:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
//    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
//    {
        if (isDeletedContentTypeComment)
        {
            switch (commenttype)
            {
                case CommentTypeBlog:
                {
                    BOOL entryFound=NO;
                    NSInteger selectedblog_index=0;
                    for (int i=0; i<[arrComments count];i++)
                    {
                        if ([[[[arrComments objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectedpost_id)
                        {
                            entryFound=YES;
                            selectedblog_index=i;
                            break;
                        }
                    }
                    
                    if (entryFound)
                    {
                        [arrComments removeObjectAtIndex:selectedblog_index];
                        
                        NSMutableDictionary *dictBlogModel=(NSMutableDictionary *)[arrHome objectAtIndex:selectedindex];
                        BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:selectedindex];
                        NSInteger comment_count=MAX([[[dictBlogModel objectForKey:@"comment_count"] removeNull] integerValue]-1, 0);
                        objBlog.strCommentCount=[[NSString alloc]initWithFormat:@"%d",comment_count];
                        
                        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.lblCommentCount.text=[objBlog.strCommentCount removeNull];
                        
                        [arrHomeModel replaceObjectAtIndex:selectedindex withObject:objBlog];
                        [dictBlogModel setObject:arrComments forKey:@"comments_list"];
                        [dictBlogModel setObject:objBlog.strCommentCount forKey:@"comment_count"];
                        [arrHome replaceObjectAtIndex:selectedindex withObject:dictBlogModel];
                    }
                }
                    break;
                    
                case CommentTypeNews:
                {
                    BOOL entryFound=NO;
                    NSInteger selectednews_index=0;
                    for (int i=0; i<[arrComments count];i++)
                    {
                        if ([[[[arrComments objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectedpost_id)
                        {
                            entryFound=YES;
                            selectednews_index=i;
                            break;
                        }
                    }
                    
                    if (entryFound)
                    {
                        [arrComments removeObjectAtIndex:selectednews_index];
                        
                        NSMutableDictionary *dictNewsModel=(NSMutableDictionary *)[arrNews objectAtIndex:selectedindex];
                        NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:selectedindex];
                        NSInteger comment_count=MAX([[[dictNewsModel objectForKey:@"comment_count"] removeNull] integerValue]-1, 0);
                        objNews.strCommentCount=[[NSString alloc]initWithFormat:@"%d",comment_count];
                        
                        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.lblCommentCount.text=[objNews.strCommentCount removeNull];
                        
                        [arrNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
                        [dictNewsModel setObject:arrComments forKey:@"comments_list"];
                        [dictNewsModel setObject:objNews.strCommentCount forKey:@"comment_count"];
                        [arrNews replaceObjectAtIndex:selectedindex withObject:dictNewsModel];

                    }
                }
                    break;
                    
                case CommentTypeProfileNews:
                {
                    BOOL entryFound=NO;
                    NSInteger selectednews_index=0;
                    for (int i=0; i<[arrComments count];i++)
                    {
                        if ([[[[arrComments objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectedpost_id)
                        {
                            entryFound=YES;
                            selectednews_index=i;
                            break;
                        }
                    }
                    
                    if (entryFound)
                    {
                        [arrComments removeObjectAtIndex:selectednews_index];
                        
                        NSMutableDictionary *dictNewsModel=(NSMutableDictionary *)[arrPosts objectAtIndex:selectedindex];
                        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
                        NSInteger comment_count=MAX([[[dictNewsModel objectForKey:@"comment_count"] removeNull] integerValue]-1, 0);
                        objNews.strCommentCount=[[NSString alloc]initWithFormat:@"%d",comment_count];
                        
                        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.lblCommentCount.text=[objNews.strCommentCount removeNull];
                        
                        [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
                        [dictNewsModel setObject:arrComments forKey:@"comments_list"];
                        [dictNewsModel setObject:objNews.strCommentCount forKey:@"comment_count"];
                        [arrPosts replaceObjectAtIndex:selectedindex withObject:dictNewsModel];
                    }
                }
                    break;
                    
                case CommentTypeNotification:
                {
                    BOOL entryFound=NO;
                    NSInteger selectednews_index=0;
                    for (int i=0; i<[arrComments count];i++)
                    {
                        if ([[[[arrComments objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectedpost_id)
                        {
                            entryFound=YES;
                            selectednews_index=i;
                            break;
                        }
                    }
                    
                    if (entryFound)
                    {
                        [arrComments removeObjectAtIndex:selectednews_index];
                        
                        NSInteger comment_count=MAX([[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"comment_count"] removeNull] integerValue]-1, 0);
                        
                        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.lblCommentCount.text=[[NSString stringWithFormat:@"%d",comment_count] removeNull];
                        
                        [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",comment_count] forKey:@"comment_count"];
                    }
                }
                    break;
                    
                default:
                {
                    return;
                }
                    break;
            }
        }
        else
        {
            BOOL entryFound=NO;
            NSInteger selectednews_index=0;
            for (int i=0; i<[arrNews count];i++)
            {
                if ([[[[arrNews objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectedpost_id)
                {
                    entryFound=YES;
                    selectednews_index=i;
                    break;
                }
            }
            
            if (entryFound) {
                [arrNews removeObjectAtIndex:selectednews_index];
                [arrNewsModel removeObjectAtIndex:selectednews_index];
            }
            
            kGRAlert(@"News deleted successfully.");
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self dismissViewControllerAnimated:NO completion:^{}];
        }
        
        [tblView reloadData];
//    }
//    else
//    {
//        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
//        
//        if ([[strErrorMessage removeNull] length]>0) {
//            kGRAlert([strErrorMessage removeNull])
//        }
//    }
}
-(void)postdeletefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrComments count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_Header"];
        GlobalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[GlobalCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        
        cell.isCommentCell=YES;
        
        switch (commenttype) {
            case CommentTypeBlog:
            {
                cell.isNewsCell=NO;
                cell.lblTime.text=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"date_created"] removeNull] formattedTime];
                
                cell.lblattributed.delegate=self;
                
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrHome objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                [attrStrFull setTextColor:[UIColor darkGrayColor]];
                
                cell.lblattributed.attributedText=attrStrFull;
                
                cell.lblLikeCount.text=[[[arrHome objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
                cell.lblCommentCount.text=[[[arrHome objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull];
                BOOL shouldLike=([[[arrHome objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
                [cell.btnLike setTitle:(shouldLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
                
                if ([[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    
                    float imgwidth=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float imgheight=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    
                    cell.imgMain.tag=((imgwidth<=200.0) && (imgheight<=300.0))?0:2001;
                    float wd=MIN(imgwidth,300.0);
                    float ht=MIN(((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight, 200.0);
                    
                    CGRect theRect=cell.imgMain.frame;
                    theRect.size=CGSizeMake(wd, ht);
                    cell.imgMain.frame=theRect;
                    
                    [cell.imgMain setImageWithURL:[NSURL URLWithString:[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
                    cell.imgwidth=imgwidth;
                    cell.imgheight=imgheight;
                    cell.imgMain.alpha=1.0;
                    cell.btnMain.alpha=1.0;
                    cell.btnMain.tag=selectedindex;
                    [cell.btnMain addTarget:self action:@selector(btnImagePrivewClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.imgwidth=0.0;
                    cell.imgheight=0.0;
                    cell.imgMain.image=nil;
                    cell.imgMain.alpha=0.0;
                    cell.btnMain.alpha=0.0;
                }

                
                cell.btnLike.tag=selectedindex;
                cell.btnComment.tag=selectedindex;
                [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];

            }
                break;
                
            case CommentTypeNews:
            {
                cell.isNewsCell=([[[[arrNews objectAtIndex:selectedindex] objectForKey:@"is_postedbyadmin"] removeNull] isEqualToString:@"1"])?NO:YES;

                [cell.imgProfilePic setImageWithURL:([[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_id"] removeNull] integerValue]==[strUserId integerValue])?((isAppInGuestMode)?[NSURL URLWithString:[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]:[NSURL URLWithString:strUserProfilePic]):[NSURL URLWithString:[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"]];

                cell.imgProfilePic.tag=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_id"] removeNull] integerValue];
                
                [cell.imgProfilePic addTarget:self action:@selector(btnProfileViewClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.lblName.text=[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_name"] removeNull];
                cell.lblSubject.text=[[[arrNews objectAtIndex:selectedindex] objectForKey:@"professor_department"] removeNull];

                
                cell.lblTime.text=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"date_created"] removeNull] formattedTime];
                
                cell.lblattributed.delegate=self;
                
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrNews objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                [attrStrFull setTextColor:[UIColor darkGrayColor]];
                
                cell.lblattributed.attributedText=attrStrFull;
                
                cell.lblLikeCount.text=[[[arrNews objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
                cell.lblCommentCount.text=[[[arrNews objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull];
                BOOL shouldLike=([[[arrNews objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
                [cell.btnLike setTitle:(shouldLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
                
                if ([[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    
                    float imgwidth=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float imgheight=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    
                    cell.imgMain.tag=((imgwidth<=200.0) && (imgheight<=300.0))?0:2001;
                    float wd=MIN(imgwidth,300.0);
                    float ht=MIN(((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight, 200.0);
                    
                    CGRect theRect=cell.imgMain.frame;
                    theRect.size=CGSizeMake(wd, ht);
                    cell.imgMain.frame=theRect;
                    
                    [cell.imgMain setImageWithURL:[NSURL URLWithString:[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
                    cell.imgwidth=imgwidth;
                    cell.imgheight=imgheight;
                    cell.imgMain.alpha=1.0;
                    cell.btnMain.alpha=1.0;
                    cell.btnMain.tag=selectedindex;
                    [cell.btnMain addTarget:self action:@selector(btnImagePrivewClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.imgwidth=0.0;
                    cell.imgheight=0.0;
                    cell.imgMain.image=nil;
                    cell.imgMain.alpha=0.0;
                    cell.btnMain.alpha=0.0;
                }
                
                
                cell.btnLike.tag=selectedindex;
                cell.btnComment.tag=selectedindex;
                [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case CommentTypeProfileNews:
            {
                cell.isNewsCell=YES;
                
                [cell.imgProfilePic setImageWithURL:([[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"professor_id"] removeNull] integerValue]==[strUserId integerValue])?((isAppInGuestMode)?[NSURL URLWithString:[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]:[NSURL URLWithString:strUserProfilePic]):[NSURL URLWithString:[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"]];

                cell.imgProfilePic.userInteractionEnabled=NO;
                
                cell.lblName.text=[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"professor_name"] removeNull];
                cell.lblSubject.text=[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"professor_department"] removeNull];
                
                
                cell.lblTime.text=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"date_created"] removeNull] formattedTime];
                
                cell.lblattributed.delegate=self;
                
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                [attrStrFull setTextColor:[UIColor darkGrayColor]];
                
                cell.lblattributed.attributedText=attrStrFull;
                
                cell.lblLikeCount.text=[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"like_count"] removeNull];
                cell.lblCommentCount.text=[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull];
                BOOL shouldLike=([[[arrPosts objectAtIndex:selectedindex] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
                [cell.btnLike setTitle:(shouldLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
                
                if ([[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    
                    float imgwidth=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float imgheight=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    
                    cell.imgMain.tag=((imgwidth<=200.0) && (imgheight<=300.0))?0:2001;
                    float wd=MIN(imgwidth,300.0);
                    float ht=MIN(((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight, 200.0);
                    
                    CGRect theRect=cell.imgMain.frame;
                    theRect.size=CGSizeMake(wd, ht);
                    cell.imgMain.frame=theRect;
                    
                    [cell.imgMain setImageWithURL:[NSURL URLWithString:[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
                    cell.imgwidth=imgwidth;
                    cell.imgheight=imgheight;
                    cell.imgMain.alpha=1.0;
                    cell.btnMain.alpha=1.0;
                    cell.btnMain.tag=selectedindex;
                    [cell.btnMain addTarget:self action:@selector(btnImagePrivewClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.imgwidth=0.0;
                    cell.imgheight=0.0;
                    cell.imgMain.image=nil;
                    cell.imgMain.alpha=0.0;
                    cell.btnMain.alpha=0.0;
                }
                
                
                cell.btnLike.tag=selectedindex;
                cell.btnComment.tag=selectedindex;
                [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;

            case CommentTypeNotification:
            {
                cell.isNewsCell=YES;
                
                [cell.imgProfilePic setImageWithURL:([[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"professor_id"] removeNull] integerValue]==[strUserId integerValue])?((isAppInGuestMode)?[NSURL URLWithString:[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]:[NSURL URLWithString:strUserProfilePic]):[NSURL URLWithString:[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"]];
                
                
                cell.imgProfilePic.tag=[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"professor_id"] removeNull] integerValue];
                
                [cell.imgProfilePic addTarget:self action:@selector(btnProfileViewClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.lblName.text=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"professor_name"] removeNull];
                cell.lblSubject.text=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"professor_department"] removeNull];
                
                
                cell.lblTime.text=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"date_created"] removeNull] formattedTime];
                
                cell.lblattributed.delegate=self;
                
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                [attrStrFull setTextColor:[UIColor darkGrayColor]];
                
                cell.lblattributed.attributedText=attrStrFull;
                
                cell.lblLikeCount.text=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"like_count"] removeNull];
                cell.lblCommentCount.text=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"comment_count"] removeNull];
                BOOL shouldLike=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
                [cell.btnLike setTitle:(shouldLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
                
                if ([[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    
                    float imgwidth=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float imgheight=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    
                    cell.imgMain.tag=((imgwidth<=200.0) && (imgheight<=300.0))?0:2001;
                    float wd=MIN(imgwidth,300.0);
                    float ht=MIN(((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight, 200.0);
                    
                    CGRect theRect=cell.imgMain.frame;
                    theRect.size=CGSizeMake(wd, ht);
                    cell.imgMain.frame=theRect;
                    
                    [cell.imgMain setImageWithURL:[NSURL URLWithString:[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
                    cell.imgwidth=imgwidth;
                    cell.imgheight=imgheight;
                    cell.imgMain.alpha=1.0;
                    cell.btnMain.alpha=1.0;
                    cell.btnMain.tag=selectedindex;
                    [cell.btnMain addTarget:self action:@selector(btnImagePrivewClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.imgwidth=0.0;
                    cell.imgheight=0.0;
                    cell.imgMain.image=nil;
                    cell.imgMain.alpha=0.0;
                    cell.btnMain.alpha=0.0;
                }
                
                
                cell.btnLike.tag=selectedindex;
                cell.btnComment.tag=selectedindex;
                [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_Comment"];
        CommentCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[CommentCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        [cell.imgProfilePic setImageWithURL:([[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] integerValue]==[strUserId integerValue])?((isAppInGuestMode)?[NSURL URLWithString:[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"thumbnail"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]:[NSURL URLWithString:strUserProfilePic]):[NSURL URLWithString:[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"thumbnail"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"]];
        
        if ((commenttype==CommentTypeNews) || (commenttype==CommentTypeNotification) || (commenttype==CommentTypeBlog))
        {
            cell.imgProfilePic.tag=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"user_id"] removeNull] integerValue];
            
            [cell.imgProfilePic addTarget:self action:@selector(btnProfileViewClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.imgProfilePic.userInteractionEnabled=YES;
        }
        else
        {
            cell.imgProfilePic.userInteractionEnabled=NO;
        }
        
        cell.lblName.text=[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"name"] removeNull];
        cell.lblTime.text=[[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"date_created"] removeNull] formattedTime];
        cell.lblDescription.text=[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"comment"] removeNull];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        
        switch (commenttype)
        {
            case CommentTypeBlog:
            {
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrHome objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                float theHeight=[[attrStrFull heightforAttributedStringWithWidth:280.0]floatValue];
                float thecellheight=0;
                
                thecellheight+=30.0;
                thecellheight+=theHeight;
                thecellheight+=10.0;
                
                if ([[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    float i_wd=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float i_ht=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    float eximageheight=MIN(((i_wd>300.0) && ((i_ht*300.0/i_wd)<200.0))?(i_ht*300.0/i_wd):i_ht, 200.0);
                    thecellheight+=eximageheight;
                    NSLog(@"the %f",eximageheight);
                    if (eximageheight>=200.0)
                    {
                        thecellheight-=30.0;
                    }
                }
                
                thecellheight+=30.0;
                
                return thecellheight;
            }
                break;
                
            case CommentTypeNews:
            {
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrNews objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                float theHeight=[[attrStrFull heightforAttributedStringWithWidth:280.0]floatValue];
                float thecellheight=0;
                
                thecellheight+=([[[[arrNews objectAtIndex:selectedindex] objectForKey:@"is_postedbyadmin"] removeNull] isEqualToString:@"1"])?30.0:60.0;
                
                thecellheight+=theHeight;
                thecellheight+=10.0;
                
                if ([[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    float i_wd=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float i_ht=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    float eximageheight=MIN(((i_wd>300.0) && ((i_ht*300.0/i_wd)<200.0))?(i_ht*300.0/i_wd):i_ht, 200.0);
                    thecellheight+=eximageheight;
                    NSLog(@"the %f",eximageheight);
                    if (eximageheight>=200.0)
                    {
                        thecellheight-=30.0;
                    }
                }
                
                thecellheight+=30.0;
                return thecellheight;
            }
                break;
                
            case CommentTypeProfileNews:
            {
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                float theHeight=[[attrStrFull heightforAttributedStringWithWidth:280.0]floatValue];
                float thecellheight=0;
                
                thecellheight+=60.0;
                thecellheight+=theHeight;
                thecellheight+=10.0;
                
                if ([[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    float i_wd=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float i_ht=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    float eximageheight=MIN(((i_wd>300.0) && ((i_ht*300.0/i_wd)<200.0))?(i_ht*300.0/i_wd):i_ht, 200.0);
                    thecellheight+=eximageheight;
                    NSLog(@"the %f",eximageheight);
                    if (eximageheight>=200.0)
                    {
                        thecellheight-=30.0;
                    }
                }
                
                thecellheight+=30.0;
                return thecellheight;
            }
                break;
                
            case CommentTypeNotification:
            {
                NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"description"] removeNull]];
                [attrStrFull setFont:kFONT_HOMECELL];
                float theHeight=[[attrStrFull heightforAttributedStringWithWidth:280.0]floatValue];
                float thecellheight=0;
                
                thecellheight+=60.0;
                thecellheight+=theHeight;
                thecellheight+=10.0;
                
                if ([[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096"] removeNull] length]>0)
                {
                    float i_wd=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096_width"] removeNull] floatValue];
                    float i_ht=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image_640_1096_height"] removeNull] floatValue];
                    float eximageheight=MIN(((i_wd>300.0) && ((i_ht*300.0/i_wd)<200.0))?(i_ht*300.0/i_wd):i_ht, 200.0);
                    thecellheight+=eximageheight;
                    NSLog(@"the %f",eximageheight);
                    if (eximageheight>=200.0)
                    {
                        thecellheight-=30.0;
                    }
                }
                
                thecellheight+=30.0;
                return thecellheight;
            }
                break;

            default:
                break;
        }
        
    }
    else
    {
        CGSize textSize= [[[[arrComments objectAtIndex:(indexPath.row-1)] objectForKey:@"comment"] removeNull] sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0] constrainedToSize:CGSizeMake(230.0,CGFLOAT_MAX)lineBreakMode:NSLineBreakByWordWrapping];
        
        if (textSize.height>20.0)
        {
            return 28.0+textSize.height+12.0;
        }
        else
        {
            return 60.0;
        }
    }
    
    return 0.0;
}

-(void)btnImagePrivewClicked:(id)sender
{
    ImageZoomViewController *obj=[[ImageZoomViewController alloc]initWithNibName:@"ImageZoomViewController" bundle:nil];
    
    switch (commenttype) {
        case CommentTypeBlog:
        {
            obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrHome objectAtIndex:selectedindex] objectForKey:@"image"]] removeNull];
            obj.selectedindex=selectedindex;
            obj.phototype=PhotoTypeBlog;
        }
            break;
            
        case CommentTypeNews:
        {
            obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrNews objectAtIndex:selectedindex] objectForKey:@"image"]] removeNull];
            obj.selectedindex=selectedindex;
            obj.phototype=PhotoTypeNews;
        }
            break;
            
        case CommentTypeProfileNews:
        {
            obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"image"]] removeNull];
            obj.selectedindex=selectedindex;
            obj.phototype=PhotoTypeProfilePosts;
        }
            break;
            
        case CommentTypeNotification:
        {
            obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"image"]] removeNull];
            obj.selectedindex=selectedindex;
            obj.phototype=PhotoTypeNotification;
        }
            break;
            
        default:
            break;
    }
    
    [self presentViewController:obj animated:YES completion:^{}];
}

-(void)btnLikeClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
    }
    else
    {
        switch (commenttype) {
            case CommentTypeBlog:
            {
                BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:selectedindex];
                
                BOOL shouldLike=objBlog.canLike;
                NSInteger likecount=[objBlog.strLikeCount integerValue];
                
                GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
                cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                
                [[arrHome objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
                [[arrHome objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
                
                objBlog.canLike=!shouldLike;
                objBlog.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                [arrHomeModel replaceObjectAtIndex:selectedindex withObject:objBlog];
                
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:selectedindex] objectForKey:@"id"],@"blog_id", nil];
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kBlogLikeURL:kBlogDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
                break;
                
            case CommentTypeNews:
            {
                NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:selectedindex];
                
                BOOL shouldLike=objNews.canLike;
                NSInteger likecount=[objNews.strLikeCount integerValue];
                
                GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
                cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                [[arrNews objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
                [[arrNews objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
                
                objNews.canLike=!shouldLike;
                objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                [arrNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
                
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
                break;
                
            case CommentTypeProfileNews:
            {
                NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:selectedindex];
                
                BOOL shouldLike=objNews.canLike;
                NSInteger likecount=[objNews.strLikeCount integerValue];
                
                GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
                cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                
                [[arrPosts objectAtIndex:selectedindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
                [[arrPosts objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
                
                objNews.canLike=!shouldLike;
                objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                [arrUserNewsModel replaceObjectAtIndex:selectedindex withObject:objNews];
                
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:selectedindex] objectForKey:@"id"],@"news_id", nil];
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
                break;
                
            case CommentTypeNotification:
            {
                BOOL shouldLike=([[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"can_like"] isEqualToString:@"1"])?YES:NO;
                NSInteger likecount=[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"like_count"] integerValue];
                [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
                [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
                
                GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
                cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
                
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"id"],@"news_id", nil];
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj startRequest];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)btnCommentClicked:(id)sender
{
    if (isAppInGuestMode) {
        [self alertIfGuestMode];
        return;
    }
    
    [textView becomeFirstResponder];
}
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
	if ([[linkInfo.URL scheme] isEqualToString:@"homecr"])
    {
		NSString *theTAG = [linkInfo.URL resourceSpecifier];
        NSLog(@"Continue Reading Clicked With TAG:%@",theTAG);
		return NO;
	}
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",linkInfo.URL]]];
        return NO;
	}
}
-(void)btnProfileViewClicked:(id)sender
{
    if ([(UIButton *)sender tag] != [strUserId integerValue])
    {
        if ([(UIButton *)sender tag]==0) {
            return;
        }
        
        ProfileViewController *obj = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        obj.isProfileViewMine=NO;
        obj.isProfileViewFromComment=YES;
        obj.strTheUserId = [NSString stringWithFormat:@"%d",[(UIButton *)sender tag]];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj animated:NO completion:^{}];
    }
}

#pragma mark - TEXTVIEW METHODS
-(void)OneButton
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Add your comment...";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 60, 6, 51, 30);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(postcomment) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"btnSend.png"] forState:UIControlStateNormal];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    if (isAppInGuestMode) {
        UIButton *btnGuestMode = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGuestMode.frame = CGRectMake(0,0,320,40.0);
        [btnGuestMode addTarget:self action:@selector(alertIfGuestMode) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:btnGuestMode];
    }
}
-(void)TwoButton
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 3, 210, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Add Text";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(40, 0, 218, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 60,6, 51, 30);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(postcomment) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"btnSend.png"] forState:UIControlStateNormal];
	[containerView addSubview:doneBtn];
    
    //BtnPlus
	UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
	btnPlus.frame = CGRectMake(6,6, 32, 30);
    btnPlus.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[btnPlus setTitle:@"" forState:UIControlStateNormal];
    
    [btnPlus setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    btnPlus.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    btnPlus.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [btnPlus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnPlus addTarget:self action:@selector(btnPlusClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnPlus setBackgroundImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
	[containerView addSubview:btnPlus];
    
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
-(void)postcomment
{
    NSLog(@"Send Clicked");
	[textView resignFirstResponder];
    textView.text=[textView.text removeNull];
    
    if ([textView.text length]>0)
    {
        
        switch (commenttype) {
            case CommentTypeBlog:
            {
                NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[[arrHome objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
                
                NSMutableDictionary *dictUser=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]];
                NSString *strName=[NSString stringWithFormat:@"%@",[dictUser objectForKey:@"name"]];
                
                NSMutableDictionary *dictComment=[[NSMutableDictionary alloc]init];
                [dictComment setObject:strUserId forKey:@"user_id"];
                [dictComment setObject:@"0" forKey:@"id"];
                [dictComment setObject:[strName removeNull] forKey:@"name"];
                [dictComment setObject:[NSString stringWithFormat:@"%@",textView.text] forKey:@"comment"];
                [dictComment setObject:strUserProfilePic forKey:@"thumbnail"];
                [dictComment setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"date_created"];
                
                [arrCommentList addObject:dictComment];
                
                [arrComments removeAllObjects];
                [arrComments addObjectsFromArray:arrCommentList];
                
                [[arrHome objectAtIndex:selectedindex] setObject:arrComments forKey:@"comments_list"];
                
                NSInteger commentcount=[[[[arrHome objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull] integerValue];
                [[arrHome objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(commentcount+1)] forKey:@"comment_count"];
                
                [tblView reloadData];
                
                tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
                CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
                [tblView setContentOffset:offset animated:NO];
                
                [self addblogcomment];
            }
                break;
                
            case CommentTypeNews:
            {
                NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[[arrNews objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
                
                NSMutableDictionary *dictUser=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]];
                NSString *strName=[NSString stringWithFormat:@"%@",[dictUser objectForKey:@"name"]];
                
                NSMutableDictionary *dictComment=[[NSMutableDictionary alloc]init];
                [dictComment setObject:@"0" forKey:@"id"];
                [dictComment setObject:strUserId forKey:@"user_id"];
                [dictComment setObject:[strName removeNull] forKey:@"name"];
                [dictComment setObject:[NSString stringWithFormat:@"%@",textView.text] forKey:@"comment"];
                [dictComment setObject:strUserProfilePic forKey:@"thumbnail"];
                [dictComment setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"date_created"];
                
                [arrCommentList addObject:dictComment];
                
                [arrComments removeAllObjects];
                [arrComments addObjectsFromArray:arrCommentList];
                
                [[arrNews objectAtIndex:selectedindex] setObject:arrComments forKey:@"comments_list"];
                
                NSInteger commentcount=[[[[arrNews objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull] integerValue];
                [[arrNews objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(commentcount+1)] forKey:@"comment_count"];
                
                [tblView reloadData];
                
                tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
                CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
                [tblView setContentOffset:offset animated:NO];
                
                [self addnewscomment];
            }
                break;
                
            case CommentTypeProfileNews:
            {
                NSMutableArray *arrCommentList=[[NSMutableArray alloc]initWithArray:[[arrPosts objectAtIndex:selectedindex] objectForKey:@"comments_list"]];
                
                NSMutableDictionary *dictUser=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]];
                NSString *strName=[NSString stringWithFormat:@"%@",[dictUser objectForKey:@"name"]];
                
                NSMutableDictionary *dictComment=[[NSMutableDictionary alloc]init];
                [dictComment setObject:@"0" forKey:@"id"];
                [dictComment setObject:strUserId forKey:@"user_id"];
                [dictComment setObject:[strName removeNull] forKey:@"name"];
                [dictComment setObject:[NSString stringWithFormat:@"%@",textView.text] forKey:@"comment"];
                [dictComment setObject:strUserProfilePic forKey:@"thumbnail"];
                [dictComment setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"date_created"];
                
                [arrCommentList addObject:dictComment];
                
                [arrComments removeAllObjects];
                [arrComments addObjectsFromArray:arrCommentList];
                
                [[arrPosts objectAtIndex:selectedindex] setObject:arrComments forKey:@"comments_list"];
                
                NSInteger commentcount=[[[[arrPosts objectAtIndex:selectedindex] objectForKey:@"comment_count"] removeNull] integerValue];
                [[arrPosts objectAtIndex:selectedindex] setObject:[NSString stringWithFormat:@"%d",(commentcount+1)] forKey:@"comment_count"];
                
                [tblView reloadData];
                
                tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
                CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
                [tblView setContentOffset:offset animated:NO];
                
                [self addprofilenewscomment];
            }
                break;
                
            case CommentTypeNotification:
            {
                
                NSMutableDictionary *dictUser=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]];
                NSString *strName=[NSString stringWithFormat:@"%@",[dictUser objectForKey:@"name"]];
                
                NSMutableDictionary *dictComment=[[NSMutableDictionary alloc]init];
                [dictComment setObject:@"0" forKey:@"id"];
                [dictComment setObject:strUserId forKey:@"user_id"];
                [dictComment setObject:[strName removeNull] forKey:@"name"];
                [dictComment setObject:[NSString stringWithFormat:@"%@",textView.text] forKey:@"comment"];
                [dictComment setObject:strUserProfilePic forKey:@"thumbnail"];
                [dictComment setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"date_created"];
                
                [arrComments addObject:dictComment];
                
                
                NSInteger commentcount=[[[[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] objectForKey:@"comment_count"] removeNull] integerValue];
                [[[[[arrNotifications objectAtIndex:selectedindex] objectForKey:@"additional_dic"] objectForKey:@"news_data"] objectAtIndex:0] setObject:[NSString stringWithFormat:@"%d",(commentcount+1)] forKey:@"comment_count"];
                
                [tblView reloadData];
                
                tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
                CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
                [tblView setContentOffset:offset animated:NO];
                
                [self addnotificationcomment];
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)btnPlusClicked
{
    textView.text = @"";
    [textView resignFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
    
    //tblView.tableFooterView=viewTBLFooter;
    
    tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight-216.0);
    CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
    [tblView setContentOffset:offset animated:NO];

	// commit animations
	[UIView commitAnimations];
}
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
    //tblView.tableFooterView=viewTBLHeader;
    tblView.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
    CGPoint offset = CGPointMake(0.0,(tblView.contentSize.height>tblView.frame.size.height)?(tblView.contentSize.height-tblView.frame.size.height):0.0);
    [tblView setContentOffset:offset animated:NO];
	// commit animations
	[UIView commitAnimations];
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}


#pragma mark - DEFAULT
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (shouldInviteToSignUp)
    {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [tblView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
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
