//
//  DecodeAIVDM.m
//  AIS
//
//  Created by apple on 4/5/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "DecodeAIVDM.h"


@implementation DecodeAIVDM
-(id)initWithAIVDM:(NSString*)string{
	self = [super init];
	if (self) {
		BitConvert *con;
		NSString *st;
		NSMutableArray *ar = (NSMutableArray*)[string componentsSeparatedByString:@","];

		if ([self checkSum:string lenght:[string length]] == TRUE) {

			if ([ar count] >= 6) {				
				if ([[ar objectAtIndex:1] intValue] == 2) {
					if ([[ar objectAtIndex:2] intValue] == 1) {
						[[NSUserDefaults standardUserDefaults] setObject:[ar objectAtIndex:5] forKey:@"str"];
						[[NSUserDefaults standardUserDefaults] synchronize];
						return nil;
					}else if([[ar objectAtIndex:2] intValue] == 2){
						st= [[NSString alloc] initWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"str"],[ar objectAtIndex:5]];
					}					
				}else {
					st = [[NSString alloc] initWithFormat:@"%@",[ar objectAtIndex:5]];
				}
				//st = @"1P000Oh1IT1svTP2r:43grwb05q4";
				
				//if ([self checkSum:string lenght:[string length]]){
					con= [[BitConvert alloc] initWithStringData:st];
				//}
			}
		}
	}
	return self;
}


-(NSString*)GetCheckSumForString:(NSString*)str{
	int len = [str length];
	NSString *str1 = [str substringFromIndex:1];
	char *a = (char*)[str1 UTF8String];
    
    for(int i = 0 ; i < len-1; i++)
    {
        a[i+1] = a[i] ^ a[i+1];
    }
	
	NSString *result = [NSString stringWithFormat:@"%x",(unsigned int) a[len-1]];
	result = [result uppercaseString];
	if ([result length] == 1) {
		result= [NSString stringWithFormat:@"0%@",result];
	}
	
	return result;
}

-(BOOL)checkSum:(NSString*)str lenght:(int)len
{
    BOOL value;

        
        NSArray *arry = [str componentsSeparatedByString:@"*"];    
        if ([arry count] > 1) {
            
            NSString *str1 = [arry objectAtIndex:0];
            str1 = [str1 substringFromIndex:1];
            char *a = (char*)[str1 UTF8String];
            
            for(int i = 0 ; i < len-1; i++)
            {
                a[i+1] = a[i] ^ a[i+1];
            }
            //   NSLog(@"XOR Char :: %x",(unsigned int)a[len-1]);
            NSString *result;
            NSString *actual;
            @try {
              result  = [NSString stringWithFormat:@"%x",(unsigned int) a[len-1]];
              actual  = [NSString stringWithFormat:@"%@",[arry objectAtIndex:1]];

            }
            @catch (NSException *exception) {
                    
                    NSLog(@"Error :: %@",[exception description]);        
            }
        
            result = [result uppercaseString];
            actual = [actual stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([result length] == 1) {
                result= [NSString stringWithFormat:@"0%@",result];
            }
            
            if([result isEqualToString:actual]){
                value =  TRUE;
            }else {
                value =  FALSE;
            }
        }	
        return value;
}
@end
