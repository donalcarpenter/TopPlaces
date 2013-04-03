//
//  TopPlacesRecentPhotosTableViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/3/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@interface TopPlacesRecentPhotosTableViewController : UITableViewController <ImageViewControllerDataSource>

@property (nonatomic, strong) NSArray* model;

@end
