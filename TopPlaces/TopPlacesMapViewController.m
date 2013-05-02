//
//  TopPlacesMapViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/24/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesMapViewController.h"
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"
#import "TopPlacesPhotoAnnotation.h"
#import "PhotosForPlacesMapViewController.h"
#import "ImageViewController.h"

#define TOP_PLACE_TITLE_KEY @"woe_name"
#define TOP_PLACE_DESRIPTION_KEY @"_content"


@interface TopPlacesMapViewController ()<MKMapViewDelegate, PhotosForPlacesMapViewControllerDataSource>
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (atomic, strong) NSDictionary* selectedPlace;
@end

@implementation TopPlacesMapViewController

@synthesize mapView = _mapView;
@synthesize dataSource = _dataSource;
@synthesize model = _model;
@synthesize selectedPlace = _selectedPlace;

-(id<TopPlacesMapViewControllerDataSource>) dataSource{
    if(!_dataSource){
        _dataSource = self;
    }
    
    return _dataSource;
}
-(void) setDataSource:(id<TopPlacesMapViewControllerDataSource>)dataSource{
    _dataSource = dataSource;
}

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
    
    //[self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setModel:(NSArray *)model
{
    _model = model;
    [self updateMapView];
}

- (NSArray *) loadAnnotations{

    NSArray *places = [FlickrFetcher topPlaces];
    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:places.count];
    
    for (NSDictionary* place in places) {
        [annotations addObject:[TopPlacesPhotoAnnotation annotationForPhoto:place withTitleKey: TOP_PLACE_TITLE_KEY andDescriptionKey: TOP_PLACE_DESRIPTION_KEY]];
    }
    
    return annotations;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
        
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedPlace = ((TopPlacesPhotoAnnotation*)view.annotation).photoData;
    
    [self performSegueWithIdentifier:@"showImagesInPlaceMap" sender:self];
    
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

- (NSDictionary*) getSelectedPlaceDetails{
    return self.selectedPlace;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showImagesInPlaceMap"]){
        PhotosForPlacesMapViewController *dest = segue.destinationViewController;
        dest.dataSource = self;
    }
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
    self.mapView.delegate = self;
    self.model = [self.dataSource loadAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
