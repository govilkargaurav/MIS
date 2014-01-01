//
//  MTStatusBarOverlay.m
//
//  Created by Matthias Tretter on 27.09.10.
//  Copyright (c) 2009-2011  Matthias Tretter, @myell0w. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Credits go to:
// -------------------------------
// http://stackoverflow.com/questions/2833724/adding-view-on-statusbar-in-iphone
// http://www.cocoabyss.com/uikit/custom-status-bar-ios/
// @reederapp for inspiration
// -------------------------------

#import <Foundation/Foundation.h>


//===========================================================
#pragma mark -
#pragma mark Definitions and Types
//===========================================================

// Animation that happens, when the user touches the status bar overlay
typedef enum MTStatusBarOverlayAnimation {
	MTStatusBarOverlayAnimationNone,      // nothing happens
	MTStatusBarOverlayAnimationShrink,    // the status bar shrinks to the right side and only shows the activity indicator
	MTStatusBarOverlayAnimationFallDown   // the status bar falls down and displays more information
} MTStatusBarOverlayAnimation;


// Mode of the detail view
typedef enum MTDetailViewMode {
	MTDetailViewModeHistory,			// History of messages is recorded and displayed in detailView
	MTDetailViewModeDetailText,			// a text can be displayed easily
	MTDetailViewModeCustom				// the detailView can be customized in the way the developer wants
} MTDetailViewMode;

// indicates the type of a message
typedef enum MTMessageType {
	MTMessageTypeActivity,				// shows actvity indicator
	MTMessageTypeFinish,				// shows checkmark
	MTMessageTypeError					// shows error-mark
} MTMessageType;


// keys used in the dictionary-representation of a status message
#define kMTStatusBarOverlayMessageKey			@"MessageText"
#define kMTStatusBarOverlayMessageTypeKey		@"MessageType"
#define kMTStatusBarOverlayDurationKey			@"MessageDuration"
#define kMTStatusBarOverlayAnimationKey			@"MessageAnimation"
#define kMTStatusBarOverlayImmediateKey			@"MessageImmediate"

// keys used for saving state to NSUserDefaults
#define kMTStatusBarOverlayStateShrinked        @"kMTStatusBarOverlayStateShrinked"


// forward-declaration of delegate-protocol
@protocol MTStatusBarOverlayDelegate;


//===========================================================
#pragma mark -
#pragma mark MTStatusBarOverlay Interface
//===========================================================

/**
 This class provides an overlay over the iOS Status Bar that can display information
 and perform an animation when you touch it:
 
 it can either shrink and only overlap the battery-icon (like in Reeder) or it can display
 a detail-view that shows additional information. You can show a history of all the previous
 messages for free by setting historyEnabled to YES
 */
@interface MTStatusBarOverlay : UIWindow <UITableViewDataSource> 

// the view that holds all the components of the overlay (except for the detailView)
@property (nonatomic, strong) UIView *backgroundView;
// the detailView is shown when animation is set to "FallDown"
@property (nonatomic, strong) UIView *detailView;
// the current progress
@property (nonatomic, assign) double progress;
// the frame of the status bar when animation is set to "Shrink" and it is shrinked
@property (nonatomic, assign) CGRect smallFrame;
// the current active animation
@property (nonatomic, assign) MTStatusBarOverlayAnimation animation;
// the label that holds the finished-indicator (either a checkmark, or a error-sign per default)
@property (nonatomic, strong) UILabel *finishedLabel;
// if this flag is set to YES, neither activityIndicator nor finishedLabel are shown
@property (nonatomic, assign) BOOL hidesActivity;
// the image used when the Status Bar Style is Default
@property (nonatomic, strong) UIImage *defaultStatusBarImage;
// the image used when the Status Bar Style is Default and the Overlay is shrinked
@property (nonatomic, strong) UIImage *defaultStatusBarImageShrinked;
// detect if status bar is currently shrinked
@property (nonatomic, readonly, getter=isShrinked) BOOL shrinked;
// detect if detailView is currently hidden
@property (nonatomic, readonly, getter=isDetailViewHidden) BOOL detailViewHidden;
// all messages that were displayed since the last finish-call
@property (nonatomic, strong, readonly) NSMutableArray *messageHistory;
// DEPRECATED: enable/disable history-tracking of messages
@property (nonatomic, assign, getter=isHistoryEnabled) BOOL historyEnabled;
// the last message that was visible
@property (nonatomic, copy) NSString *lastPostedMessage;
// determines if immediate messages in the queue get removed or stay in the queue, when a new immediate message gets posted
@property (nonatomic, assign) BOOL canRemoveImmediateMessagesFromQueue;
// the mode of the detailView
@property (nonatomic, assign) MTDetailViewMode detailViewMode;
// the text displayed in the detailView (alternative to history)
@property (nonatomic, copy) NSString *detailText;
// the delegate of the overlay
@property (nonatomic, unsafe_unretained) id<MTStatusBarOverlayDelegate> delegate;
@property(nonatomic, strong) UIColor *customTextColor;
//===========================================================
#pragma mark -
#pragma mark Class Methods
//===========================================================

