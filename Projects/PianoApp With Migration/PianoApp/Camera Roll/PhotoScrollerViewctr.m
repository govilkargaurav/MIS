//
//  PhotoScrollerViewctr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoScrollerViewctr.h"
#import "DatabaseAccess.h"
#import "DataExporter.h"
#import "UIImage+KTCategory.h"
#import "GlobalMethods.h"

@implementation PhotoScrollerViewctr
@synthesize indexclick;
@synthesize ArryImgsPass;

const CGFloat kScrollObjHeight	= 460.0;
const CGFloat kScrollObjHeight_iPhone5	= 548.0;
const CGFloat kScrollObjWidth	= 320.0;

// Keyboard Animation Declaration of values
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;


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
    appdel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [scl_Photo setBackgroundColor:[UIColor blackColor]];
	[scl_Photo setCanCancelContentTouches:NO];
    scl_Photo.delegate=self;
	scl_Photo.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	scl_Photo.clipsToBounds = YES;
	scl_Photo.scrollEnabled = YES;
	scl_Photo.pagingEnabled = YES;
    scl_Photo.userInteractionEnabled = YES;
        
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Singletap:)];
    doubleTap.numberOfTapsRequired = 1;
    doubleTap.delegate = self;
    [scl_Photo addGestureRecognizer:doubleTap];
    
    [GlobalMethods SetInsetToTextField:tfPassword];
    
    ArryImages = [[NSMutableArray alloc]initWithArray:ArryImgsPass];

    [self performSelector:@selector(ReloadAllView) withObject:nil afterDelay:0.00005];
    
    tbl_Tags.alpha = 0.0;
    btnTblTagRemove.hidden = YES;
    ArryTags = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)Singletap:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    if (!HideShow)
    {
        [self ShowHideTopBottom:0.0 SetboolValue:YES];
    }
    else
    {
        [self ShowHideTopBottom:1.0 SetboolValue:NO];
    }
    [UIView commitAnimations];

}
-(void)ShowHideTopBottom:(float)topbottom SetboolValue:(BOOL)value
{    
    ViewTop.alpha = topbottom;
    ViewBottom.alpha = topbottom;
    HideShow =value;
    lblBottomBorder.alpha = topbottom;
    lblTopBorder.alpha = topbottom;
}
-(void)ReloadAllView
{
    while ([scl_Photo.subviews count] > 0) {
        
        [[[scl_Photo subviews] objectAtIndex:0] removeFromSuperview];
    }
    
//    ArryImages=[[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_cameraroll:@"SELECT * FROM tbl_cameraroll"]];
    
    if ([ArryImages count]== 0)
    {
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    [scl_Photo setContentOffset:CGPointMake(indexclick * kScrollObjWidth, 0)];
	[scl_Photo setContentSize:CGSizeMake(([ArryImages count] * kScrollObjWidth), [scl_Photo bounds].size.height)];

    [self ReloadLeftRightImageView];
    [self CallCountImg];

}

-(void)ReloadLeftRightImageView
{
    while ([scl_Photo.subviews count] > 0) {
        
        [[[scl_Photo subviews] objectAtIndex:0] removeFromSuperview];
    }
    CGFloat curXLoc = indexclick * kScrollObjWidth;
    
    if (isiPhone5)
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(curXLoc, 0, kScrollObjWidth, kScrollObjHeight_iPhone5)];
    else
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(curXLoc, 0, kScrollObjWidth, kScrollObjHeight)];

        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = indexclick;
        imgView.userInteractionEnabled=YES;
        imgView.multipleTouchEnabled=YES;
    
        NSArray *ArryPathString = [[[ArryImages objectAtIndex:indexclick]  valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
        NSString *strImageName = [ArryPathString lastObject];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
    
        NSString *StrPathBig = [NSString stringWithFormat:@"%@Big",strAttachmentPath];
        UIImage *img = [appdel.DicCache objectForKey:StrPathBig];
        imgView.image = img;
    
    if (isiPhone5)
        _inerScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(curXLoc, 0, kScrollObjWidth, kScrollObjHeight_iPhone5)];
    else
        _inerScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(curXLoc, 0, kScrollObjWidth, kScrollObjHeight)];

        [_inerScrollView setContentSize:imgView.frame.size];
        _inerScrollView.delegate = self;
        _inerScrollView.minimumZoomScale = 1.0;
        _inerScrollView.maximumZoomScale = 10.0;
        [_inerScrollView addSubview:imgView];
        [scl_Photo addSubview:_inerScrollView];
        
        
        if ([[[ArryImages objectAtIndex:indexclick]  valueForKey:@"type"] isEqualToString:@"Video"])
        {
            _inerScrollView.userInteractionEnabled = NO;
            UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPlay setImage:[UIImage imageNamed:@"Playbutton2.png"] forState:UIControlStateNormal];
            [btnPlay addTarget:self action:@selector(btnPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
            btnPlay.userInteractionEnabled=YES;
            btnPlay.frame = CGRectMake(curXLoc + 130, 200, 60, 60);
            btnPlay.tag = indexclick;
            [scl_Photo addSubview:btnPlay];
        }
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(_inerScrollView.bounds),
                                      CGRectGetMidY(_inerScrollView.bounds));
    [self view:imgView setCenter:centerPoint];
    
}
-(IBAction)btnPlayPressed:(id)sender
{
    NSArray *ArryPathString = [[[ArryImages objectAtIndex:[sender tag]] valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
    NSString *strImageName = [ArryPathString lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
    moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:strAttachmentPath];
    
    [moviePlayer readyPlayer];
	// Show the movie player as modal
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 	[self presentModalViewController:moviePlayer animated:YES];
    moviePlayer=nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)CallCountImg
{
    lblTitle.text=[NSString stringWithFormat:@"%d of %d",indexclick + 1,[ArryImages count]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexaddminus = scl_Photo.contentOffset.x /  kScrollObjWidth;
    if (indexclick != indexaddminus)
    {        
        indexclick = indexaddminus ;
        if (indexclick < [ArryImages count])
        {
            [self ReloadLeftRightImageView];
        }
        [self CallCountImg];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
-(IBAction)btnCancelPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)btnDeletePressed:(id)sender
{
    [btnTblTagRemove sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    sheet.tag = 2;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
-(IBAction)btnExportPressed:(id)sender
{
    [btnTblTagRemove sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"] && ![[[ArryImages objectAtIndex:indexclick]  valueForKey:@"type"] isEqualToString:@"Video"])
    {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Encrypt and Send",@"Compose Email",@"Export back to camera roll",@"Cancel", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        sheet.destructiveButtonIndex = 3;
        sheet.tag = 3;
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Compose Email",@"Export back to camera roll",@"Cancel", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        sheet.destructiveButtonIndex = 2;
        sheet.tag = 1;
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0 || buttonIndex == 1)
        {
            [self ComposeMail:buttonIndex];
        }
        else if (buttonIndex == 2)
        {
            return;
        }
    }
    else if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
           
            NSArray *ArryPathString = [[[ArryImages objectAtIndex:indexclick] valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
            NSString *strImageName = [ArryPathString lastObject];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
            NSString *StrThumbnailPath = [NSString stringWithFormat:@"%@",strAttachmentPath];
            NSString *StrPath = [NSString stringWithFormat:@"%@Big",strAttachmentPath];
            [appdel.DicCache removeObjectForKey:StrThumbnailPath];
            [appdel.DicCache removeObjectForKey:StrPath];

            appdel.strCallYesOrNo = @"Yes";
            
            [[NSFileManager defaultManager] removeItemAtPath:strAttachmentPath error:nil];
            NSString *str_Delete_CameraRoll = [NSString stringWithFormat:@"DELETE FROM tbl_cameraroll where id=%d",[[[ArryImages objectAtIndex:indexclick]  valueForKey:@"id"]intValue]];
            [DatabaseAccess InsertUpdateDeleteQuery:str_Delete_CameraRoll];
            
            [ArryImages removeObjectAtIndex:indexclick];
            
            if (indexclick == 0)
            {
                indexclick = 0;
            }
            else
            {
                indexclick--;
            }
            
            [self ReloadAllView];
        }
        else if (buttonIndex == 1)
        {
            return;
        }
    }
    else if (actionSheet.tag == 3)
    {
        if (buttonIndex == 0)
        {
            [self OpenActionSheetOrPasswordView];
        }
        else if (buttonIndex == 1 || buttonIndex == 2)
        {
            [self ComposeMail:buttonIndex];
        }
        else if (buttonIndex == 3)
        {
            return;
        }
    }
    
}
#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *strMailSentMsg;
	switch (result)
	{
		case MFMailComposeResultCancelled:
            strMailSentMsg = @"Mail cancelled: you cancelled the operation and no email message was queued";
			break;
		case MFMailComposeResultSaved:
            strMailSentMsg = @"Mail saved: you saved the email message in the Drafts folder";
			break;
		case MFMailComposeResultSent:
            strMailSentMsg = @"Mail send";
			break;
		case MFMailComposeResultFailed:
            strMailSentMsg = @"Mail failed: the email message was nog saved or queued, possibly due to an error";
			break;
		default:
            strMailSentMsg = @"Mail not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMailSentMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
	[self dismissModalViewControllerAnimated:YES];
}
-(void)ComposeMail:(int)indexClick
{
    NSArray *ArryPathString = [[[ArryImages objectAtIndex:indexclick] valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
    NSString *strImageName = [ArryPathString lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
    NSString *url=[NSString stringWithFormat:@"%@",strAttachmentPath];
    if(indexClick == 0)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            
            NSData *cameraData = [[NSData alloc] initWithContentsOfFile:url];
            if ([[[ArryImages objectAtIndex:indexclick]  valueForKey:@"type"] isEqualToString:@"Image"])
            {
                [mailer addAttachmentData:cameraData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"Photo.png"]];
            }
            else
            {
                [mailer addAttachmentData:cameraData mimeType:@"video/mov" fileName:[NSString stringWithFormat:@"Video.mov"]];
            }
            [self presentModalViewController:mailer animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Your device doesn't support the composer sheet or add E-mail account from setting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else if (indexClick == 1)
    {
        NSString *strMsgAlert;
        if ([[[ArryImages objectAtIndex:indexclick]  valueForKey:@"type"] isEqualToString:@"Image"])
        {
            NSData *cameraData = [[NSData alloc] initWithContentsOfFile:url];
            UIImage *imageSave = [[UIImage alloc] initWithData:cameraData];
            UIImageWriteToSavedPhotosAlbum(imageSave, self, nil, nil);
            strMsgAlert = @"Image export successfully";
        }
        else
        {
            UISaveVideoAtPathToSavedPhotosAlbum(url, self,nil, nil);
            strMsgAlert = @"Video export successfully";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:strMsgAlert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)SendMailWithEncryption
{    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        NSMutableDictionary *dictshare=[[NSMutableDictionary alloc]init];
        
        [dictshare setObject:@"" forKey:@"descPianopass"];
        
        UIImage *imgReaizable = [imgView.image imageReduceSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*2,[UIScreen mainScreen].bounds.size.height*2)];
        [dictshare setObject:imgReaizable forKey:@"imgPianopass"];
        
        if (isPasswordInclude)
            [dictshare setObject:tfPassword.text forKey:@"pwdPianopass"];
        else
            [dictshare setObject:@"" forKey:@"pwdPianopass"];
        
        
        NSData *datashare =[NSData dataWithContentsOfFile:[DataExporter saveDataFromDictionary:dictshare]];
        [mailer addAttachmentData:datashare mimeType:@"application/pianopass" fileName:@"EncryptedData.pianopass"];
        [self presentModalViewController:mailer animated:YES];
        
        isPasswordInclude = NO;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet or add E-mail account from setting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)OpenActionSheetOrPasswordView
{
    if (isPasswordInclude)
    {
        [self performSelector:@selector(SendMailWithEncryption) withObject:nil afterDelay:0.5];
    }
    else
    {
        [self.view addSubview:ViewPass];
        [self.view bringSubviewToFront:ViewPass];
        
        if (isiPhone5)
            ViewPass.frame = CGRectMake(50, 160, 220, 227);
        else
            ViewPass.frame = CGRectMake(50, 116, 220, 227);
    }
}
-(IBAction)btnSkipOrGoPressed:(id)sender
{
    [tfPassword resignFirstResponder];
    
    [ViewPass removeFromSuperview];
    
    if ([sender tag] == 101)
    {
        NSRange whiteSpaceRange = [tfPassword.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([tfPassword.text length] == 0)
        {
            UIAlertView *alrtMessage = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"Password should not be empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alrtMessage show];
        }
        else if (whiteSpaceRange.location != NSNotFound)
        {
            UIAlertView *alrtMessage = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"You can not put space in password." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alrtMessage show];
        }
        else
        {
            isPasswordInclude = YES;
            [self performSelector:@selector(SendMailWithEncryption) withObject:nil afterDelay:0.5];
        }
    }
    else if ([sender tag] == 102)
    {
        isPasswordInclude = NO;
        [self performSelector:@selector(SendMailWithEncryption) withObject:nil afterDelay:0.5];
    }
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
//Apple doesn't actually allow you to delete from the photo library through an API. The user has to actually go to the Photos app and delete it manually themselves.

// MARK: - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView==_inerScrollView) {
        
        return  imgView;
        
    }else
        return nil;
    
    
}
- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = _inerScrollView.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    _inerScrollView.contentOffset = co;
}
- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}

#pragma mark - Tags Section
-(IBAction)btnTagPressed:(id)sender
{    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50];
    if ([btnTag isSelected])
    {
        KeyBoardMsg = NO;

        tbl_Tags.alpha = 0.0;
        [self setbtnTaghidden:YES imgset:@"tagButtonGray.png" setslctd:NO];
    }
    else
    {
        KeyBoardMsg = YES;
        NSString *strTags = [NSString stringWithFormat:@"%@",[[ArryImages objectAtIndex:indexclick]  valueForKey:@"tag"]];
        if ([ArryTags count] > 0)
        {
            [ArryTags removeAllObjects];
        }
        if ([[self removeNull:strTags] length] > 0)
        {
            ArryTags = [[[self removeNull:strTags] componentsSeparatedByString:@","] mutableCopy];
        }
        tbl_Tags.alpha = 1.0;
        [tbl_Tags reloadData];
        [self settbl_TagsFrame];
        [self setbtnTaghidden:NO imgset:@"tagButtonOrange.png" setslctd:YES];

    }
    [UIView commitAnimations];
}
-(void)setbtnTaghidden:(BOOL)yesno imgset:(NSString*)strimgName setslctd:(BOOL)selectedornot
{
    btnTblTagRemove.hidden = yesno;
    [btnTag setImage:[UIImage imageNamed:strimgName] forState:UIControlStateNormal];
    [btnTag setSelected:selectedornot];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate  Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryTags count] + 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // }
    
    int noofRows = [tableView numberOfRowsInSection:indexPath.section];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Tags:";
        cell.textLabel.textColor = RGBCOLOR(255, 128, 0);
        cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:20.0];
    }
    else if (indexPath.row == noofRows-1)
    {
        tfAddTag = [[UITextField alloc]init];
        tfAddTag.frame = CGRectMake(10, 5, 260, 30);
        tfAddTag.placeholder = @"Add a tag...";
        tfAddTag.font = [UIFont fontWithName:@"GillSans" size:20.0];
        tfAddTag.textColor = [UIColor lightGrayColor];
        tfAddTag.borderStyle = UITextBorderStyleNone;
        tfAddTag.tag = indexPath.row;
        tfAddTag.delegate = self;
        tfAddTag.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:tfAddTag];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[ArryTags objectAtIndex:indexPath.row - 1]];
        cell.textLabel.textColor = RGBCOLOR(255, 128, 0);
        cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:20.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [ArryTags removeObjectAtIndex:indexPath.row-1];
        [self UpdateTagsInArray];
        [self settbl_TagsFrame];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int noofRows = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0 || indexPath.row == noofRows-1)
    {
        return  UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}
#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [tbl_Tags scrollsToTop];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [tbl_Tags setFrame:CGRectMake(tbl_Tags.frame.origin.x, tbl_Tags.frame.origin.y - PORTRAIT_KEYBOARD_HEIGHT + 40, tbl_Tags.frame.size.width, tbl_Tags.frame.size.height)];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[self removeNull:tfAddTag.text] length] == 0)
    {
        if (KeyBoardMsg)
        {
            UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"Tag should not be empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [AlertView show];
            [tbl_Tags reloadData];
        }
    }
    else
    {
        [ArryTags addObject:tfAddTag.text];
        
        [self UpdateTagsInArray];
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [tbl_Tags setFrame:CGRectMake(tbl_Tags.frame.origin.x, tbl_Tags.frame.origin.y + PORTRAIT_KEYBOARD_HEIGHT, tbl_Tags.frame.size.width, tbl_Tags.frame.size.height)];
    [UIView commitAnimations];
    
    [self settbl_TagsFrame];

}
-(void)UpdateTagsInArray
{
    NSString *strTags = [ArryTags componentsJoinedByString:@","];
    NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:[[ArryImages objectAtIndex:indexclick]  valueForKey:@"id"],@"id",[[ArryImages objectAtIndex:indexclick]  valueForKey:@"attachment"],@"attachment",[[ArryImages objectAtIndex:indexclick]  valueForKey:@"type"],@"type",strTags,@"tag",[[ArryImages objectAtIndex:indexclick]  valueForKey:@"desc"],@"desc",nil];
    [ArryImages replaceObjectAtIndex:indexclick withObject:d];
    
    strTags = [strTags stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *strQuery_Update = [NSString stringWithFormat:@"update tbl_cameraroll Set tag='%@' Where id=%d",strTags,[[[ArryImages objectAtIndex:indexclick]  valueForKey:@"id"]intValue]];
    [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Update];
    
    [tbl_Tags reloadData];
}
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
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

-(void)settbl_TagsFrame
{
    int tblYAxis;
    if (isiPhone5)
        tblYAxis = 216 + 88;
    else
        tblYAxis = 216;
    
    int YAxisDiff = 200 - tbl_Tags.contentSize.height;
    
    if (tbl_Tags.contentSize.height > 200)
    {
        [tbl_Tags setFrame:CGRectMake(tbl_Tags.frame.origin.x, tblYAxis, tbl_Tags.frame.size.width, 200)];
    }
    else
    {
        [tbl_Tags setFrame:CGRectMake(tbl_Tags.frame.origin.x, tblYAxis + YAxisDiff, tbl_Tags.frame.size.width, tbl_Tags.contentSize.height)];
    }
}
-(IBAction)btnTblRemove:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    if ([btnTag isSelected])
    {
        KeyBoardMsg = NO;
        [tfAddTag resignFirstResponder];
        tbl_Tags.alpha = 0.0;
        [self setbtnTaghidden:YES imgset:@"tagButtonGray.png" setslctd:NO];
    }
    [UIView commitAnimations];
}
@end
