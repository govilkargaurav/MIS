//
//  CreateChaalengeModel.h
//  FitTag
//
//  Created by Shivam on 3/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// This is a model class for create challenge information

@interface CreateChaalengeModel : NSObject{
    
}

@property(nonatomic,strong)NSString *strChallengeName;
@property(nonatomic,strong)NSString *strChallengeTags;
@property(nonatomic,strong)NSString *strLatitude;
@property(nonatomic,strong)NSString *strLongitude;
@property(nonatomic,strong)NSString *strChallengeLocation;
@property(nonatomic,strong)NSMutableData *teaserDataVideo;
@property(nonatomic,strong)NSMutableData *teaserDataImage;
@property(nonatomic,strong)NSMutableData *mediaDataImage;
@property(nonatomic,strong)NSMutableData *mediaDataVideo;
@property(nonatomic,strong)NSMutableArray *arrEquipment;
@property(nonatomic,strong)NSMutableArray *mutArrChallengeHashTags;
@property(nonatomic,strong)UIImage *thumbNail;

@end
