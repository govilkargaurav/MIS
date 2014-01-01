//
//  GlobalMethods.h
//  PianoApp_With_Migration
//
//  Created by Imac 2 on 9/12/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GlobalMethods : NSObject
+ (void)animateIncorrectPassword:(UIView*)viewname;
+(void)SetViewShadow:(UIView*)ViewName;
+(void)SetTfShadow:(UITextField*)tfName;
+(void)SetInsetToTextField:(UITextField*)tf;
+ (UIImage *)imageAtPath:(NSString *)path cache:(NSMutableDictionary *)cache ImageType:(NSString*)strImageType;
@end
