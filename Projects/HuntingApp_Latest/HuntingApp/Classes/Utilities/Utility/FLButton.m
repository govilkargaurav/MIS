//
//  FLButton.m
//  HuntingApp
//
//  Created by Habib Ali on 8/27/12.
//  Copyright (c) 2012 folio3. All rights reserved.
//

#import "FLButton.h"
#import "UIImage+Scale.h"

@implementation FLButton

- (void)dealloc
{
    imgView.delegate = nil;
    RELEASE_SAFELY(imgView);
    [super dealloc];
}

- (void)setImageWithProfile:(Profile *)profile
{
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    imgView = [[FLImageView alloc]init];
    [imgView setDelegate:self];
    [imgView setImageWithProfile:profile];
}

- (void)setImageWithImage:(Picture *)picture
{
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    imgView = [[FLImageView alloc]init];
    [imgView setDelegate:self];
    [imgView setImageWithImage:picture];
}

- (void)setImageWithURL:(NSString *)URL
{
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    imgView = [[FLImageView alloc]init];
    [imgView setDelegate:self];
    [imgView setImageWithUrl:URL];
}

- (void)imageDidLoad:(UIImage *)img
{
    img = [img scaleToSize:self.frame.size];
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateHighlighted];
    imgView.delegate = nil;
    RELEASE_SAFELY(imgView);
}


- (void)setImageWithDataInBackGround:(NSData *)data
{
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    [self performSelectorInBackground:@selector(setImageWithData:) withObject:data];
}

- (void)setImageWithData:(NSData *)data
{
    UIImage *img = [UIImage imageWithData:data];
    img = [img scaleToSize:self.frame.size];
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateHighlighted];
}






@end
