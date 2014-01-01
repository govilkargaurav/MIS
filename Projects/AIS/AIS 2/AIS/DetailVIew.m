//
//  DetailVIew.m
//  AIS
//
//  Created by apple on 4/16/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "DetailVIew.h"


@implementation DetailVIew
@synthesize MMSI;
-(void)setDictionaryValues:(NSDictionary*)dictionary{

    appDel=(AISAppDelegate*)[[UIApplication sharedApplication] delegate];
    unitssets = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]];

	
	NSString *latDir,*lonDir;
	latDir=@"N";
	lonDir=@"E";
	NSString *st = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Latitude"]];
	if ([st floatValue]<0) {
		st = [NSString stringWithFormat:@"%f",-[st floatValue]];
		latDir=@"W";
	}
	
	float degree = [st floatValue];
	float min = (degree - ((int)degree))*60.0;
	float second0 = (min - ((int)min))*60.0;
	
	NSString *st1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Longitude"]];
	if ([st1 floatValue]<0) {
		st1 = [NSString stringWithFormat:@"%f",-[st1 floatValue]];
		lonDir=@"S";
	}
	float degree1 = [st1 floatValue];
	float min1 = (degree1 - ((int)degree1))*60.0;
	float second1 = (min1 - ((int)min1))*60.0;
	NSString *lat1,*lon1;
	if ([[unitssets valueForKey:@"posi"] intValue] == 0) {
	
		lat1=[NSString stringWithFormat:@"%d°%d'%2.2f''%@",(int)degree,(int)min,(float)second0,latDir];
		lon1=[NSString stringWithFormat:@"%d°%d'%2.2f''%@",(int)degree1,(int)min1,(float)second1,lonDir];				
	}else {
		
		lat1=[NSString stringWithFormat:@"%3.2f°%@",degree,latDir];
		lon1=[NSString stringWithFormat:@"%3.2f°%@",degree1,lonDir];			
	}	
	
	NSString *callsign1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CallSign"]];
	NSString *cog1 = [NSString stringWithFormat:@"%3.2f°",[[dictionary valueForKey:@"COG"] floatValue]];
	NSString *sog1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"SOG"]];
	NSString *shipName1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"ShipName"]];
	NSString *mmsi1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"MMSINum"]];
	NSString *type1 = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"TypeOfShip"]];
    NSString *hdg = [NSString stringWithFormat:@"%3.2f°",[[dictionary valueForKey:@"TrueHeading"] floatValue]];
	
    NSString *date = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"date"]];
    NSDateFormatter *dtFormate = [[NSDateFormatter alloc] init];
    [dtFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];

    NSString *dateStr = [[NSString alloc] initWithFormat:@"%@",[appDel getStringFromDate:[dtFormate dateFromString:date]]];
    [dtFormate release];
    NSArray *arr = [dateStr componentsSeparatedByString:@" "];
    [dateStr release];
    NSString *date1=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
    
	dataDic = [[NSMutableDictionary alloc] init];
	[dataDic setValue:mmsi1 forKey:@"MMSI"];
	keysArray = [[NSMutableArray alloc] initWithObjects:@"MMSI",@"LAT",@"LON",@"SOG",@"COG",@"HDG",@"Time",nil];
    
	if (!([shipName1 isEqualToString:@"(null)"]) && !(shipName1 == nil)) {
		[dataDic setValue:shipName1 forKey:@"shipname"];
		[dataDic setValue:callsign1 forKey:@"Callsign"];		
		[dataDic setValue:type1 forKey:@"Type"];
		keysArray = [[NSMutableArray alloc] initWithObjects:@"MMSI",@"Callsign",@"LAT",@"LON",@"SOG",@"COG",@"Type",@"HDG",@"Time",nil];
		
	}
	
	[dataDic setValue:lat1 forKey:@"LAT"];
	[dataDic setValue:lon1 forKey:@"LON"];
	[dataDic setValue:sog1 forKey:@"SOG"];
	[dataDic setValue:cog1 forKey:@"COG"];
    [dataDic setValue:date1 forKey:@"Time"];
    
    if (![hdg isEqualToString:@"(null)"]) {
        [dataDic setValue:hdg forKey:@"HDG"];
    }else{
        [keysArray removeObject:@"HDG"];
    }

    
    
	
	[TableView reloadData];
//	return self; 
} 
-(id)initWithFrame:(CGRect)frame {
	DetailVIew *detail;
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		NSArray *bundle;
		TableView.backgroundView.backgroundColor=[UIColor clearColor];
		TableView.backgroundColor=[UIColor clearColor];

		bundle= [[NSBundle mainBundle] loadNibNamed:@"DetailVIew"
														owner:self options:nil];
		for (id object in bundle) {
			if ([object isKindOfClass:[DetailVIew class]])
				detail = (DetailVIew *)object;
			
		}   
		detail.frame =frame;
    }
	
    return detail;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [keysArray count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	NSString *title;
	title=@"";
 
	if ([dataDic valueForKey:@"shipname"]) {		
		title=[[NSString alloc] initWithFormat:@"%@",[dataDic valueForKey:@"shipname"]]; 
	}
	return title;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
       // [[NSBundle mainBundle] loadNibNamed:@"CustomCellTarget" owner:self options:nil];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		
    }   
	NSString *key = [NSString stringWithFormat:@"%@",[keysArray objectAtIndex:indexPath.row]];
	cell.textLabel.text = [NSString stringWithFormat:@"%@",key];
	cell.detailTextLabel.text = [dataDic valueForKey:[NSString stringWithFormat:@"%@",key]];
	
	if ([key isEqualToString:@"SOG"]) {
		NSString *speed =[NSString stringWithFormat:@"%@",cell.detailTextLabel.text];
        
      
        if ([[unitssets valueForKey:@"speed"] intValue] == 0) {
            
            if(![[NSString stringWithFormat:@"%@",speed] isEqualToString:@"(null)"])
            {
                speed = [NSString stringWithFormat:@"%@ kn",speed];
            }
            
        }else{
            if(![[NSString stringWithFormat:@"%@",speed] isEqualToString:@"(null)"])
            {
               
                speed = [NSString stringWithFormat:@"%.2f km/h",(float)([speed floatValue]*1.852)];
            }
            
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",speed];
	}
	
	return cell;
}
-(IBAction)Done:(id)sender{
	[self removeFromSuperview];
    [dataDic release];
    [keysArray release];
}
@end
