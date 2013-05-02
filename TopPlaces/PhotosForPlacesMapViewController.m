//
//  PhotosForPlacesMapViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/26/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "PhotosForPlacesMapViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotoAnnotation.h"
#import "ImageViewController.h"


@interface PhotosForPlacesMapViewController ()<MKMapViewDelegate, ImageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSDictionary* selectedPhoto;

@end

@implementation PhotosForPlacesMapViewController

@synthesize dataSource = _dataSource;
@synthesize model = _model;
@synthesize mapView = _mapView;
@synthesize selectedPhoto = _selectedPhoto;

#pragma map setup

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.model) [self.mapView addAnnotations:self.model];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(NSArray *) model{
    return _model;
}

- (void)setModel:(NSArray *)model
{
    _model = model;
    [self updateMapView];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    NSArray* flickrPhotos = [FlickrFetcher photosInPlace:[self.dataSource getSelectedPlaceDetails] maxResults:50];

    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:flickrPhotos.count];
    
    for (NSDictionary *photo in flickrPhotos) {
        TopPlacesPhotoAnnotation *annot = [TopPlacesPhotoAnnotation annotationForPhoto:photo withTitleKey:FLICKR_PHOTO_TITLE andDescriptionKey:FLICKR_PHOTO_DESCRIPTION];
        
        [annotations addObject:annot];
    }
    
    self.model = annotations;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PhotoForPlaceMapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PhotoForPlaceMapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)aView;
        pinView.pinColor = MKPinAnnotationColorGreen;
        
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    TopPlacesPhotoAnnotation *annotaton = aView.annotation;
    
    NSURL *imageUrl = [FlickrFetcher urlForPhoto:annotaton.photoData format:FlickrPhotoFormatSquare];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:[UIImage imageWithData:imageData]];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedPhoto = ((TopPlacesPhotoAnnotation*)view.annotation).photoData;
    
    ImageViewController* ivc = [self imageViwControllerInSplitViewMaster];
    if(ivc){
        ivc.dataSource = self;
        [ivc reloadImage];
        return;
    }
    
    [self performSegueWithIdentifier:@"showImageFromMap" sender:self];
    
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

-(ImageViewController *) imageViwControllerInSplitViewMaster{
    UIViewController *vc = [self.splitViewController.viewControllers lastObject];
    
    if(![vc isKindOfClass:[ImageViewController class]]){
        return nil;
    }
    
    return (ImageViewController*)vc;
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showImageFromMap"]){
        ImageViewController *imgViewer = segue.destinationViewController;
        imgViewer.dataSource = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*) imageToDisplay{

    NSURL *url = [FlickrFetcher urlForPhoto:self.selectedPhoto format:FlickrPhotoFormatLarge];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return [UIImage imageWithData:data];
}

-(NSString*) imageTitle{
    return [self.selectedPhoto objectForKey:FLICKR_PHOTO_TITLE];
}

@end
