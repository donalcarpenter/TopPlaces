//
//  PhotosForPlaceTableViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@protocol PhotosForPlaceTableViewControllerDataSource <NSObject>
-(NSDictionary*) getSelectedPlaceDetails;
@end

@interface PhotosForPlaceTableViewController : UITableViewController <ImageViewControllerDataSource>

    @property id<PhotosForPlaceTableViewControllerDataSource> placeDataSource;
    @property NSArray* model;

@end
