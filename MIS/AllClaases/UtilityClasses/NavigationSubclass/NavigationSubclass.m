//
//  NavigationSubclass.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "NavigationSubclass.h"
#import "GlobalClass.h"
@implementation NavigationSubclass
@synthesize btnSearchView;
- (id)initWithFrame:(CGRect)frame navigationTitleName:(NSString *)strTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame= frame;
        
        UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        bgImageView.image = [UIImage imageNamed:@"nagBg.png"];
        [self addSubview:bgImageView];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(40,0, 200, 44)];
        lblTitle.center = self.center;
        [lblTitle setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18]];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setText:[NSString stringWithFormat:@"%@",strTitle]];
        self.backgroundColor= [UIColor clearColor];
        [self addSubview:lblTitle];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([strTitleViewCalling isEqualToString:DRAW_RECT]) {
        
        btnSearchView = [[UIButton alloc]init];
        btnSearchView.frame = CGRectMake(270,0,50, 44);
        UIImageView *searchImage=[[UIImageView alloc] initWithFrame:CGRectMake(290, 12, 22, 23)];
        [searchImage setImage:[UIImage imageNamed:@"searchBtn.png"]];
        [btnSearchView addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchImage];
        [self addSubview:btnSearchView];
        
        
        UIButton *btnAddMeeting = [[UIButton alloc]init];
        btnAddMeeting.frame = CGRectMake(0, 0, 60, 44);
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 22 , 23)];
        [imageView setImage:[UIImage imageNamed:@"addBtn.png"]];
        [btnAddMeeting addTarget:self action:@selector(AddMeetingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageView];
        [self addSubview:btnAddMeeting];
        
    }
    
}

-(void)searchBtnClicked:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_POST_NOTIFICATION object:nil];
    
}

-(void)AddMeetingBtnClicked:(id)sender
{
    _dictURLwithSpeech=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_MEETING_POST_NOTIFICATION object:nil];
}

@end
