//
//  TopPlacesPhotoAnnotation.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/24/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesPhotoAnnotation.h"
#import "FlickrFetcher.h"

@interface TopPlacesPhotoAnnotation()
@property NSString* titleKey;
@property NSString* descriptionKey;
@end

@implementation TopPlacesPhotoAnnotation

@synthesize photoData = _photoData;

+(TopPlacesPhotoAnnotation *)
        annotationForPhoto: (NSDictionary *) photo
              withTitleKey: (NSString *) titleKey
         andDescriptionKey: (NSString *) descriptionKey{
    TopPlacesPhotoAnnotation* annot = [[TopPlacesPhotoAnnotation alloc] init];
    annot.photoData = photo;
    annot.titleKey = titleKey;
    annot.descriptionKey = descriptionKey;
    return annot;
}

#pragma mark - MKAnnotation

- (NSString *) title{
    return [self.photoData objectForKey: self.titleKey];
}

-(NSString *) description{
    return [self.photoData objectForKey: self.descriptionKey];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photoData objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photoData objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}
@end
