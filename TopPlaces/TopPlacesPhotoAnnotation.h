//
//  TopPlacesPhotoAnnotation.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/24/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TopPlacesPhotoAnnotation : NSObject <MKAnnotation>

+(TopPlacesPhotoAnnotation *)
    annotationForPhoto: (NSDictionary *) photo
            withTitleKey:(NSString *) titleKey andDescriptionKey: (NSString *) descriptionKey;

@property NSDictionary* photoData;

@end
