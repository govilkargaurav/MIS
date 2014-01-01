

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject {
	
	NSURL *_URL;
	NSInteger _requestType;
	NSData* _postData;
	NSMutableData *_responseData;
}


//This method is used to start the http connection to server.
- (BOOL) startHTTPConnection;

//This method is used to set the url and request type.
- (void) setUrl:(NSString *) pUrl Type:(NSInteger) pReqType;


@end
