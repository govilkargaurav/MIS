//
//  TempRightViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "TempRightViewCtr.h"
#import "NewTaskViewCtr.h"
#import "AppDelegate.h"
#import "EditTaskViewCtr.h"

@interface TempRightViewCtr ()

@end

@implementation TempRightViewCtr

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
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([AppDel.deckController rightControllerIsOpen])
    {
        AppDel.strTaskId = @"";
        [AppDel.deckController closeRightView];
    }
}
-(void)viewDeckControllerDidOpenRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    if ([AppDel.strTaskId length] > 0)
    {
        EditTaskViewCtr *obj_EditTaskViewCtr = [[EditTaskViewCtr alloc]initWithNibName:@"EditTaskViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_EditTaskViewCtr animated:NO];
    }
    else
    {
        NewTaskViewCtr *obj_NewTaskViewCtr = [[NewTaskViewCtr alloc]initWithNibName:@"NewTaskViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_NewTaskViewCtr animated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
