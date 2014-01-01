//
//  MeetingCell.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "MeetingCell.h"

@interface MeetingCell ()

@end

@implementation MeetingCell
@synthesize btnNote;
@synthesize btnMic;
@synthesize btnMail;
@synthesize btnDelete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil indexpath:(int)indextpathRow
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexpathrow=indextpathRow+2000;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnMic.tag= indexpathrow;
    btnDelete.tag=indexpathrow;
    btnNote.tag= indexpathrow-1000;
    btnMail.tag= indexpathrow+1000;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
