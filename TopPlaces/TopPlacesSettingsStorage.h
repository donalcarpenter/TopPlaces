//
//  TopPlacesSettingsStorage.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/3/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTINGS_RECENT_PHOTOS_KEY @"TopPlaces.RecentPhotosKey"

@interface TopPlacesSettingsStorage : NSObject

+(void) addDataToHistory: (NSDictionary *) data;

+(NSArray *) getHistory;

@end
