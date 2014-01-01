//
//  SelectFromPianoPass.m
//  PianoApp
//
//  Created by Imac 2 on 7/17/13.
//
//

#import "SelectFromPianoPass.h"
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "UIImage+KTCategory.h"

@interface SelectFromPianoPass ()

@end

@implementation SelectFromPianoPass
@synthesize _delegate;

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
    Yaxis=4;
    Xaxis=-75;
    TagLast = 1;
    
    [AppDel doshowHUD];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    [self performSelectorInBackground:@selector(callThumbnail) withObject:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)callThumbnail
{
    @autoreleasepool
    {
        while ([Scl_Photo.subviews count] > 0) {
            
            [[[Scl_Photo subviews] objectAtIndex:0] removeFromSuperview];
        }
        NSMutableArray *ArryPhotoVideo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_cameraroll:@"SELECT * FROM tbl_cameraroll where type LIKE 'Image'"]];
        if ([ArryPhotoVideo count] == 0)
        {
            lblNoPhoto.hidden = NO;
        }
        else
        {
            lblNoPhoto.hidden = YES;
        }
        for (NSDictionary *DicPhotoVideo in ArryPhotoVideo)
        {
            Xaxis=Xaxis+79;
            if (Xaxis > 260)
            {
                Xaxis=4;
                Yaxis=Yaxis+79;
            }
            
            NSArray *ArryPathString = [[DicPhotoVideo valueForKey:@"attachment"] componentsSeparatedByString:@"/"];
            NSString *strImageName = [ArryPathString lastObject];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *strAttachmentPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strImageName];
            
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
            UIButton *btnPicBig = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPicBig setFrame:CGRectMake(Xaxis, Yaxis, 75, 75)];
            
            dispatch_queue_t queue = dispatch_queue_create("GenerateThumb",NULL);
            dispatch_async(queue, ^{
                UIImage *thumbnail = [self imageAtPath:strAttachmentPath cache:AppDel.DicCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = thumbnail;
                });
            });
            imgView.tag = TagLast;
            
            [Scl_Photo addSubview:imgView];
            [btnPicBig setTitle:strAttachmentPath forState:UIControlStateNormal];
            [btnPicBig setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btnPicBig setTag:TagLast];
            TagLast ++;
            [btnPicBig addTarget:self action:@selector(btnPicBigPressed:) forControlEvents:UIControlEventTouchUpInside];
    
            [Scl_Photo addSubview:btnPicBig];
            
            Scl_Photo.contentSize=CGSizeMake(320,Yaxis+79);
            
            CGPoint bottomOffset = CGPointMake(0, MAX(Scl_Photo.contentSize.height - Scl_Photo.bounds.size.height, 0));
            [Scl_Photo setContentOffset:bottomOffset animated:NO];
        }
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        [AppDel dohideHUD];
    }
}

- (UIImage *)imageAtPath:(NSString *)path cache:(NSMutableDictionary *)cache{
    // Retrieve image from the cache.
    UIImage *imageThumb = [cache objectForKey:path];
    // If not in the cache, retrieve from the file system
    // and add to the cache.
    UIImage *image;
    if (imageThumb == nil)
    {
        image = [UIImage imageWithContentsOfFile:path];
        imageThumb = [image imageScaleAndCropToMaxSize:CGSizeMake(150,150)];
        if (imageThumb) {
            NSString *StrPath = [NSString stringWithFormat:@"%@Big",path];
            [cache setObject:imageThumb forKey:path];
            [cache setObject:image forKey:StrPath];
        }
    }
    return imageThumb;
}

-(IBAction)btnPicBigPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *StrPath = [NSString stringWithFormat:@"%@Big",btn.titleLabel.text];
    UIImage *img = [AppDel.DicCache objectForKey:StrPath];
    [_delegate ImagePassForEncrypt:img];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnBackPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
