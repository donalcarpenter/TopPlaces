//
//  TopPlacesRecentPhotosTableViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/3/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesRecentPhotosTableViewController.h"
#import "TopPlacesSettingsStorage.h"
#import "FlickrFetcher.h"

@interface TopPlacesRecentPhotosTableViewController ()


@end

@implementation TopPlacesRecentPhotosTableViewController
@synthesize model = _model;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [TopPlacesSettingsStorage getHistory];

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
    static NSString *CellIdentifier = @"RecentPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *imageDetails = [self.model objectAtIndex:indexPath.item];
    
    cell.textLabel.text = [imageDetails objectForKey:FLICKR_PHOTO_TITLE];
    
    if(cell.textLabel.text.length == 0){
        cell.textLabel.text = @"Unknown";
    }
    
    cell.imageView.image = Nil;
    
    NSURL *imageUrl = [FlickrFetcher urlForPhoto:imageDetails format:FlickrPhotoFormatSquare];
    
    dispatch_queue_t loadImageQueue = dispatch_queue_create("recentItemsLoadQueue", NULL);
    
    dispatch_async(loadImageQueue, ^{
       
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.imageView.image = [UIImage imageWithData:imageData];
            cell.detailTextLabel.text = [imageDetails objectForKey:FLICKR_PHOTO_DESCRIPTION];
            
            [cell setNeedsDisplay];
            [cell setNeedsLayout];
        });
        
    });

    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowRecentImage"]){
        ImageViewController *controller = segue.destinationViewController;
        controller.dataSource = self;
    }
}

#pragma mark - ImageViewControllerDataSource

-(NSString*) imageTitle{
    NSDictionary* imageDetails = [self.model objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    return [imageDetails objectForKey:FLICKR_PHOTO_TITLE];
}

- (UIImage*) imageToDisplay{
    NSDictionary* imageDetails = [self.model objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    NSURL* imageUrl = [FlickrFetcher urlForPhoto:imageDetails format:FlickrPhotoFormatLarge];
    
    NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
    
    return [UIImage imageWithData:imageData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
