//
//  DAL+ImageMap.h
//  HuntingApp
//
//  Created by Habib Ali on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (ImageMap)

- (ImageMap *)createImageMapWithPicture:(Picture *)picture andImage:(UIImage *)image;
- (ImageMap *)getImageMapByURL:(NSString *)url;


@end
