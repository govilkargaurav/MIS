//
//  NSString+Utilities.h
//  Suvi
//
//  Created by Gagan Mishra on 2/20/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

-(NSString *)removeNull;
-(NSMutableDictionary *)getDataFromFile;
-(BOOL)removeFile;
-(NSString *)urlencode;
-(NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;
@end
