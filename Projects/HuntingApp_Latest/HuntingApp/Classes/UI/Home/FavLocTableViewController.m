//
//  FavLocTableViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavLocTableViewController.h"
#import <MapKit/MkAnnotation.h>
#import "LocationManager.h"
@interface FavLocTableViewController ()
{
    NSString *customLocation;
}
- (void)addCurrentLocationInItemsArray;

@end

@implementation FavLocTableViewController
@synthesize selectedRow;
@synthesize arrcustomLocation;
@synthesize arrDefinedLocation;
@synthesize selectedSection;


- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array
{
    self = [super initWithStyle:style];
    if (self)
    {
        selectedRow = -1;
        self.itemsArray = [[NSMutableArray alloc]initWithArray:array];
        [self addCurrentLocationInItemsArray];
        NSInteger count = [self.itemsArray count]<=6?[self.itemsArray count]:6;
        self.contentSizeForViewInPopover = CGSizeMake(200, (count* 44)- 1);
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    arrcustomLocation = [[NSMutableArray alloc] init];
    arrDefinedLocation = [[NSMutableArray alloc]init];
    //NSLog(@"%@",self.itemsArray);
    [self.itemsArray enumerateObjectsUsingBlock:^(Location *loc,NSUInteger i,BOOL *stop){
        
        //NSLog(@"%@",loc.loc_id);
        
        if ([loc.type isEqualToString:@"custom"] || [loc.loc_id isEqualToString:@"My Location"]) {
        [arrcustomLocation addObject:loc];
        }else{
        [arrDefinedLocation addObject:loc];
        }
        
    }];
        
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (section == 0)
        {
            return @"Custom";
        }
        if (section == 1)
        {
            return @"Defined";
        }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     [self addCurrentLocationInItemsArray];
    if (section==0) {
        
        return [arrcustomLocation count];
    }else{
        
        return [arrDefinedLocation count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell...
    if (indexPath.row<[self.itemsArray count])
    {
        Location *loc;
        if (indexPath.section==0) {
        loc = [self.arrcustomLocation objectAtIndex:indexPath.row];
        cell.textLabel.text = [loc.description stringByReplacingOccurrencesOfString:@";" withString:@","];
        
        }else{
             loc= [self.arrDefinedLocation objectAtIndex:indexPath.row];
            cell.textLabel.text = [loc.description stringByReplacingOccurrencesOfString:@";" withString:@","];
        }

        if ([loc.loc_id isEqualToString:@"My Location"]){
         
            cell.textLabel.text = loc.loc_id;
        }
        
    }
    else {
        
        cell.textLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSLog(@"%d %d",selectedSection,selectedRow);
        
    if (selectedRow == indexPath.row && selectedSection==indexPath.section)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    selectedSection=indexPath.section;
    [tableView reloadData];
    if (indexPath.section==0) {
    if (indexPath.row != [self.arrcustomLocation count])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notificationSelected:)])
            [self.delegate performSelector:@selector(notificationSelected:) withObject:[self.arrcustomLocation objectAtIndex:indexPath.row]];
    }
    }else{
        
        if (indexPath.row != [self.arrDefinedLocation count])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(notificationSelected:)])
                [self.delegate performSelector:@selector(notificationSelected:) withObject:[self.arrDefinedLocation objectAtIndex:indexPath.row]];
        }
    }
}

//- (void)addCurrentLocationInItemsArray
//{
//    if (![((Location *)[self.itemsArray lastObject]).loc_id isEqualToString:@"My Location"])
//    {
//        LocationManager *manager = [[LocationManager alloc] init];
//        [manager trackLocation];
//        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//        CLLocationCoordinate2D coordinate = [locationManager.location coordinate];
//        NSMutableDictionary *locParams = [NSMutableDictionary dictionary];
//        [locParams setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:LOCATION_LATITUDE_KEY];
//        [locParams setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:LOCATION_LONGITUDE_KEY];
//        Location *userLocation = [[DAL sharedInstance] getUserLocation:locParams];
//        [self.itemsArray insertObject:userLocation atIndex:[self.itemsArray count]];
//        
//        NSLog(@"%@",((Location *)[self.itemsArray lastObject]).loc_id);
//        NSLog(@"%@",self.itemsArray);
////        if ([Utility getLocationDict])
////        {
////            NSDictionary *params = [Utility getLocationDict];
////           
////            
////        }
//    }
//}
- (void)addCurrentLocationInItemsArray
{
    if (![((Location *)[self.itemsArray lastObject]).loc_id isEqualToString:@"My Location"])
    {
        if ([Utility getLocationDict])
        {
            NSDictionary *params = [Utility getLocationDict];
            Location *userLocation = [[DAL sharedInstance] getUserLocation:params];
            [self.itemsArray addObject:userLocation];
        }
    }
}


@end