// Singleton Instance
+ (MTStatusBarOverlay *)sharedInstance;
+ (MTStatusBarOverlay *)sharedOverlay;

//===========================================================
#pragma mark -
#pragma mark Instance Methods
//===========================================================

// for customizing appearance, automatically disabled userInteractionEnabled on view
- (void)addSubviewToBackgroundView:(UIView *)view;
- (void)addSubviewToBackgroundView:(UIView *)view atIndex:(NSInteger)index;

// Method to re-post a cleared message
- (void)postMessageDictionary:(NSDictionary *)messageDictionary;

// shows an activity indicator and the given message
- (void)postMessage:(NSString *)message;
- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
- (void)postMessage:(NSString *)message animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateMessage:(NSString *)message animated:(BOOL)animated;
- (void)postImmediateMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postImmediateMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// shows a checkmark instead of the activity indicator and hides the status bar after the specified duration
- (void)postFinishMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postFinishMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateFinishMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// shows a error-sign instead of the activity indicator and hides the status bar after the specified duration
- (void)postErrorMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postErrorMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateErrorMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// hides the status bar overlay and resets it
- (void)hide;
// hides the status bar overlay but doesn't reset it's values
// this is useful if e.g. you have a screen where you don't have
// a status bar, but the other screens have one
// then you can hide it temporary and show it again afterwards
- (void)hideTemporary;
// this shows the status bar overlay, if there is text to show
- (void)show;

// saves the state in NSUserDefaults and synchronizes them
- (void)saveState;
- (void)saveStateSynchronized:(BOOL)synchronizeAtEnd;
// restores the state from NSUserDefaults
- (void)restoreState;

@end



//===========================================================
#pragma mark -
#pragma mark Delegate Protocol
//===========================================================

@protocol MTStatusBarOverlayDelegate <NSObject>
@optional
// is called, when a gesture on the overlay is recognized
- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer;
// is called when the status bar overlay gets hidden
- (void)statusBarOverlayDidHide;
// is called, when the status bar overlay changed it's displayed message from one message to another
- (void)statusBarOverlayDidSwitchFromOldMessage:(NSString *)oldMessage toNewMessage:(NSString *)newMessage;
// is called when an immediate message gets posted and therefore messages in the queue get lost
// it tells the delegate the lost messages and the delegate can then enqueue the messages again
- (void)statusBarOverlayDidClearMessageQueue:(NSArray *)messageQueue;
@end


