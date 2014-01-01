//
//  RadarView.h
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SetupView.h"
#import <MapKit/MapKit.h>
#import "AISAppDelegate.h"
#import "CLSMapview.h"
#import "RaderBackground.h"
#import "DetailVIew.h"
#import "parseCSV.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+Position.h"

@interface RadarView : UIViewController<MKMapViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,wifiDelegate> {

    CLLocationManager *locManager;
    RaderBackground *rader;
	IBOutlet UIScrollView *scrollV;
	MKMapView *mapV ;
	CLSMapview *map;
	float delta;
//	UIView *myView;
	NSMutableArray *targetTags;
	NSTimer *timer; 
	
	UILabel *distance1;
	UILabel *distance2;
	UILabel *distance3;
	UILabel *distance4;	
	float nmLenght;
    
	UIView *tmpView;
	double diffx;
	double diffy;
	int moving;
	NSDictionary *radarSets;
	AISAppDelegate *del;
    
    NSArray *distanceArray;
    int zoomlevel;
    
}
-(void)ClickSetup:(id)sender;
-(void)ClickBack:(id)sender;

-(void)setRaderView;

-(void)addSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree withMessage:(BOOL)flag;
-(void)moveSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree withMessage:(BOOL)flag;
 
//-(void)addSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree;
//-(void)moveSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree;
-(void)addCurrentPosition:(CGPoint)point withDegree:(int)degree;
-(void)moveCurrentPosition:(CGPoint)point withDegree:(int)degree;
-(void)addLinesToDirection:(UIView*)view1 ofMMSI:(int)MMSINo;
-(void)addLinesToCurrentToDirection:(UIView*)view1;

-(void)addBackgroundImage;
-(void)showDistanceLabels;
-(void)showZoomButtons;
-(CGPoint)convertPoint:(CGPoint)point;

-(void)removeSumViewFromScrollV;

@end
