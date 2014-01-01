//
//  FavLocTableViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavLocTableViewController.h"
#import <MapKit/MkAnnotation.h>
@interface FavLocTableViewController ()

- (void)addCurrentLocationInItemsArray;
 NSString *customLocation;
@end

@implementation FavLocTableViewController
@synthesize selectedRow;

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
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    [self addCurrentLocationInItemsArray];
    return [self.itemsArray count];
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
        Location *loc = [self.itemsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [loc.description stringByReplacingOccurrencesOfString:@";" withString:@","];
        if ([loc.loc_id isEqualToString:@"My Location"])
            cell.textLabel.text = loc.loc_id;
    }
    else {
        cell.textLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (selectedRow == indexPath.row)
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
    [tableView reloadData];
    if (indexPath.row != [self.itemsArray count])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notificationSelected:)])
            [self.delegate performSelector:@selector(notificationSelected:) withObject:[self.itemsArray objectAtIndex:indexPath.row]];
    }
}

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
