//
//  RecieptSubmitController.m
//  PropertyInspector
//
//  Created by apple on 11/3/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "RecieptSubmitController.h"
#import "CustomCell.h"
#import "LoginModel.h"
#import "ThreadManager.h"
#import "BusyAgent.h"
#import "NSObject+XMLParser.h"
#import "AlertManger.h"
#import "UIImage+Resize.h"


@interface RecieptSubmitController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    
    
    UIImageView *reciptImageCamara;
    int chooseType;
    NSMutableArray *mainArrayofphoto;
    NSMutableURLRequest *request;
    NSMutableDictionary *getParseDictionary;
    int COUNT;
    
}
@property(nonatomic,strong)IBOutlet UITableView *_tableViewReciept;
@property(nonatomic,strong)IBOutlet UITableView *_tableViewCheck;
@property(nonatomic,strong)NSMutableArray *recieptImageArr;
@property(nonatomic,strong)NSMutableArray *checkImageArr;
@end

@implementation RecieptSubmitController

@synthesize propertyID;
@synthesize recieptImageArr;
@synthesize checkImageArr;
@synthesize dataImage;
@synthesize _tableViewReciept;
@synthesize _tableViewCheck;
@synthesize img;
@synthesize reducedImg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (recieptImageArr!=nil) {
            
            recieptImageArr=nil;
            [recieptImageArr removeAllObjects];
            
        }
        recieptImageArr=[[NSMutableArray alloc] init];
        
        if (checkImageArr!=nil) {
            
            checkImageArr=nil;
            [checkImageArr removeAllObjects];
            
        }
        checkImageArr=[[NSMutableArray alloc] init];
        
        if (getParseDictionary!=nil) {
            getParseDictionary=nil;
            [getParseDictionary removeAllObjects];
        }
        getParseDictionary=[[NSMutableDictionary alloc] init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"UPLOAD" style:UIBarButtonItemStyleBordered target:self action:@selector(getphotoPost)];
     self.navigationItem.rightBarButtonItem = button;
    COUNT=0;
    parser=[[XMLParser alloc] init];
    parser.delegate=self;

}


-(void)getphotoPost
{

    ////NSLog(@"getPhotoPost was called");
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    mainArrayofphoto=[[NSMutableArray alloc]init];
    [mainArrayofphoto addObject:checkImageArr];
    [mainArrayofphoto addObject:recieptImageArr];
    
    
    for(int i=0;i<[mainArrayofphoto count];i++)
    {
        NSArray *array=[[NSArray alloc]initWithArray:[mainArrayofphoto objectAtIndex:i]];
        for (int j=0; j<[array count]; j++) {
            @synchronized(self)
            {
                NSString *Boundary = @"0xKhTmLbOuNdArY";

                NSString *urlString = WEB_POST_PAYMENT_PHOTO;
                //NSString *urlString = @"http://184.106.243.106/AMH4RAuctionTEST/submitPaymentPhoto.aspx";
                //NSString *urlString = @"http://184.106.243.106/AMH4RAuction/submitPaymentPhoto.aspx";
                request = [[NSMutableURLRequest alloc] init] ;
                [request setURL:[NSURL URLWithString:urlString]];
                [request setHTTPMethod:@"POST"];
                NSString  *contentType= [NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary];
                
                [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
                NSMutableData *body = [NSMutableData data];
                
                //userid
                ////NSLog(@"userid....");
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"sessionId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@",sessionID]  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                //current location on which file is uploading
                
                // text parameter
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"propertyId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@",propertyID]  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSData *imageData = UIImageJPEGRepresentation([array objectAtIndex:j], .8);  // Image quality factor is at .8 (Adjust as needed!)
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                if(i==0)
                {
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",@"CHECK"]  dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // Bug fix: Boundary data added here
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"photoName\"; filename=\"paymentPhoto%d.jpg\"\r\n",j] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                else if(i==1)
                {
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",@"RECEIPT"]  dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // Bug fix: Boundary data added here 
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"photoName\"; filename=\"ReceiptPhoto%d.jpg\"\r\n",j] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:imageData]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                
                
                // close form
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // set request body
                [request setHTTPBody:body];
                
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                [parser ParsingDataFromurl:returnData];
                
                                
            }
        }    
    }
        
}

#pragma marked--parsing delegates