/*
 Read Me
 =====================
 
 **If you use MTStatusBarOverlay in your app, please drop me a line so that I can add your app here!**
 
 UIStatusBarStyleDefault (left: full size, right: shrinked)
 
 ![Default style](https://img.skitch.com/20101223-r1ddre3u4sjmn4htkqw3bhp84j.jpg "Default style")
 
 Description
 -----------------
 
 This class provides a custom iOS (iPhone + iPad) status bar overlay window known from Apps like Reeder, Google Mobile App or Evernote.
 It currently supports touch-handling, queuing of messages, delegation as well as three different animation modes:
 
 * MTStatusBarOverlayAnimationShrink: When the user touches the overlay the overlay shrinks and only covers the battery-icon on the right side
 * MTStatusBarOverlayAnimationFallDown: When the user touches the overlay a detail view falls down where additional information can be displayed. You can get a history of all your displayed messages for free by enabling historyTracking!
 * MTStatusBarOverlayAnimationNone: Nothing happens, when the user touches the overlay
 
 MTStatusBarOverlay currently fully supports two different status bar styles, which also can be changed in your app (MTStatusBarOverlay will adopt the style and will be updated the next time you show it):
 
 * UIStatusBarStyleDefault
 * UIStatusBarStyleBlackOpaque
 
 Usage
 ------------------
 
 You can use the custom status bar like this:
 
 MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
 overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
 overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
 overlay.delegate = self;
 overlay.progress = 0.0;
 [overlay postMessage:@"Following @myell0w on Twitter…"];
 overlay.progress = 0.1;
 // ...
 [overlay postMessage:@"Following myell0w on Github…" animated:NO];
 overlay.progress = 0.5;
 // ...
 [overlay postImmediateFinishMessage:@"Following was a good idea!" duration:2.0 animated:YES];
 overlay.progress = 1.0;
 
 
 Adding MTStatusBarOverlay to your project
 ------------------
 MTStatusBarOverlay is compiled as a static library. You have two options for integrating it into you own project, after cloning the MTStatusBarOverlay git repository with the terminal-command: `git clone git://github.com/myell0w/MTStatusBarOverlay.git`
 Since MTStatusBarOverlay now uses ARC, you have to add "-fobjc-arc" to "Other Linker Flags" of your project, If you are using Xcode 4.2 or up with the iOS 5.0 SDK on a non-ARC target.
 
 #### First option: copy files
 1. Just copy over the files MTStatusBarOverlay.h and MTStatusBarOverlay.m to your project.
 2. import "MTStatusBarOverlay.h" everywhere where you want to use it
 3. If you use MTStatusBarOverlay in a non-ARC project, add "-fobjc-arc" to the Compiler Flags of MTStatusBarOverlay.m in your target's "Build Phases" tab under Compile Sources.
 4. If your project doesn't use ARC be sure to check out the introduction section of "Adding MTStatusBarOverlay to your project"
 5. There is no step 5 :)
 
 #### Second option: Xcode dependent project
 1. Locate the "MTStatusBarOverlay.xcodeproj" file and drag it onto the root of your Xcode project's "Groups and Files"  sidebar.  A dialog will appear -- make sure "Copy items" is unchecked and "Reference Type" is "Relative to Project" before clicking "Add".
 2. Add MTStatusBarOverlay as a direct dependency (Xcode 3) or target dependency (Xcode 4) of your target
 3. Drag libMTStatusBarOverlay.a onto the section 'Link Binary with Libraries' of your target
 4. Finally, you need to tell your project where to find the MTStatusBarOverlay-header. Open your "Project Settings" and go to the "Build" tab. Look for "Header Search Paths" and double-click it.  Add the relative path from your project's directory to the MTStatusBarOverlay-directory.
 5. If your project doesn't use ARC be sure to check out the introduction section of "Adding MTStatusBarOverlay to your project"
 6. You are good to go, just #import "MTStatusBarOverlay.h" everywhere where you want to use it.
 
 
 Known Limitations
 -----------------------
 * When using UIStatusBarStyleBlackTranslutient the overlay is black opaque
 * User interaction in detail view is not possible yet
 
 
 More Screenshots
 ------------------------
 
 UIStatusBarStyleBlackOpaque (left: activity indicator, right: finished-indicator)
 
 ![Black style](https://img.skitch.com/20101223-rj8s32db61cb29w7k3fbpahktg.jpg "Black style")
 
 UIStatusBarStyleDefault, Landscape
 
 ![Default style landscape](https://img.skitch.com/20101223-8ibm6egd7mu3fd8andgmtw9by5.jpg "Default style landscape")
 
 UIStatusBarStyleDefault, detail view visible
 
 ![History tracking:](https://img.skitch.com/20101226-b1k5hjbmfyepd2mh6nbdbgw6a4.jpg "History tracking")
 
 UIStatusBarStyleBlackOpaque, Progress visible
 
 ![History tracking:](https://img.skitch.com/20110223-rm4mjnn7w2yp4qeuactjfiiah5.png "History tracking")
 
 
 MonoTouch
 ------------------------
 There's also a port to MonoTouch available at [https://github.com/thecoachfr/StatusBarOverlayMonoTouch](https://github.com/thecoachfr/StatusBarOverlayMonoTouch)
 
 
 Apps using MTStatusBarOverlay
 ------------------------
 * [Öffnungszeiten Österreich](http://www.oeffnungszeitenapp.at/ "oeffnungszeitenapp.at")
 * GoDenmark
 * [Glide](http://www.glide.me "Glide - instant video messaging")
 * [Anytune](http://bit.ly/anytune-itunes-preview "Anytune")
 * [Nowplayer](http://itunes.apple.com/us/app/nowplayer/id438805892?mt=8&ls=1 "Nowplayer")
 * [Amano Media](http://www.amanomedia.at/ "Amano Media")
 * [EconTalk Companion](http://itunes.apple.com/us/app/econtalk-companion/id456671102?mt=8 "EconTalk Companion")
 * [Dropshop](http://itunes.apple.com/us/app/dropshop/id425751374?l=sv&ls=1&mt=8 "Dropshop")
 * lots of other Apps I don't know :)
 */
