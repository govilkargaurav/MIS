//
//  DecryptorViewCtr.m
//  PianoApp
//
//  Created by Imac 2 on 6/1/13.
//
//

#import "DecryptorViewCtr.h"
#import "DatabaseAccess.h"

@interface DecryptorViewCtr ()

@end

@implementation DecryptorViewCtr
@synthesize strText;
@synthesize imgDecoded;

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
    if ([strText length] > 0)
    {
        txtOrifinalText.text = [NSString stringWithFormat:@"%@",strText];
        imgView.hidden = YES;
        [btnSave setTitle:@"Save to PianoPass Notes" forState:UIControlStateNormal];
    }
    else
    {
        imgView.image = imgDecoded;
        txtOrifinalText.hidden = YES;
        [btnSave setTitle:@"Save to PianoPass Photos" forState:UIControlStateNormal];
    }
    AppDel.dicEncrtptedFile = nil;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSaveToNotesPressed:(id)sender
{
    if ([strText length] > 0)
    {
        if ([txtOrifinalText.text length] != 0)
        {
            NSString *strTextSave = [txtOrifinalText.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [timeFormat setDateFormat:@"h:mm a"];
            
            NSDate *now = [[NSDate alloc] init];
            
            NSString *strDate = [dateFormat stringFromDate:now];
            NSString *strTime = [timeFormat stringFromDate:now];
            
            NSString *str_Insert_Notes = [NSString stringWithFormat:@"insert into tbl_notes(ndate,ntime,notesdesc) values('%@','%@','%@')",strDate,strTime,strTextSave];
            [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_Notes];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        NSTimeInterval ttime=[[NSDate date] timeIntervalSince1970];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/ImageClue%f.png",documentsDirectory,ttime];
        NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(imgDecoded, 1.0)];
        [data1 writeToFile:pngFilePath atomically:NO];
        
        NSString *str_Insert_CameraRoll = [NSString stringWithFormat:@"insert into tbl_cameraroll(attachment,type,tag,desc) values('%@','%@','%@','%@')",pngFilePath,@"Image",@"",@""];
        [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_CameraRoll];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
