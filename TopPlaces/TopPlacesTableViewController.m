//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/4/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesTableViewController ()
@property NSDictionary* selectedItem;
@end

@implementation TopPlacesTableViewController

@synthesize model = _model;
@synthesize topPlacesTableView = _topPlacesTableView;
@synthesize selectedItem = _selectedItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSDictionary*) getSelectedPlaceDetails{
    return [self.model objectAtIndex:self.topPlacesTableView.indexPathForSelectedRow.row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.model = [[FlickrFetcher topPlaces] sortedArrayUsingComparator:^(id a, id b){
        NSString* woe1 = [(NSDictionary*)a objectForKey:@"woe_name"];
        NSString* woe2 = [(NSDictionary*)b objectForKey:@"woe_name"];
        
        return [woe1 compare:woe2];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* item = [self.model objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"woe_name"];
    cell.detailTextLabel.text = [item objectForKey:@"_content"];
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"PhotosForLocality"]){
        PhotosForPlaceTableViewController *dest = segue.destinationViewController;
        
        dest.placeDataSource = self;
        
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = [self.model objectAtIndex:indexPath.row];
}

@end
