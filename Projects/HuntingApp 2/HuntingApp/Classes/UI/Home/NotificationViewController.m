//
//  NotificationViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "NSString+Additions.h"

@interface NotificationViewController ()

- (NSArray *)sortArray:(NSArray *)array;
- (BOOL)isContainIDInNotificationRead:(NSString *)ID isPicture:(BOOL)isPicture;
@end

@implementation NotificationViewController

@synthesize delegate,itemsArray;

- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array
{
    self = [super initWithStyle:style];
    {
        self.itemsArray = [[NSMutableArray alloc] initWithArray:[self sortArray:array]];
        self.contentSizeForViewInPopover = CGSizeMake(170, ([itemsArray count]* 44)- 1);
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array andNotificationsArray:(NSArray *)anotArray
{
    self = [super initWithStyle:style];
    {
//        self.itemsArray = [[NSMutableArray alloc] initWithArray:[self sortArray:array]];
//        notArray = [[NSArray alloc]initWithArray:anotArray];
//        NSInteger count = (itemsArray.count + anotArray.count)<6?((itemsArray.count + anotArray.count)):6;
        self.itemsArray = [[NSMutableArray alloc] initWithArray:[[DAL sharedInstance] getAllNotifications]];
        NSInteger count = self.itemsArray.count>6?6:self.itemsArray.count;
        self.contentSizeForViewInPopover = CGSizeMake(260, (count* 44)- 1);
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    RELEASE_SAFELY(self.itemsArray);
    RELEASE_SAFELY(notArray);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSMutableArray *arr = [NSMutableArray arrayWithArray:notArray];
    //[arr addObjectsFromArray:itemsArray];
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (NotificationCell *)[[[NSBundle mainBundle]loadNibNamed:@"NotificationCell" owner:nil options:nil] objectAtIndex:0];
    }
	Notification *notification = [self.itemsArray objectAtIndex:indexPath.row];
    cell.lblCaption.text = notification.notData;
    cell.lblLocation.text = @"";
    if ([notification.notData containsString:@"following"])
    {
        Profile *profile = [[DAL sharedInstance] getProfileByID:notification.notItemID];
        cell.lblCaption.text = [NSString stringWithFormat:@"%@ is following you",profile.name];
        [cell.imgView setImageWithUrl:[Utility getProfilePicURL:notification.notItemID]];
    }
    else if ([notification.notData containsString:@"A new picture has been posted on"])
    {
        cell.lblCaption.text = notification.notData;
        cell.lblLocation.text = [[notification.notID componentsSeparatedByString:@"-"] objectAtIndex:0];
        [cell.imgView setImageWithUrl:[Utility getImageURL:notification.notItemID]];
    }
    else
        [cell.imgView setImageWithUrl:[Utility getImageURL:notification.notItemID]];

    if (notification.isRead.boolValue)
        cell.bgView.backgroundColor = [UIColor whiteColor];
    else
        cell.bgView.backgroundColor = [UIColor yellowColor];
    
    
    
//    // Configure the cell...
//    if (indexPath.row < notArray.count)
//    {
//        NSDictionary *dict = [[notArray objectAtIndex:indexPath.row] objectForKey:@"notifications"];
//        NSString *meta = [dict objectForKey:@"meta"];
//        if ([meta containsString:@"added"])
//        {
//            meta = [meta stringByReplacingOccurrencesOfString:@"added" withString:@"has posted"];
//        }
//        cell.lblCaption.text = meta;//[dict objectForKey:@"meta"];
//        if ([[dict objectForKey:@"meta"]containsString:@"following"])
//        {
//            Profile *profile = [[DAL sharedInstance] getProfileByID:[dict objectForKey:@"userid"]];
//            cell.lblCaption.text = [NSString stringWithFormat:@"%@ is following you",profile.name];
//        }
//        [cell.imgView setImageWithUrl:[Utility getProfilePicURL:[dict objectForKey:@"userid"]]];
//        cell.lblLocation.text = @"";
//        
//        NSString *ID = [dict objectForKey:@"item_id"];
//        NSString *component = [dict objectForKey:@"component"];
//        if ([component isEqualToString:@"image"] && [self isContainIDInNotificationRead:ID isPicture:YES])
//        {
//            cell.bgView.backgroundColor = [UIColor whiteColor];
//        }
//        else if (![component isEqualToString:@"image"] && [self isContainIDInNotificationRead:ID isPicture:NO])
//        {
//            ID = [dict objectForKey:@"userid"];
//            cell.bgView.backgroundColor = [UIColor whiteColor];
//        }
//        else {
//            cell.bgView.backgroundColor = [UIColor yellowColor];
//        }
//        
//    }
//    else if ((indexPath.row - notArray.count ) < [self.itemsArray count])
//    {
//        Picture *pic = [itemsArray objectAtIndex:(indexPath.row - notArray.count )];
//        cell.lblCaption.text = @"A new picture has been posted on";//pic.caption;
//        cell.lblLocation.text = pic.location;
//        if (pic.image)
//            [cell.imgView setImage:[UIImage imageWithData:pic.image.image]];
//        else 
//        {
//            [cell.imgView setImageWithUrl:pic.image_url];
//        }
//        NSString *ID = [[pic.image_url componentsSeparatedByString:@"="] lastObject];
//        if ([self isContainIDInNotificationRead:ID isPicture:YES])
//        {
//            cell.bgView.backgroundColor = [UIColor whiteColor];
//        }
//        else 
//        {
//            cell.bgView.backgroundColor = [UIColor yellowColor];
//        }
//    }
//    else 
//    {
//        cell.lblCaption.text = @"";
//        cell.lblLocation.text = @"";
//        [cell.imgView setImage:nil];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *not = [self.itemsArray objectAtIndex:indexPath.row];
    not.isRead = [NSNumber numberWithBool:YES];
    NSDictionary *dict;
    if (not.isPicture.boolValue)
    {
        NSArray *arr = [[DAL sharedInstance] getAllImagesByPartialID:@"Timeline-"];
        NSString *ID = nil;
        for (Picture *pic in arr)
        {
            if ([pic.image_url isEqualToString:[Utility getImageURL:not.notItemID]])
            {
                ID = pic.pic_id;
                break;
            }
        }
        dict = [NSDictionary dictionaryWithObject:ID forKey:PICTURE_ID_KEY];
    }
    else
    {
        dict = [NSDictionary dictionaryWithObject:not.notItemID forKey:PROFILE_USER_ID_KEY];
    }
    if (delegate && [delegate respondsToSelector:@selector(notificationSelected:)])
        [delegate performSelector:@selector(notificationSelected:) withObject:dict];
        
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *array = [[NSMutableArray arrayWithArray:[defaults objectForKey:NOTIFICATION_READ]] retain];
//    if (indexPath.row < notArray.count)
//    {
//        NSDictionary *dict = [[notArray objectAtIndex:indexPath.row] objectForKey:@"notifications"];
//        NSDictionary *dict2;
//        if ([[dict objectForKey:@"component"] isEqualToString:@"image"])
//        {
//            NSString *ID = [dict objectForKey:@"item_id"];
//            NSArray *arr = [[DAL sharedInstance] getAllImagesByPartialID:@"Timeline-"];
//            for (Picture *pic in arr) {
//                if ([pic.image_url isEqualToString:[Utility getImageURL:ID]])
//                {
//                    ID = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
//                    [array addObject:[NSDictionary dictionaryWithObject:[[pic.image_url componentsSeparatedByString:@"="]lastObject] forKey:PICTURE_ID_KEY]];
//                    break;
//                }
//            }
//            dict2 = [NSDictionary dictionaryWithObject:ID forKey:PICTURE_ID_KEY];
//            
//        }
//        else 
//        {
//            dict2 = [NSDictionary dictionaryWithObject:[dict objectForKey:@"userid"] forKey:PROFILE_USER_ID_KEY];
//            [array addObject:dict2];
//        }
//        if (delegate && [delegate respondsToSelector:@selector(notificationSelected:)])
//            [delegate performSelector:@selector(notificationSelected:) withObject:dict2];
//    }
//    else if ((indexPath.row - notArray.count ) < [self.itemsArray count])
//    {
//        Picture *picture = (Picture *)[itemsArray objectAtIndex:(indexPath.row-notArray.count)];
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:picture.pic_id forKey:PICTURE_ID_KEY];
//        [array addObject:[NSDictionary dictionaryWithObject:[[picture.image_url componentsSeparatedByString:@"="]lastObject] forKey:PICTURE_ID_KEY]];
//        if (delegate && [delegate respondsToSelector:@selector(notificationSelected:)])
//            [delegate performSelector:@selector(notificationSelected:) withObject:dict];
//    }
//    [defaults setObject:array forKey:NOTIFICATION_READ];
//    RELEASE_SAFELY(array);
}

- (NSArray *)sortArray:(NSArray *)array
{
    NSArray *sortedArray;
    NSMutableArray *retArr = [NSMutableArray array];
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(Picture *a, Picture *b) 
    {
        NSInteger picID1 = [[[a.desc componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        NSInteger picID2 = [[[b.desc componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        return ((picID1<picID2)?YES:NO);
    }];
    
    if (sortedArray.count!=0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:sortedArray];
        for (Picture *pic in sortedArray) 
        {
            if (!pic.location || [pic.location isEmptyString])
                [arr removeObject:pic];
        }
        if (arr.count!=0)
            sortedArray = [NSArray arrayWithArray:arr];
        else {
            sortedArray = nil;
        }
    }
    if ([sortedArray count]>6)
    {
        for (int i=0; i<6; i++) {
            [retArr addObject:[sortedArray objectAtIndex:i]];
        }
    }
    else {
        retArr = [NSMutableArray arrayWithArray:sortedArray];
    }
    return retArr;
    
}

- (BOOL)isContainIDInNotificationRead:(NSString *)ID isPicture:(BOOL)isPicture
{
    BOOL contain = NO;
    NSString *key = nil;
    if (isPicture)
        key = PICTURE_ID_KEY;
    else
        key = PROFILE_USER_ID_KEY;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:NOTIFICATION_READ];
    for (NSDictionary *dict in array)
    {
        if ([dict objectForKey:key] && [[dict objectForKey:key] isEqualToString:ID])
        {
            contain = YES;
            break;
        }
    }
    return contain;
}

@end
