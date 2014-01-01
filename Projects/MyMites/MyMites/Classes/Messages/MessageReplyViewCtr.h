//
//  MessageReplyViewCtr.h
//  MyMites
//
//  Created by apple on 2/14/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MessageReplyViewCtr : UIViewController <UITextViewDelegate>
{
    IBOutlet UITextView *txtMessage;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryDicResult;
    
    NSString *strFromMessageID,*strToMessageID;
    NSString *strSendMsgID;
}
@property(nonatomic,strong)NSString *strToMessageID,*strFromMessageID;
@end
