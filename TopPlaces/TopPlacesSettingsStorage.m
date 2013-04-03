//
//  TopPlacesSettingsStorage.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/3/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesSettingsStorage.h"
#import "FlickrFetcher.h"

@implementation TopPlacesSettingsStorage

+(void) addDataToHistory:(NSDictionary *)data{
    
    // get the standard defaults collection and pull out the 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults arrayForKey:SETTINGS_RECENT_PHOTOS_KEY] mutableCopy];
 
    if(!recents){
        // if NIL then just instantiate
        recents = [NSMutableArray arrayWithObject:data];
    }else{
        // otherwaise - find all the objects with the same id
        NSIndexSet *indeces = [recents indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
            NSDictionary *item = (NSDictionary*)obj;
            return [[data objectForKey:FLICKR_PHOTO_ID] isEqualToString:[item objectForKey:FLICKR_PHOTO_ID]];
        }];
        
        // and loop through and remove them from the collection
        [indeces enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
            [recents removeObjectAtIndex:idx];
        }];
        
        // now add to the start of the collection
        [recents insertObject:data atIndex:0];
    }
    
    [defaults setObject:recents forKey:SETTINGS_RECENT_PHOTOS_KEY];
    [defaults synchronize];
}

+(NSArray*) getHistory{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [defaults arrayForKey:SETTINGS_RECENT_PHOTOS_KEY];
    return recents;
}

@end
