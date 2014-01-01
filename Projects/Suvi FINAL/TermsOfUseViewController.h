//
//  TermsOfUseViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsOfUseViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    IBOutlet UILabel *lblTitle;
}

@property(nonatomic,retain)NSString *strTitle;
@property(nonatomic,retain)NSString *strWebURL;

-(IBAction)btnbackclicked:(id)sender;

@end

/*
 Issue 1:
 Menu colors not matching
 • Music, location and photo lines match the menu colors. Ok
 • Video and Thoughts do not match menu colors.
 
-Changed the color for Video & Thought as per menu.
-And remained other color for profile pic change, birthday wishes and etc. as it was.
-Please send the RGB for those if any changes needed.
 
 Issue 2:
 Comment Screen:
 -Replaced as you suggested.
 
 Issue 3:
 Place: notice color and format
 -Replaced Navigation bar image and hidden the I'm with/at buttons as per design.
 
 Issue 4:
 Like, dislike and comment buttons
 In app vs. provided:
 • Currently, in app, when tapping like, dislike or comment it colors up for a second (while tapping) but then grays out light (as shown in the red circles).
 • As shown in the provided PSD, it is supposed to color up. See below (taken from dropbox PSDs)
 -THAT NEEDS WS & DATA CHANGES
 
 Issue 5:
 iPhone 4 signup/intro
 • In iPhone 5 works the images swipe only to the sides. Which is ok. But on iPhone 4 format, they can be moved all over the place. They should only move to the sides. As you see in the pics, they can be moved up and down in the screen.
 • Set them to only move sideways. As iphone4 screen is smaller, what should be visible to move sideways is the screen samples with the ok
 -Solved
 
 Issue 6:
 Double intro/welcome?
 • After signing up, all the intro images come up again. there is no need. That’s why they were now positioned at the beginning. (so the user can see what the up is about prior to signing up)
 • Once signed up, it goes to the feed directly. So, there is no “welcome to the club” and again “welcome to suvi” and all the intro...
 -Solved
 */
