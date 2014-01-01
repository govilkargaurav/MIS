//
//  NSString+Utilities.m
//  Suvi
//
//  Created by Gagan Mishra on 2/20/13.
//
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)urlencode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


-(NSString *)removeNull
{
    if (![self isKindOfClass:[NSString class]])
    {
        return self;
    }
    
    if (!self)
    {
        return @"";
    }
    else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"<null>"] || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"(null)"])
    {
        return @"";
    }
    else
    {
        //return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        return [[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\\'" withString:@"\'"]stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    }
}

-(NSMutableDictionary *)getDataFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSMutableDictionary *dictFileData=[[NSMutableDictionary alloc]init];
    
    if (fileExists)
    {
        [dictFileData setObject:@"1" forKey:@"success"];
        NSError *error;
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSMutableDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:&error];
        [dictFileData addEntriesFromDictionary:dictJson];
    }
    else
    {
        [dictFileData setObject:@"0" forKey:@"success"];
    }
    
    return dictFileData;
}
-(BOOL)removeFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self];
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error])
        {
        return YES;
        }
    else
        {
        return NO;
        }
}
-(NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end
{
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

@end
