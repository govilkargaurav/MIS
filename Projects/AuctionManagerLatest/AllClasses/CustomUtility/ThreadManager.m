//
//  ThreadManager.m


#import "ThreadManager.h"
#import "NetworkManager.h"

static ThreadManager* ownInstance = nil;


@implementation ThreadManager
@synthesize mQueryResponseTag;


- (id)init{
	@synchronized(self){
		if(ownInstance == nil){
			ownInstance = [super init];		
			
			
			
			return ownInstance;
		}
	}
	return nil;
}

+ (ThreadManager *) getInstance{
	
	@synchronized(self){
		if(ownInstance == nil){
			[[self alloc] init];
			
		}
	}
	return ownInstance;
}



//This method triggers network manger to makes the network request with given URL and request Type.
- (void) makeRequest: (int) requestType : (NSString*) requestURL :(NSData*)postData
{
	NetworkManager *instance = [[NetworkManager alloc] init];
	[instance setUrl:requestURL Type:requestType];
	//////NSLog(@"URL-->%@",postData);
	[NSThread detachNewThreadSelector:@selector(myThreadMethod:) toTarget:instance withObject:nil];
	
	
}


-(NSString*) urlEncode :(NSString *)connection_url{
	
	if(connection_url == NULL){
		return NULL;
	}
	
	int index = 0;
	
	int size = [connection_url length];
	
	NSMutableString* encodedSting = [[NSMutableString alloc] initWithCapacity:size];
	
	char c;
	for(;index < size ;index++){
		c =[connection_url characterAtIndex:index];
		
		if (
			(c >= ',' && c <= ';')
			|| (c >= 'A' && c <= 'Z')
			|| (c >= 'a' && c <= 'z')
			|| c == '_'
			|| c == '?'
			|| c == '&'
			|| c == '=') {
			
			[encodedSting appendFormat:@"%c",c];
			
			
		} else {
			[encodedSting appendString:@"%"];
			int x = (int)c;
			
			[encodedSting appendFormat:@"%02x", x];
			
		}
		
	}
	
	
	return encodedSting ;
}




//


@end
