//
//  ImageViewURL.h
//  LibXml2P
//
//  Created by DIGICORP on 16/03/10.
//  Copyright 2010 DIGICORP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageViewURL : NSObject {
	NSURL *strUrl;
	NSMutableData *myWebData;
	UIImageView *imgV;
	UIImage *img;
   // UIButton *btn;
}
@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) UIImageView *imgV;
@property(nonatomic,strong) NSURL *strUrl;
@end