- (void)startParseXML:(NSXMLParser*) parser
{
    getParseDictionary=[[NSMutableDictionary alloc]init];
    ////NSLog(@"Prser startParseXML");
}
- (void)endParseXML:(NSXMLParser*) parser
{
    ////NSLog(@"%@",[getParseDictionary objectForKey:@"success"]);
    
    if([[getParseDictionary objectForKey:@"success"] isEqualToString:@"false"])
    {
        COUNT++;
        
        if (COUNT==[recieptImageArr count]+[checkImageArr count]) {
        
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:APP_NAME message:[NSString stringWithFormat:@"%@",[getParseDictionary objectForKey:@"reason"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        }
        
    }
    else
    {
        ////NSLog(@"Payment success received from server");
        COUNT++;
        
        if (COUNT==[recieptImageArr count]+[checkImageArr count]) {
            
            UIAlertView *Alert1=[[UIAlertView alloc]initWithTitle:APP_NAME message:[NSString stringWithFormat:@"%@",@"The images have been uploaded successfully."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert1 show];
            
        }
        
       
        
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (buttonIndex==0) {
        
        
        [self LOGout];
        
    }
    
    
}


-(void)LOGout{
    
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"InfoViewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
    
}


- (void)parseStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    
    if([elementName isEqualToString:@"response"])
    {
        getParseDictionary=[attributeDict mutableCopy];
    }
    
}
- (void)parseEndElement:(NSString *)elementName
{
    
}
- (void)parseCharacters:(NSString *)string
{
    
}


-(void)busyViewinSecondryThread:(id)sender{
    
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableViewCheck) {
        
        return [checkImageArr count];
        
    }else if(tableView==_tableViewReciept){
        
        
        return [recieptImageArr count];
        
    }
    return 0;


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView==_tableViewCheck) {
        
        if (cell) {
            cell=nil;
            [cell removeFromSuperview];
            
        }
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellWithScrollView" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (CustomCell *) currentObject;
                    break;
                }
            }
        }
        
        cell.checkImage.image=[checkImageArr objectAtIndex:indexPath.row];
        cell.selectionStyle=FALSE;
        
    }else if (tableView==_tableViewReciept){
        
        
        
        if (cell) {
            cell=nil;
            [cell removeFromSuperview];
            
        }
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellReciept" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (CustomCell *) currentObject;
                    break;
                }
            }
        }
        
        cell.recieptImage.image=[recieptImageArr objectAtIndex:indexPath.row];
        cell.selectionStyle=FALSE;

        
        
    }
    
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return nil;
 
}

-(IBAction)captureReciept:(id)sender{
    
    int i =[sender tag];
    
    if (i==1) {
        chooseType=1;
    
    UIActionSheet *actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
	actionSheet1.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet1.alpha=0.90;
	actionSheet1.tag = 1;
	[actionSheet1 showInView:self.view];
        
    }else{
        
        
        chooseType=2;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.alpha=0.90;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        
    }
    
    
}






-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (actionSheet.tag) {
		case 1:
			switch (buttonIndex){
                case 0:{
#if TARGET_IPHONE_SIMULATOR
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saw Them" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
#elif TARGET_OS_IPHONE
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    [self presentModalViewController:picker animated:YES];
#endif
                }
                    break;
                case 1:{
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.delegate = self;
                    [self presentModalViewController:picker animated:YES];
                }
                    break;
            }
            break;
		default:
			break;
	}
}



-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
	//dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
	//reciptImageCamara.image = [[UIImage alloc] initWithData:dataImage];

    // ************** IMAGE RESIZING CODE START **************
    img = [info objectForKey:UIImagePickerControllerOriginalImage];

    ////NSLog(@"Original Image Width = %f", img.size.width);
    
    CGSize imageDims = img.size;
    ////NSLog(@"Height = %f", imageDims.height);
    ////NSLog(@"Width  = %f", imageDims.width);
    
    // DO PHOTO SCALING HERE:  For now using 1/4 which is equal to 75% reduction in image size
    // Adjust the divisor as needed!!
    CGSize newSize = CGSizeMake(imageDims.width/4, imageDims.height/4);
    
    reducedImg = [img resizedImage:newSize interpolationQuality:kCGInterpolationMedium];
    dataImage = UIImageJPEGRepresentation(reducedImg,1);

     ////NSLog(@"Resized Image Width = %f", reducedImg.size.width);
    
    // NOTE that in (void)getphotoPost method, the image quality is additionally reduced to reduce size.  Please be aware of this!
    // ************** IMAGE RESIZING CODE END **************
    
    if (chooseType==1) {
        
        [checkImageArr addObject:[[UIImage alloc] initWithData:dataImage]];
        ////NSLog(@"TRM DEBUG: ******* Got checkImageArr ");

        
    }else{
        
        [recieptImageArr addObject:[[UIImage alloc] initWithData:dataImage]];
        ////NSLog(@"TRM DEBUG: ******* Got recieptImageArr ");        
    }
    
    
    
	[picker dismissModalViewControllerAnimated:YES];
    
    [_tableViewReciept reloadData];
    
    [_tableViewCheck reloadData];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end














