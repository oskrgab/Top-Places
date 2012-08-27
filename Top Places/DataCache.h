//
//  PhotoCache.h
//  Top Places
//
//  Created by Oscar Cortez on 8/26/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

+ (void) cacheData:(NSData *) data;
+ (NSArray *) contentsOfCache; // With creation date and file size properties included
+ (void) removeOldestDataInCache;
+ (double) sizeOfDataInCache;
+ (BOOL) cacheHasData: (NSData *) data;

@end
