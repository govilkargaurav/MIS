//
//  NSMutableDictionary+Utilities.m
//  Suvi
//
//  Created by Gagan Mishra on 2/20/13.
//
//

#import "NSMutableDictionary+Utilities.h"

@implementation NSMutableDictionary (Utilities)

-(void)writeToFileName:(NSString *)strFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:strFileName];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    if([jsonData writeToFile:filePath atomically:YES])
    {
    }
    else
    {
    }
}

@end
