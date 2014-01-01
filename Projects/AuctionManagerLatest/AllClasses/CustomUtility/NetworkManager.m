

#import "NetworkManager.h"
#import "BusyAgent.h"
#import "AlertManger.h"
#import "LoginListParser.h"
#import "GetVersionParser.h"
#import "RegisterParser.h"
#import "GetCountyListParser.h"
#import "TrusteesListParser.h"
#import "UpdatePropertyParser.h"
#import "PaymentInfoParser.h"
#import "PostPhotoParser.h"
#import "ChangePasswordParser.h"
#import "GetAuctionStatus.h"
#import "GetPropertyByStatusViewController.h"
#import "CheckInfoParser.h"
@implementation NetworkManager


- (void) setUrl:(NSString *) pUrl Type:(NSInteger)pReqType
{
	_URL = [[NSURL alloc] initWithString:pUrl];
	_requestType = pReqType;
}


-(void)myThreadMethod:(id)sender
{
	[self startHTTPConnection];
}


/*
 * This method initiates the request. Makes the request to the server.
 */
- (BOOL) startHTTPConnection
{
		
	
	NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:_URL];
    [[NSURLConnection alloc] initWithRequest:urlReq delegate:self];
	[[NSRunLoop currentRunLoop] run];	
	return TRUE;

}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)tempData 
{
	if(_responseData == nil)
	{
		_responseData = [[NSMutableData alloc] initWithCapacity:4096];	
	}
	[_responseData appendData:tempData];	
} 


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    ////NSLog(@"%@",[error description]);
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];



}

/*
 * This method invokes by the class when network finished with the loading of the request.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{ 	

    NSString *theXML = [[NSString alloc] initWithBytes: [_responseData mutableBytes] length:[_responseData length] encoding:NSISOLatin1StringEncoding];

    //NSLog(@"%@",theXML);
    
	if(_requestType==REQ_LOGIN_KEY)
	{
		LoginListParser *parser = [[LoginListParser alloc]init];
		[parser parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding]:REQ_LOGIN_KEY];
        
        
	}else if (_requestType==REQ_VERSION_KEY)
    {
        GetVersionParser *parser2 = [[GetVersionParser alloc]init];
		[parser2 parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding]:REQ_VERSION_KEY];
        
        
    }else if(_requestType==REQ_REGISTER_KEY)
    {
        
        RegisterParser *parser2 = [[RegisterParser alloc]init];
		[parser2 parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding]:REQ_REGISTER_KEY];
        

    }else if(_requestType==GET_COUNTY_LIST)
    {
        
        GetCountyListParser *parser2 = [[GetCountyListParser alloc]init];
		[parser2 parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding]:REQ_REGISTER_KEY];
        
        
    }else if(_requestType==GET_TRUSTEES_LIST)
    {
        
        TrusteesListParser *parser222 = [[TrusteesListParser alloc]init];
		[parser222 parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding]:GET_TRUSTEES_LIST];
        
        
    }else if (_requestType==REQ_UPDATE_PROPERTY){
        
        UpdatePropertyParser *parsersT=[[UpdatePropertyParser alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :REQ_UPDATE_PROPERTY];
        
        
    }else if (_requestType==POST_PAYMENT_LIST){
        
        PaymentInfoParser *parsersT=[[PaymentInfoParser alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :POST_PAYMENT_LIST];
        
        
    }else if (_requestType==POST_PHOTO_LIST){
        
        PostPhotoParser *parsersT=[[PostPhotoParser alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :POST_PHOTO_LIST];
        
        
    }else if (_requestType==POST_CHANGE_PASSWORD){
        
        ChangePasswordParser *parsersT=[[ChangePasswordParser alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :POST_CHANGE_PASSWORD];
        
        
    }else if (_requestType==GET_AUCTION_STATUS){
        
        GetAuctionStatus *parsersT=[[GetAuctionStatus alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :GET_AUCTION_STATUS];
        
        
    }else if (_requestType==GET_PROPERTY_BY_STATUS){
        
        GetPropertyByStatusViewController *parsersT=[[GetPropertyByStatusViewController alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :GET_PROPERTY_BY_STATUS];
        
    }else if (_requestType==GET_CHECK_AMOUNT_BY_NUMBER){
        
        CheckInfoParser *parsersT=[[CheckInfoParser alloc] init];
        [parsersT parseData:[theXML dataUsingEncoding:NSUTF8StringEncoding] :GET_CHECK_AMOUNT_BY_NUMBER];
        
    }

}

@end
