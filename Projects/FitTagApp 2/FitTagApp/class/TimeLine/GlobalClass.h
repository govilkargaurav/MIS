//
//  GlobalClass.h
//  FitTag
//
//  Created by apple on 3/16/13.
//
//

#import <Foundation/Foundation.h>
#import "LORichTextLabel.h"
#import "LORichTextLabelStyle.h"
#import <MediaPlayer/MediaPlayer.h>
@interface GlobalClass : NSObject

extern BOOL IsLiked;

extern BOOL IsTimeline;
extern LORichTextLabel *lblattheRate;
extern LORichTextLabelStyle *richTextLbl;
extern LORichTextLabel *lbluserLikeNameButton;
//extern MPMoviePlayerController *moviePlayer1Global;
extern NSString *stringWithNIBLoad;
@end
