//
//  ThreadManager.h
//  iCat
//
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface ThreadManager : NSObject {

	int mQueryResponseTag;
	NSThread *aThread;
}


@property int mQueryResponseTag;

+ (ThreadManager *) getInstance;
//ThreadManager is a singleton class so this method creates the class instance if it not created else return the class instance.

- (void) makeRequest: (int) requestType : (NSString*) requestURL :(NSData*)postData;
//This method triggers network manger to makes the network request with given URL and request Type.

-(NSString*) urlEncode :(NSString *)connection_url;

@end
