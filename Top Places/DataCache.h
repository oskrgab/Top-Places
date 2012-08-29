//
//  PhotoCache.h
//  Top Places
//
//  Created by Oscar Cortez on 8/26/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

@property (nonatomic) double maxCacheSize;

- (void) cacheData:(NSData *) data withName: (NSString *) name;
- (NSURL *) URLForFile: (NSString *) fileName;

@end
