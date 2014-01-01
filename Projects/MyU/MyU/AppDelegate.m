//
//  AppDelegate.m
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MyAppManager.h"
#import "DBManager.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>
#import "NSData+base64.h"
#import "NSString+MD5.h"
#import "GlobalVariables.h"
//#import "RageIAPHelper.h"


NSError *error = nil;

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_OFF;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

@interface AppDelegate()
- (void)setupStream;
- (void)teardownStream;
- (void)goOnline;
- (void)goOffline;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageArchiving;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize strCurrentUserId;

- (void)dealloc
{
	[self teardownStream];
}


+(AppDelegate *)sharedInstance
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [self setupStream];
    [[MyAppManager sharedManager] customiseAppereance];
    [[DBManager sharedManager]createEditableCopyOfSQLIteIfNeeded];
    if (iOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }

    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    navController.navigationBar.hidden=YES;
    self.window.rootViewController =navController;
    UIImageView *imgV = [[UIImageView alloc]init];
    [imgV setFrame:CGRectMake(0, 0, 320, 480+iPhone5ExHeight)];
    [imgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg.png"]]];
    [self.window addSubview:imgV];
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return NO;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"devtkn register...%@",deviceToken);

    NSString *strDeviceToken = [[[[[deviceToken description]stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString:@" " withString: @""]copy];
    [[NSUserDefaults standardUserDefaults]setValue:strDeviceToken forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [[MyAppManager sharedManager] updatenotificationbadge];
//    
//    NSLog(@"%@",userInfo);
//    
//    if ([[[userInfo objectForKey:@"aps"] valueForKey:@"notification_type"] isEqualToString:@"private_mes"]) {
//        isNotificationChat = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_RECEIVED" object:nil userInfo:[userInfo valueForKey:@"aps"]];
//    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did fail to register...%@",error.description);
}

#pragma mark - DEFAULT METHODS
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}




- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_messageArchive
{
	return [xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    
    //For Storage Archive Messages on client
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchiving setClientSideMessageArchivingOnly:YES];
    
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    [xmppMessageArchiving activate:xmppStream];
    
    
    // Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMessageArchiving  addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:HOST_NAME];
    [xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
    [xmppMessageArchiving removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
    [xmppMessageArchiving deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
    xmppMessageArchiving = nil;
    xmppMessageArchivingCoreDataStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyJID"];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyPassword"];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
    //myJID = @"kiran@openxcell.info";
    //myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			//DDLogVerbose(@"KeepAliveHandler");
			//Do other keep alive stuff here.
		}];
	}
    
    __block UIBackgroundTaskIdentifier bgTask = 0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    [app endBackgroundTask:bgTask]; bgTask = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self disconnect];
	[[self xmppvCardTempModule] removeDelegate:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:DOMAIN_NAME])
		{
			if ([virtualDomain isEqualToString:DOMAIN_NAME])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	
	
	if ([IsRegestration isEqualToString:@"YES"])
	{
        [self Registration];
        
	}else{
        
        [self LoginInApp];
    }
}


-(void)LoginInApp{
    
    isXmppConnected = YES;
	NSError *error = nil;
    if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

-(void)Registration{
    
    isXmppConnected = YES;
	
	NSError *error = nil;
    if (![[self xmppStream] registerWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    kGRAlert(@"oops ! It seems that this username Or password having some problem to register with chatting server. Though you are registered successfully with application. Please conntect to admin for more details. ");
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	///DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    if([iq isResultIQ])
    {
        if([iq elementForName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"])
        {
            NSXMLElement *query = [iq childElement];
            NSArray *items = [query children];
            for(NSXMLElement *item in items)
            {
                NSError *error = [[NSError alloc] init];
                NSXMLElement *sendQuery = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='http://jabber.org/protocol/disco#items'/>" error:&error];
                
                XMPPIQ *sendIQ = [XMPPIQ iqWithType:@"get" to:[XMPPJID jidWithString:[item attributeStringValueForName:@"jid"]] elementID:[xmppStream generateUUID] child:sendQuery];
                [xmppStream sendElement:sendIQ];
            }
        }else if([iq elementForName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"])
        {
            NSXMLElement *query = [iq childElement];
            NSXMLElement *identity = [query elementForName:@"identity"];
            if([[identity attributeStringValueForName:@"category"] isEqualToString:@"conference"])
            {
                NSLog(@"%@",[identity attributeStringValueForName:@"category"]) ;
            }
        }
    }
    return YES;
}
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *str =  [message attributeStringValueForName:@"from"];
    NSString *postuser_profilepic = [message attributeStringValueForName:@"postuser_profilepic"];
    NSString *post_timestamp = [message attributeStringValueForName:@"post_timestamp"];
    NSString *postuser_id = [message attributeStringValueForName:@"postuser_id"];
    NSString *postuser_name = [message attributeStringValueForName:@"postuser_name"];
    NSString *post_type = [message attributeStringValueForName:@"post_type"];
    NSString *posted_image = [message attributeStringValueForName:@"posted_image"];
    NSString *post_image_height = [message attributeStringValueForName:@"post_image_height"];
    NSString *post_image_width = [message attributeStringValueForName:@"post_image_width"];
    
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:body,@"XMPPMessage",str,@"XMPPStream",postuser_profilepic,@"postuser_profilepic",post_timestamp,@"post_timestamp",postuser_id,@"postuser_id",postuser_name,@"postuser_name",post_type,@"post_type",posted_image,@"posted_image",post_image_height,@"post_image_height",post_image_width,@"post_image_width",nil];
    
    if ((ISFirstTimeInChatView==NO && isGroupChat) || (!isGroupChat))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
    }
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive && [strCurrentUserId isEqualToString:user.jidStr])
		{
            NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,@"XMPPMessage",sender,@"XMPPStream", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	//DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    
    if ([[presence attributeStringValueForName:@"mes"] isEqualToString:@"up"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TYPINGSHOW" object:nil userInfo:[NSDictionary dictionaryWithObject:[presence attributeStringValueForName:@"from"] forKey:@"from"]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TYPINGHIDE" object:nil userInfo:[NSDictionary dictionaryWithObject:[presence attributeStringValueForName:@"from"] forKey:@"from"]];
    }
    
//    for(NSXMLElement *item in items)
//    {
//        NSString *str = [item attributeForName:@"mes"];
//    }
    
//    NSXMLElement *x = [presence elementForName:@"presence" xmlns:@"from"];
//    for (NSXMLElement *status in [x elementsForName:@"mes"])
//    {
//        switch ([status attributeIntValueForName:@"mes"])
//        {
//                NSLog(@"%@",status);
//                //case 201: [self notifyRoomCreationOk:room];
//        }
//    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		//DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
}
@end
