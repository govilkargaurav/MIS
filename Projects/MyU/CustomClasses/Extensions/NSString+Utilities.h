//
//  NSString+Utilities.h
//  Suvi
//
//  Created by Gagan Mishra on 2/20/13.
//
//

#import <Foundation/Foundation.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>

@interface NSString (Utilities)

-(NSString *)removeNull;
-(BOOL)isValidEmail;
-(NSString *)convertToSmilies;
-(NSString *)formattedTime;
-(NSMutableDictionary *)getDataFromFile;
- (NSString *)urlencode;
-(NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;
-(NSMutableAttributedString *)attributedStringForHomeCellForFrame:(CGRect )theFrame andFont:(UIFont *)theFont andTag:(NSString *)theTag;
-(NSMutableAttributedString *)attributedStringForRateCellForFrame:(CGRect )theFrame andFont:(UIFont *)theFont andTag:(NSString *)theTag;

@end
