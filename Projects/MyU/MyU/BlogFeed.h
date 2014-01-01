//
//  BlogFeed.h
//  MyU
//
//  Created by Vijay on 9/13/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogFeed : NSObject

@property (nonatomic,readwrite) NSInteger blog_id;
@property (nonatomic,copy) NSString *strCreatedTimeStamp;
@property (nonatomic,copy) NSString *strLikeCount;
@property (nonatomic,copy) NSString *strCommentCount;
@property (nonatomic,assign) BOOL canLike;
@property (nonatomic,assign) BOOL hasImage;
@property (nonatomic,assign) float img_width;
@property (nonatomic,assign) float img_height;
@property (nonatomic,readwrite) NSInteger cell_tag;

@property (nonatomic,assign) CGSize imgSize;
@property (nonatomic,copy) NSURL *urlBlur;
@property (nonatomic,copy) NSURL *urlHD;
@property (nonatomic,copy) NSURL *urlOriginal;
@property (nonatomic,copy) NSMutableAttributedString *attribFull;
@property (nonatomic,copy) NSMutableAttributedString *attribUsed;
@property (nonatomic,assign) float final_cell_height;
@property (nonatomic,assign) BOOL isUpdated;


@end
