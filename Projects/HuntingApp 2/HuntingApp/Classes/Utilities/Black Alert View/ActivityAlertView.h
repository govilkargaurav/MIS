//
//  ActivityAlertView.h
//  Elanguide iPad
//
//  Created by Folio 3 on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/* 
 * Extended UIAlertView to show UIActivityIndicator with custom background color
 */

#import <UIKit/UIKit.h>

@interface ActivityAlertView : UIAlertView
{
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

+ (void) setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor *) stroke;
- (void) close;

@end
