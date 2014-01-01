//
//  MSMasterViewController.m
//  MSNavigationPaneViewController
//
//  Created by Eric Horacek on 11/20/12.
//  Copyright (c) 2012-2013 Monospace Ltd. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MSMasterViewController.h"
#import "FindALawyerViewController.h"
#import "RSSFeedParser.h"
#import "GlobalClass.h"
NSString * const MSMasterViewControllerCellReuseIdentifier = @"MSMasterViewControllerCellReuseIdentifier";

typedef NS_ENUM(NSUInteger, MSMasterViewControllerTableViewSectionType) {
    MSMasterViewControllerTableViewSectionTypeAppearanceTypes,
    MSMasterViewControllerTableViewSectionTypeControls,
    MSMasterViewControllerTableViewSectionTypeAbout,
    MSMasterViewControllerTableViewSectionTypeCount
};

@interface MSMasterViewController () <MSNavigationPaneViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
#if defined(STORYBOARD)
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
#else
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
#endif
@property (nonatomic, strong) NSDictionary *paneViewControllerAppearanceTypes;
@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;
@property (nonatomic, strong) NSDictionary *dictFeedType;
@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealBarButtonItem;

- (void)updateNavigationPaneForOpenDirection:(MSNavigationPaneOpenDirection)openDirection;
- (void)navigationPaneRevealBarButtonItemTapped:(id)sender;
- (void)navigationPaneStateBarButtonItemTapped:(id)sender;

@end

@implementation MSMasterViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tableView.backgroundColor= RGBCOLOR(74, 172, 27);
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationPaneViewController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationPaneRevealBarButtonItemTapped:) name:@"MSNavigationPaneOpenDirectionTop" object:nil];
    // Default to the "None" appearance type
    [self transitionToViewController:MSPaneViewControllerTypeAppearanceNone];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"FIRSTTIME"]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FIRSTTIME"];
        [self navigationPaneStateBarButtonItemTapped:nil];
        self.navigationPaneViewController.appearanceType=MSPaneViewControllerTypeAppearanceParallax;
    }
    
}

#pragma mark - MSMasterViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
        @(MSPaneViewControllerTypeAppearanceNone) : @"Home",
        @(MSPaneViewControllerTypeAppearanceParallax) : @"Black America Web :National News",
        @(MSPaneViewControllerTypeAppearanceZoom) : @"TheGrio :News",
        @(MSPaneViewControllerTypeAppearanceFade) : @"TheRoot :News",
        @(MSPaneViewControllerTypeControls) : @"Black Voices :News",
        @(MSPaneViewControllerTypeMonospace) : @"S.Legal Jurist :News"
    };
    
#if defined(STORYBOARD)
    self.paneViewControllerIdentifiers = @{
        @(MSPaneViewControllerTypeAppearanceNone) : @"PaneViewControllerAppearanceNone",
        @(MSPaneViewControllerTypeAppearanceParallax) : @"PaneViewControllerAppearanceParallax",
        @(MSPaneViewControllerTypeAppearanceZoom) : @"PaneViewControllerAppearanceZoom",
        @(MSPaneViewControllerTypeAppearanceFade) : @"PaneViewControllerAppearanceFade",
        @(MSPaneViewControllerTypeControls) : @"PaneViewControllerControls",
        @(MSPaneViewControllerTypeMonospace) : @"PaneViewControllerMonospace",
    };
#else
    self.paneViewControllerClasses = @{
        @(MSPaneViewControllerTypeAppearanceNone) : FindALawyerViewController.class,
        @(MSPaneViewControllerTypeAppearanceParallax) : RSSFeedParser.class,
        @(MSPaneViewControllerTypeAppearanceZoom) : RSSFeedParser.class,
        @(MSPaneViewControllerTypeAppearanceFade) : RSSFeedParser.class,
        @(MSPaneViewControllerTypeControls) : RSSFeedParser.class,
        @(MSPaneViewControllerTypeMonospace) : RSSFeedParser.class
    };
#endif
    
    self.paneViewControllerAppearanceTypes = @{
        @(MSPaneViewControllerTypeAppearanceNone) : @(MSNavigationPaneAppearanceTypeNone),
        @(MSPaneViewControllerTypeAppearanceParallax) : @(MSNavigationPaneAppearanceTypeParallax),
        @(MSPaneViewControllerTypeAppearanceZoom) : @(MSNavigationPaneAppearanceTypeZoom),
        @(MSPaneViewControllerTypeAppearanceFade) : @(MSNavigationPaneAppearanceTypeFade),
    };
    
    self.sectionTitles = @{
        @(MSMasterViewControllerTableViewSectionTypeAppearanceTypes) : @"Appearance Types",
        @(MSMasterViewControllerTableViewSectionTypeControls) : @"Controls",
        @(MSMasterViewControllerTableViewSectionTypeAbout) : @"About",
    };
    
    self.tableViewSectionBreaks = @[
        @(MSPaneViewControllerTypeControls),
        @(MSPaneViewControllerTypeMonospace),
        @(MSPaneViewControllerTypeCount)
    ];
    
    self.dictFeedType = @{
                          @(MSPaneViewControllerTypeAppearanceNone) : @"1",
                          @(MSPaneViewControllerTypeAppearanceParallax) : @"2",
                          @(MSPaneViewControllerTypeAppearanceZoom) : @"3",
                          @(MSPaneViewControllerTypeAppearanceFade) : @"4",
                          @(MSPaneViewControllerTypeControls) : @"5",
                          @(MSPaneViewControllerTypeMonospace) : @"6"
                        };
}

