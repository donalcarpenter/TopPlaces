//
//  TopPlacesPhotoDownloader.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 4/17/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "TopPlacesPhotoDownloader.h"

@implementation TopPlacesPhotoDownloader

+(NSData *) getDataForUrl: (NSURL *) url{
    
    NSFileManager *fileMgr  = [[NSFileManager alloc] init];
    
    NSURL *cacheLocation = [[fileMgr URLsForDirectory: NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSMutableArray *comps = [NSMutableArray arrayWithArray:[url pathComponents]];
    
    [comps removeObjectAtIndex:0];
    NSString *path  = [comps componentsJoinedByString:@"/"];
    
    NSURL *localFileUrl = [cacheLocation URLByAppendingPathComponent: path];

    NSData *data;
    
    
    NSError *err;
    
    if(![localFileUrl checkResourceIsReachableAndReturnError:&err]){
        
        data = [NSData dataWithContentsOfURL:url];
        [fileMgr createFileAtPath:[localFileUrl absoluteString] contents:data attributes:Nil];
    }else{
        data = [NSData dataWithContentsOfURL:localFileUrl];
    }

    return data;
    
}

@end
