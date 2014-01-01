//
//  FLButton.h
//  HuntingApp
//
//  Created by Habib Ali on 8/27/12.
//  Copyright (c) 2012 folio3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "FLImageView.h"


@interface FLButton : UIButton<FLImageViewDelegate>
{
    FLImageView *imgView;
}

- (void)setImageWithURL:(NSString *)URL;
- (void)setImageWithProfile:(Profile *)profile;
- (void)setImageWithImage:(Picture *)picture;
- (void)setImageWithDataInBackGround:(NSData *)data;
- (void)setImageWithData:(NSData *)Data;

@end