- (MSPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {

        
        paneViewControllerType = indexPath.row;
        strFeedType=self.dictFeedType[@(paneViewControllerType)];
        
    } else {
        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    NSAssert(paneViewControllerType < MSPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.navigationPaneViewController.paneViewController != nil;
    
#if defined(STORYBOARD)
    UIViewController *paneViewController = [self.navigationPaneViewController.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
#else
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    NSParameterAssert([paneViewControllerClass isSubclassOfClass:UIViewController.class]);
    UIViewController *paneViewController;
    if ([paneViewControllerClass isSubclassOfClass:FindALawyerViewController.class]) {
        
        if (IS_IPHONE_5) {
            
            paneViewController = (UIViewController *)[[paneViewControllerClass alloc] initWithNibName:@"FindALawyerViewController" bundle:nil];
        }else{
            paneViewController = (UIViewController *)[[paneViewControllerClass alloc] initWithNibName:@"FindLawyer_iPhone4s" bundle:nil];
            
        }
        
    }else{
    paneViewController = (UIViewController *)[[paneViewControllerClass alloc] init];
    }
#endif
    
//    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
//    
//    self.paneRevealBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];
//    paneViewController.navigationItem.leftBarButtonItem = self.paneRevealBarButtonItem;
//    
//    self.paneStateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneStateBarButtonItemTapped:)];
//    paneViewController.navigationItem.rightBarButtonItem = self.paneStateBarButtonItem;

    //self.navigationController.navigationBarHidden=TRUE;
    // Update pane state button titles
    [self updateNavigationPaneForOpenDirection:self.navigationPaneViewController.openDirection];
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)updateNavigationPaneForOpenDirection:(MSNavigationPaneOpenDirection)openDirection
{
    if (openDirection == MSNavigationPaneOpenDirectionLeft) {
        self.paneStateBarButtonItem.title = @"Top Reveal";
        self.navigationPaneViewController.openStateRevealWidth = 265.0;
        self.navigationPaneViewController.paneViewSlideOffAnimationEnabled = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    } else {
        self.paneStateBarButtonItem.title = @"Left Reveal";
        self.navigationPaneViewController.openStateRevealWidth = self.tableView.contentSize.height;
        self.navigationPaneViewController.paneViewSlideOffAnimationEnabled = NO;
    }
}

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES completion:nil];
}

- (void)navigationPaneStateBarButtonItemTapped:(id)sender
{
    if (self.navigationPaneViewController.openDirection == MSNavigationPaneOpenDirectionLeft) {
        self.navigationPaneViewController.openDirection = MSNavigationPaneOpenDirectionTop;
    } else {
        //self.navigationPaneViewController.openDirection =  MSNavigationPaneOpenDirectionLeft;
        self.navigationPaneViewController.openDirection = MSNavigationPaneOpenDirectionTop;
    }
    [self updateNavigationPaneForOpenDirection:self.navigationPaneViewController.openDirection];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"                    EmPower News";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSMasterViewControllerCellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MSMasterViewControllerCellReuseIdentifier];
    }
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14.0];
    cell.textLabel.text = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    // Add a checkmark to the current pane type
    if (self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] && (self.navigationPaneViewController.appearanceType == [self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] unsignedIntegerValue])) {
        cell.textLabel.text = [NSString stringWithFormat:@"✓ %@", cell.textLabel.text];
    }
//    UIView *myView = [[UIView alloc] init];
//    //if (indexPath.row % 2) {
//        myView.backgroundColor = RGBCOLOR(74, 172, 27);
//    //} else {
//    //    myView.backgroundColor = [UIColor blackColor];
//    //}
//    cell.backgroundView = myView;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    if (self.paneViewControllerAppearanceTypes[@(paneViewControllerType)]) {
        self.navigationPaneViewController.appearanceType = [self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] unsignedIntegerValue];
        // Update row titles
        strFeedType =self.dictFeedType[@(paneViewControllerType)];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MSNavigationPaneViewControllerDelegate

- (void)navigationPaneViewController:(MSNavigationPaneViewController *)navigationPaneViewController didUpdateToPaneState:(MSNavigationPaneState)state
{
    // Ensure that the pane's table view can scroll to top correctly
    self.tableView.scrollsToTop = (state == MSNavigationPaneStateOpen);
}

@end
