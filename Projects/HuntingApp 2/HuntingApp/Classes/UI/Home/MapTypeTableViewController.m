//
//  MapTypeTableViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapTypeTableViewController.h"

@interface MapTypeTableViewController ()

@end

@implementation MapTypeTableViewController
@synthesize selectedRow;

- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array
{
    self = [super initWithStyle:style];
    if (self)
    {
        selectedRow = 2;
        self.itemsArray = [[NSMutableArray alloc] initWithObjects:@"Standard",@"Satellite",@"Hybrid", nil];
        self.contentSizeForViewInPopover = CGSizeMake(170, ([self.itemsArray count]* 44)- 1);
    }
    return self;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificationSelected:)])
        [self.delegate performSelector:@selector(notificationSelected:) withObject:[self.itemsArray objectAtIndex:indexPath.row]];
}


@end
