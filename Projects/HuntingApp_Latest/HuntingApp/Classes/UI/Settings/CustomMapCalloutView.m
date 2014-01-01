//
//  CustomMapCalloutView.m
//  HuntingApp
//
//  Created by Habib Ali on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMapCalloutView.h"

@implementation CustomMapCalloutView
@synthesize pinDown,areaName,lblState,delegate,state,area;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"bubble-pop.png"];
        
        self.areaName = [[CustomTextField3 alloc] initWithFrame:CGRectMake(8, 3, 125, 16)];
        self.areaName.textColor = [UIColor whiteColor];
        self.areaName.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.areaName.delegate = self;
        [self.areaName setPlaceholder:@"Enter Location Name:"];
        
        self.lblState = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, 125, 13)];
        self.lblState.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.lblState.textColor = [UIColor whiteColor];
        self.lblState.backgroundColor = [UIColor clearColor];
        [lblState setText:@"State"];
        
        self.pinDown = [[UIImageView alloc]initWithFrame:CGRectMake(27, 57, 15, 36)];
        [self.pinDown setImage:[UIImage imageNamed:@"PinDown.png"]];
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (delegate && [delegate respondsToSelector:@selector(areaNameDidEntered:)])
    {
        [delegate areaNameDidEntered:areaName.text];
    }
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:areaName];
    [self addSubview:lblState];
    [self addSubview:pinDown];
    if (state)
    {
        [lblState setTextColor:[UIColor yellowColor]];
        [areaName setTextColor:[UIColor yellowColor]];
        [lblState setText:state];
        [areaName setText:area];
        [areaName setUserInteractionEnabled:NO];
    }
    else 
    {
        [lblState setTextColor:[UIColor whiteColor]];
        [areaName setTextColor:[UIColor whiteColor]];
        [areaName becomeFirstResponder];
    }
}

- (void)dealloc
{
    RELEASE_SAFELY(areaName)
    RELEASE_SAFELY(lblState);
    RELEASE_SAFELY(pinDown);
    [super dealloc];
}

@end
