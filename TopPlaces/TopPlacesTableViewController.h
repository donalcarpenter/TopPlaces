//
//  TopPlacesTableViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/4/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosForPlaceTableViewController.h"

@interface TopPlacesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,PhotosForPlaceTableViewControllerDataSource>

@property NSArray *model;
@property (strong, nonatomic) IBOutlet UITableView *topPlacesTableView;


@end
