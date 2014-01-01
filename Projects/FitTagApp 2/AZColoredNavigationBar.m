//
//  AZColoredNavigationBar.m
//  AZColoredNavigationBar
//
//  Created by Alan on 23/09/13.
//  Copyright (c) 2013 Alan Zeino. All rights reserved.
//

#import "AZColoredNavigationBar.h"

@interface AZColoredNavigationBar ()

@property (strong, nonatomic) CALayer *extraColorLayer;

@end

static CGFloat const kDefaultColorLayerOpacity = .7f;
static CGFloat const kSpaceToCoverStatusBars = 64.f;

@implementation AZColoredNavigationBar

#pragma mark - Instance

- (CALayer *)extraColorLayer
{
    if (_extraColorLayer)
        return _extraColorLayer;
    
    _extraColorLayer = [CALayer layer];
    _extraColorLayer.opacity = kDefaultColorLayerOpacity;
    [self.layer addSublayer:_extraColorLayer];
    
    return _extraColorLayer;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Return early if this is an older version of iOS.
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7)
        return;
    
    if (self.extraColorLayer)
        self.extraColorLayer.frame = CGRectMake(0.f, -kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
    
    [self.extraColorLayer removeFromSuperlayer];
    [self.layer insertSublayer:_extraColorLayer atIndex:1];
}

#pragma mark - UINavigationBar

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    
    // Return early if this is an older version of iOS.
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7)
        return;
    
    self.extraColorLayer.backgroundColor = barTintColor.CGColor;
}

@end
