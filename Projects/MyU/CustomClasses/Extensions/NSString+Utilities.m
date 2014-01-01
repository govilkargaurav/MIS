//
//  NSString+Utilities.m
//  Suvi
//
//  Created by Gagan Mishra on 2/20/13.
//
//

#import "NSString+Utilities.h"
#import "MyAppManager.h"

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

-(BOOL)isValidEmail
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0,[self length])];
    return (regExMatches == 0)?NO:YES;
}
-(NSString *)formattedTime
{
    float timediff=[[NSDate date] timeIntervalSince1970]-[self floatValue];
    
    if ((timediff<=0.0) || ([self floatValue]==0.0))
    {
        return @"0m";
    }
    else if(timediff<3600.0)
    {
        return [NSString stringWithFormat:@"%.fm",(timediff/60.0)];
    }
    else if(timediff<43200.0)
    {
        return [NSString stringWithFormat:@"%.fh",(timediff/3600.0)];
    }
    else if(timediff<302400.0)
    {
        return [NSString stringWithFormat:@"%.fd",(timediff/43200.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.fw",(timediff/302400.0)];
    }
}
-(NSMutableAttributedString *)attributedStringForHomeCellForFrame:(CGRect )theFrame andFont:(UIFont *)theFont andTag:(NSString *)theTag
{
    NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:self];
    [attrStrFull setFont:theFont];

    float theHeight=[[attrStrFull heightforAttributedStringWithWidth:theFrame.size.width]floatValue];
    
    if (theHeight<theFrame.size.height)
    {
        [attrStrFull setTextColor:[UIColor darkGrayColor]];
        return attrStrFull;
    }
    else
    {
        @try {
            int test = [self getSplitIndexWithString:self frame:theFrame andFont:theFont];
            NSString *trimmedString = [self substringToIndex:test];
            NSString *seeMoreString = @"Continue reading";
            trimmedString = [NSString stringWithFormat:@"%@\n%@", trimmedString, seeMoreString];
            
            NSMutableAttributedString *attrStr=[NSMutableAttributedString attributedStringWithString:trimmedString];
            [attrStr setFont:theFont];
            [attrStr setTextColor:[UIColor darkGrayColor]];
            [attrStr setLink:[NSURL URLWithString:theTag] range:NSMakeRange([trimmedString length]-[seeMoreString length],[seeMoreString length])];
            NSRange range = [trimmedString rangeOfString:seeMoreString];
            [attrStr setTextColor:kCustomGRBLColor range:range];
            
            return attrStr;
        }
        @catch (NSException *exception)
        {
            NSLog(@"The exc found....");
            [attrStrFull setTextColor:[UIColor darkGrayColor]];
            return attrStrFull;
        }
        @finally {
            
        }
    }
}
-(NSMutableAttributedString *)attributedStringForRateCellForFrame:(CGRect )theFrame andFont:(UIFont *)theFont andTag:(NSString *)theTag
{
    NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:self];
    [attrStrFull setFont:theFont];
    
    float theHeight=[[attrStrFull heightforAttributedStringWithWidth:theFrame.size.width]floatValue];
    
    if (theHeight<theFrame.size.height)
    {
        [attrStrFull setTextColor:[UIColor darkGrayColor]];
        return attrStrFull;
    }
    else
    {
        @try {
            int test = [self getSplitIndexWithString:self frame:theFrame andFont:theFont];
            NSString *trimmedString = [self substringToIndex:test];
            NSString *seeMoreString = @"Continue reading";
            trimmedString = [NSString stringWithFormat:@"%@\n%@", trimmedString, seeMoreString];
            NSMutableAttributedString *attrStr=[NSMutableAttributedString attributedStringWithString:trimmedString];
            [attrStr setFont:theFont];
            [attrStr setTextColor:[UIColor darkGrayColor]];
            [attrStr setLink:[NSURL URLWithString:theTag] range:NSMakeRange([trimmedString length]-[seeMoreString length],[seeMoreString length])];
            NSRange range = [trimmedString rangeOfString:seeMoreString];
            [attrStr setTextColor:kCustomGRBLColor range:range];
            
            return attrStr;
        }
        @catch (NSException *exception)
        {
            NSLog(@"The exc found....");
            [attrStrFull setTextColor:[UIColor darkGrayColor]];
            return attrStrFull;
        }
        @finally {
            
        }
    }
}

-(int)getSplitIndexWithString:(NSString *)str frame:(CGRect)frame andFont:(UIFont *)font
{
    int length = 1;
    int lastSpace = 1;
    NSString *cutText = [str substringToIndex:length];
    CGSize textSize = [cutText sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, frame.size.height + CGFLOAT_MAX)];
    textSize.height*=0.8333;
    while (textSize.height <= frame.size.height)
    {
        NSRange range = NSMakeRange(length, 1);
        if ([[str substringWithRange:range] isEqualToString:@" "])
        {
            lastSpace = length;
        }
        length++;
        cutText = [str substringToIndex:length];
        textSize = [cutText sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, frame.size.height + CGFLOAT_MAX)];
    }
    return lastSpace;
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
        return [[self stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
-(NSString *)convertToSmilies
{
    NSString *strSmilies=[[NSString alloc]initWithFormat:@"%@",self];
    strSmilies=[self stringByReplacingOccurrencesOfString:@" :P" withString:@" 😋"];
    strSmilies=[self stringByReplacingOccurrencesOfString:@" :(" withString:@" 😒"];
    strSmilies=[self stringByReplacingOccurrencesOfString:@" :)" withString:@" 😃"];
    
    
    return [self stringByReplacingOccurrencesOfString:@" :P" withString:@" 😋"];
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
