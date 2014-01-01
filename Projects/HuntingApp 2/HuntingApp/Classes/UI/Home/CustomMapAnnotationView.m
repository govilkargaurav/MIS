//
//  CustomMapAnnotationView.m
//  HuntingApp
//
//  Created by Habib Ali on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMapAnnotationView.h"
#import "UIImage+Scale.h"

@implementation CustomMapAnnotationView
@synthesize btnThumbnail;
@synthesize imgView;
@synthesize lblName,latllongStr,popOverArrowDownImage,balloonImage;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imgView = [[FLImageView alloc] init];
        imgView.delegate = self;
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 60, 12)];
        [lblName setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setBackgroundColor:[UIColor blackColor]];
        [lblName setTextAlignment:UITextAlignmentCenter];
        btnThumbnail = [[UIButton alloc] init];
        
        popOverArrowDownImage = [[UIImageView alloc] init];
        [popOverArrowDownImage setImage:[UIImage imageNamed:@"popoverArrowDown.png"]];
        [popOverArrowDownImage setFrame:CGRectMake(24, 56, 8, 12)];
        
        balloonImage = [[UIImageView alloc] init];
        [balloonImage setImage:[UIImage imageNamed:@"pin.png"]];
        [balloonImage setFrame:CGRectMake(8, 56, 14, 28)];
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:lblName];
    [self addSubview:popOverArrowDownImage];
    [self addSubview:balloonImage];
}

- (void)setImage:(UIImage *)image
{
    image = [image scaleToSize:CGSizeMake(60, 44)];
    [super setImage:image];
}

- (void)imageDidLoad:(UIImage *)img
{
    [self setImage:img];
}



- (void)dealloc {
    [imgView release];
    [lblName release];
    [btnThumbnail release];
    [super dealloc];
}
@end
