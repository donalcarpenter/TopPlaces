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
#import "TopPlacesPhotoDownloader.h"

@interface PhotosForPlaceTableViewController ()
    @property (readonly, strong, nonatomic) NSMutableDictionary* smallImageCache;
@property (strong, nonatomic) IBOutlet UITableView *photosTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshDataButton;

@end

@implementation PhotosForPlaceTableViewController

@synthesize smallImageCache = _smallImageCache;
@synthesize model = _model;
@synthesize placeDataSource = _placeDataSource;
@synthesize photosTable = _photosTable;
@synthesize refreshDataButton    = _refreshDataButton;

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
    
    [self refreshPhotosForLocationFromFlickr:self.refreshDataButton];
    
}

- (void) refreshPhotosForLocationFromFlickr:(id)sender{
    dispatch_queue_t loadfromflickr = dispatch_queue_create("loadfromflickr", NULL);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    NSDictionary *placeDetails = [self.placeDataSource getSelectedPlaceDetails];
    self.navigationItem.title = [placeDetails objectForKey:@"woe_name"];

    
    dispatch_async(loadfromflickr, ^{
        
        
        self.model = [FlickrFetcher photosInPlace:placeDetails maxResults:50];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosTable reloadData];
            [self.photosTable setNeedsDisplay];
            self.navigationItem.rightBarButtonItem = sender;
        });
    });
}

-(ImageViewController *) imageViwControllerInSplitViewMaster{
    UIViewController *vc = [self.splitViewController.viewControllers lastObject];
    
    if(![vc isKindOfClass:[ImageViewController class]]){
        return nil;
    }
    
    return (ImageViewController*)vc;
    
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
    
    
    NSData* imageData = [TopPlacesPhotoDownloader getDataForUrl:imageUrl];
    
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
    ImageViewController* ivc = [self imageViwControllerInSplitViewMaster];
    if(ivc){
        ivc.dataSource = self;
        [ivc reloadImage];
    }
}

@end
