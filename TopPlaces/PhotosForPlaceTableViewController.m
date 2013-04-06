//
//  PhotosForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "PhotosForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesSettingsStorage.h"

@interface PhotosForPlaceTableViewController ()
    @property (readonly, strong, nonatomic) NSMutableDictionary* smallImageCache;
@property (strong, nonatomic) IBOutlet UITableView *photosTable;

@end

@implementation PhotosForPlaceTableViewController

@synthesize smallImageCache = _smallImageCache;
@synthesize model = _model;
@synthesize placeDataSource = _placeDataSource;
@synthesize photosTable = _photosTable;

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
    
    dispatch_queue_t loadfromflickr = dispatch_queue_create("loadfromflickr", NULL);
    
    dispatch_async(loadfromflickr, ^{
        
        self.model = [FlickrFetcher photosInPlace:[self.placeDataSource getSelectedPlaceDetails] maxResults:50];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosTable reloadData];
        });
    });
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ShowImage"]){
        ImageViewController *controller = segue.destinationViewController;
        controller.dataSource = self;
        
        // now add to the list in the NSUserDefaults
        NSDictionary* imageDetails = [self.model objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        [TopPlacesSettingsStorage addDataToHistory:imageDetails];
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
    
    return [imageDetails objectForKey:FLICKR_PHOTO_TITLE];
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
    cell.imageView.image = Nil;
    cell.textLabel.text = [imageDetails objectForKey:FLICKR_PHOTO_TITLE];
    
    if(cell.textLabel.text.length == 0){
        cell.textLabel.text = @"Unknown";
    }
    
    dispatch_queue_t loadImageThread = dispatch_queue_create("ImageLoading", NULL);
    cell.detailTextLabel.text = [imageDetails objectForKey:FLICKR_PHOTO_DESCRIPTION];

    dispatch_async(loadImageThread, ^{
        NSURL *imageUrl = [FlickrFetcher urlForPhoto:imageDetails format:FlickrPhotoFormatSquare];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:imageData];
            [cell setNeedsDisplay];
            [cell setNeedsLayout];
        });
    });
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
