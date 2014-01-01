//
//  DetailVIew.h
//  AIS
//
//  Created by apple on 4/16/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AISAppDelegate.h"

@interface DetailVIew : UIView <UITableViewDelegate,UITableViewDataSource>{

	IBOutlet UILabel *MMSI;
	IBOutlet UILabel *COG;
	IBOutlet UILabel *SOG;
	IBOutlet UILabel *CallSign;
	IBOutlet UILabel *Lat;
	IBOutlet UILabel *Lon;
	IBOutlet UILabel *shipName;
	
	IBOutlet UITableView *TableView;
	NSMutableDictionary *dataDic;
	
	NSMutableArray *keysArray;
    NSDictionary *unitssets;
    AISAppDelegate *appDel;
}
@property(nonatomic,retain) UILabel *MMSI;
-(void)setDictionaryValues:(NSDictionary*)dictionary;
-(IBAction)Done:(id)sender;
@end
