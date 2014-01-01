//
//  AISAppDelegate.h
//  AIS
//
//  Created by apple  on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>

#import "BitConvert.h"
#import "DecodeAIVDM.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
@protocol wifiDelegate

-(void)didReceiveDataFile:(NSString*)fileName;
-(void)didConnectToServer;
-(void)didDisconnectToServer;

@end
@interface AISAppDelegate : NSObject <UIApplicationDelegate,AsyncSocketDelegate,CLLocationManagerDelegate> {

    NSDate *startDate;
	CFHostRef host;
	AsyncSocket *asyncSocket;
	NSMutableData *receivedData;
	NSMutableString *receivedString;
	id<wifiDelegate> _delegate;
    NSMutableDictionary *dicData;  
    NSMutableArray *arryMMSI;

    CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
    
    NSDateFormatter* formatter;
    
    CLLocation *deviceLocation;
    CLLocationManager *locManager;

    NSMutableArray *bit6dataAry;
    NSMutableDictionary *shipTypes;
    NSMutableArray *dataAry;
    
    NSString *SimData ;
    int simDataPosi;

}
@property (nonatomic,retain) CLLocation *deviceLocation;
@property (nonatomic,retain)CLLocationManager *locManager;

@property (nonatomic,retain) AsyncSocket *asyncSocket;
@property (nonatomic, retain) NSMutableDictionary *dicData;    
@property (nonatomic, retain) NSMutableArray *arryMMSI;

@property(nonatomic,retain) NSMutableArray *bit6dataAry;
@property (nonatomic,retain) NSMutableDictionary *shipTypes;
@property (nonatomic,retain) NSMutableArray *dataAry;


@property (nonatomic,assign)id<wifiDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(void)getInitializeBit6;

- (void)listInterfaces;
- (void)startDNSResolve;
-(void)disconnectFromSocket;

//-(void)getvalueOfTheString:(NSString*)value,...NS_REQUIRES_NIL_TERMINATION;

-(NSString*)getStringFromDate:(NSDate*)date;
-(NSDate*)getDateFromString:(NSString*)strDate;

-(NSString*)convertDMStoDD:(NSString*)DMSValue;
-(NSString*)convertDDtoDMS:(NSString*)DDValue;

-(NSString*)getTypeOfNMEAString:(NSString*)string;
-(BOOL)ValidateAIVDCheckSum:(NSString*)str lenght:(int)len;

-(void)showAlertForShip:(NSString*)MMSINumber withMessage:(NSString*)message;

//simulat data
-(void)startSimulationForData;
@end
