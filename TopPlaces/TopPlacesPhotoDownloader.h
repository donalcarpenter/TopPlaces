//
//  TopPlacesPhotoDownloader.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/17/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopPlacesPhotoDownloader : NSObject

+(NSData *) getDataForUrl: (NSURL *) url;

@end
