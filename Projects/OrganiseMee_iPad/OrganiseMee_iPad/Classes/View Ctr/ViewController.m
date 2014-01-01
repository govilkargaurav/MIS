//
//  ViewController.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/21/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ListViewCtr.h"
#import "TaskViewCtr.h"
#import "NewTaskViewCtr.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    leftController = [[UINavigationController alloc]init];
    leftController.delegate = self;
    centerController = [[UINavigationController alloc]init];
    centerController.delegate = self;
    rightController = [[UINavigationController alloc]init];
    rightController.delegate = self;
    ListViewCtr *leftViewController = [[ListViewCtr alloc] initWithNibName:@"ListViewCtr" bundle:nil];
    [leftController pushViewController:leftViewController animated:YES];
    TaskViewCtr *centerViewController =[[TaskViewCtr alloc] initWithNibName:@"TaskViewCtr" bundle:nil];
    [centerController pushViewController:centerViewController animated:YES];
    NewTaskViewCtr *rightViewController = [[NewTaskViewCtr alloc]initWithNibName:@"NewTaskViewCtr" bundle:nil];
    [rightController pushViewController:rightViewController animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
        {
            OrientationFlag = 0;
            self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
            leftController.view.frame = CGRectMake(0, 0, 0, leftController.view.frame.size.height);
            centerController.view.frame = CGRectMake(0, 0,768, centerController.view.frame.size.height);
            rightController.view.frame = CGRectMake(769, 0,320, rightController.view.frame.size.height);
        }
        else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
        {
            OrientationFlag = 1;
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            leftController.view.frame = CGRectMake(0, 0, 256, leftController.view.frame.size.height);
            centerController.view.frame = CGRectMake(257, 0,1024-256, centerController.view.frame.size.height);
            rightController.view.frame = CGRectMake(1024, 0,320, rightController.view.frame.size.height);
            
        }

    });
   // [self updateui];

    [self.view addSubview:leftController.view];
    [self.view addSubview:centerController.view];
    [self.view addSubview:rightController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftViewShow:) name:@"LeftViewShow" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RightViewShow:) name:@"RightViewShow" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self updateui];
}
#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        OrientationFlag = 0;
       /* self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        leftController.view.frame = CGRectMake(0, 0, 0, leftController.view.frame.size.height);
        centerController.view.frame = CGRectMake(0, 0,768, centerController.view.frame.size.height);
        rightController.view.frame = CGRectMake(769, 0,320, rightController.view.frame.size.height);*/
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        OrientationFlag = 1;
       /* self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        leftController.view.frame = CGRectMake(0, 0, 256, leftController.view.frame.size.height);
        centerController.view.frame = CGRectMake(257, 0,1024-256, centerController.view.frame.size.height);
        rightController.view.frame = CGRectMake(1024, 0,320, rightController.view.frame.size.height);*/

    }
   // AppDel.masterIsVisible = NO;

}
/*-(void)LeftViewShow:(NSNotification*)noti
{
    if ([noti.object isEqualToString:@"no"])
    {
        leftController.view.frame = CGRectMake(0, 0, 0, leftController.view.frame.size.height);
        centerController.view.frame = CGRectMake(0, 0,768, centerController.view.frame.size.height);
    }
    else
    {
        leftController.view.frame = CGRectMake(0, 0, 256, leftController.view.frame.size.height);
        centerController.view.frame = CGRectMake(257, 0,768-256, centerController.view.frame.size.height);
    }
}
-(void)RightViewShow:(NSNotification*)noti
{
    if (OrientationFlag == 0)
    {
        rightController.view.frame = CGRectMake(448, 0,320, rightController.view.frame.size.height);
    }
    else
    {
        rightController.view.frame = CGRectMake(704, 0,320, rightController.view.frame.size.height);
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
