//
//  PhotosForPlaceTableViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosForPlaceTableViewControllerDataSource <NSObject>
-(NSDictionary*) getSelectedPlaceDetails;
@end

@interface PhotosForPlaceTableViewController : UITableViewController
@property id<PhotosForPlaceTableViewControllerDataSource> placeDataSource;
@end
