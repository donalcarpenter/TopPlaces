//
//  PhotosForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "PhotosForPlaceTableViewController.h"
#import "FlickrFetcher.h"

@interface PhotosForPlaceTableViewController ()
    @property (readonly, strong, nonatomic) NSMutableDictionary* smallImageCache;
@end

@implementation PhotosForPlaceTableViewController

@synthesize smallImageCache = _smallImageCache;
@synthesize model = _model;
@synthesize placeDataSource = _placeDataSource;

-(NSMutableDictionary*) smallImageCache{
    if(!_smallImageCache){
        _smallImageCache = [NSMutableDictionary dictionary];
    }
    return _smallImageCache;
}

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
    
    self.model = [FlickrFetcher photosInPlace:[self.placeDataSource getSelectedPlaceDetails] maxResults:50];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowImage"]){
        ImageViewController *controller = segue.destinationViewController;
        controller.dataSource = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImageViewControllerDataSource

-(NSString*) imageTitle{
    NSDictionary* imageDetails = [self.model objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    return [imageDetails objectForKey:@"title"];
}

- (UIImage*) imageToDisplay{
    NSDictionary* imageDetails = [self.model objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    NSURL* imageUrl = [FlickrFetcher urlForPhoto:imageDetails format:FlickrPhotoFormatLarge];
    
    NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
    
    return [UIImage imageWithData:imageData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photos For Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary* imageDetails = [self.model objectAtIndex:indexPath.row];
    cell.textLabel.text = [imageDetails objectForKey:@"title"];
    if(cell.textLabel.text.length == 0){
        cell.textLabel.text = @"Unknown";
    }
    
    NSURL *imageUrl = [FlickrFetcher urlForPhoto:imageDetails format:FlickrPhotoFormatSquare];
    NSData *imageData = [self.smallImageCache objectForKey:imageUrl];
    if(!imageData){
        imageData = [NSData dataWithContentsOfURL:imageUrl];
        [self.smallImageCache setObject:imageData forKey:imageUrl];
    }
    cell.imageView.image = [UIImage imageWithData:imageData];
    cell.detailTextLabel.text = [imageDetails objectForKey:@"tags"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
