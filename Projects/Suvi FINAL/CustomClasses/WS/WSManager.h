//
//  WSManager.h
//  Suvi
//
//  Created by Gagan on 6/4/13.
//
//

#import <Foundation/Foundation.h>

@interface WSManager : NSObject<NSURLConnectionDelegate>
{
    SEL successSelector;
    SEL failureSelector;
    NSObject *callBackObject;
    NSURLConnection *connection;
    BOOL shouldSendRespond;
    NSMutableURLRequest *postRequest;
    BOOL isSocialSharing;
}

@property(nonatomic,strong) NSMutableData *webData;
@property(nonatomic,strong) NSString *strFeedId;

-(id)initWithWSData:(NSDictionary *)dictWS withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject shouldRespond:(BOOL)shouldRespond;
-(void)startRequest;
-(void)stopRequest;

@end
