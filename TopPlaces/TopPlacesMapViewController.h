//
//  TopPlacesMapViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/24/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopPlacesMapViewControllerDataSource <NSObject>
-(NSArray*) loadAnnotations;
@end

@interface TopPlacesMapViewController : UIViewController<TopPlacesMapViewControllerDataSource>

@property (nonatomic, weak) id<TopPlacesMapViewControllerDataSource> dataSource;

@property (nonatomic, strong) NSArray* model; // of id <TopPlacesPhotoAnnotation>

@end
