//
//  BusyAgent.h
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/12/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import <Foundation/Foundation.h>

/**
 * Simple class to show a gray screen overlay above all view
 */
@interface BackView : NSObject {
	UIView* view;
}

/**
 * call this function. Pass yes if want to set busy mode.
 * pass No if your done with your busy state
 */
- (void) addBackView:(UIView *)_view ;
- (void) removeBackView;
/**
 * Better use these methods
 */


/**
 * Messed up with updateBusyState? call this method to remove busy state
 */


/**
 * Factory method
 */
+ (BackView*)defaultAgent;

@end
