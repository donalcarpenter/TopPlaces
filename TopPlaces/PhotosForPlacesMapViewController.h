//
//  PhotosForPlacesMapViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/26/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PhotosForPlacesMapViewControllerDataSource <NSObject>
-(NSDictionary*) getSelectedPlaceDetails;
@end

@interface PhotosForPlacesMapViewController : UIViewController
@property id<PhotosForPlacesMapViewControllerDataSource> dataSource;
@property NSArray* model;
@end
