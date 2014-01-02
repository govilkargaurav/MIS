//
//  GlobalMethods.h
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 3/14/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject

+(void)VerifyReceipt:(NSString *)receipt;
+(void)completePaymentTransaction:(NSDictionary *)receipt;
+(void)unsubscribeFromTrasection:(NSDictionary *)receipt;
@end
