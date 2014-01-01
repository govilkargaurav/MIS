//
//  PopoverView_Configuration.h
//  popover
//
//  Created by Bas Pellis on 12/25/12.
//  Copyright (c) 2012 Oliver Rickard. All rights reserved.

#pragma mark Constants - Configure look/feel

// BOX GEOMETRY

//Height/width of the actual arrow
#define kArrowHeight 12.f

//padding within the box for the contentView
#define kBoxPadding 3.f

//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define kBoxRadius 4.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 6.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 2.f

//Alpha value for the shadow behind the PopoverView
#define kShadowAlpha 0.4f

//Blur for the shadow behind the PopoverView
#define kShadowBlur 3.f;

//Box gradient bg alpha
#define kBoxAlpha 1.0f

//Padding along top of screen to allow for any nav/status bars
#define kTopMargin 50.f

//margin along the left and right of the box
#define kHorizontalMargin 6.f

//padding along top of icons/images
#define kImageTopPadding 1.f

//padding along bottom of icons/images
#define kImageBottomPadding 1.f


// DIVIDERS BETWEEN VIEWS

//Bool that turns off/on the dividers
#define kShowDividersBetweenViews YES

//color for the divider fill
//#define kDividerColor  [UIColor colorWithPatternImage:[UIImage imageNamed:@"skipdivider"]]
#define kDividerColor  [UIColor grayColor]

// BACKGROUND GRADIENT

//bottom color white in gradient bg
#define kGradientBottomColor [UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:227.0/255.0 alpha:kBoxAlpha]

//top color white value in gradient bg
#define kGradientTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha]


// TITLE GRADIENT

//bool that turns off/on title gradient
#define kDrawTitleGradient YES

//bottom color white value in title gradient bg
#define kGradientTitleBottomColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:kBoxAlpha]

//top color white value in title gradient bg
#define kGradientTitleTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha]

// FONTS

//normal text font
#define kTextFont [UIFont fontWithName:@"DynoRegular" size:17.f]

//normal text color
#define kTextColor [UIColor whiteColor]
// highlighted text color
//#define kTextHighlightColor [UIColor colorWithRed:0.098 green:0.102 blue:0.106 alpha:1.000]
#define kTextHighlightColor [UIColor grayColor]
//normal text alignment
#define kTextAlignment NSTextAlignmentLeft

//title font
#define kTitleFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.f]

//title text color
#define kTitleColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]


// BORDER

//bool that turns off/on the border
#define kDrawBorder YES

//border color
#define kBorderColor [UIColor colorWithRed:122.0/255.0 green:127.0/255.0 blue:133.0/255.0 alpha:1]

//border width
#define kBorderWidth 1.0f