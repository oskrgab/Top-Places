//
//  PhotoCache.m
//  Top Places
//
//  Created by Oscar Cortez on 8/26/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "DataCache.h"

@interface DataCache ()
@end

@implementation DataCache

+ (void) cacheData:(NSData *)data
{
    NSURL *cacheDirectory = [DataCache cacheDirectory];
    [data writeToURL:cacheDirectory atomically:NO];

}

+ (NSURL *) cacheDirectory
{
    NSFileManager *cacheManager =[NSFileManager defaultManager];
    return [[cacheManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSArray *) contentsOfCache
{
    NSFileManager *cacheManager =[NSFileManager defaultManager];
    NSURL *cacheDirectory = [DataCache cacheDirectory];
    NSArray *keysForPropertiesInURL = [NSArray arrayWithObjects:NSURLCreationDateKey, NSURLFileSizeKey, nil];
    return [cacheManager contentsOfDirectoryAtURL:cacheDirectory includingPropertiesForKeys:keysForPropertiesInURL options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
}

+ (void) removeOldestDataInCache
{
    NSFileManager *cacheManager = [NSFileManager defaultManager];
    NSArray *contentsOfCache = [DataCache contentsOfCache];
    
    contentsOfCache = [contentsOfCache sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2){
        NSDate *date1, *date2;
        date1 = [[obj1 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil]objectForKey:NSURLCreationDateKey];
        date2 = [[obj2 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil]objectForKey:NSURLCreationDateKey];
        return [date1 compare:date2];
    }];
    
    [cacheManager removeItemAtURL:[contentsOfCache objectAtIndex:0] error:nil];
    
}

+ (double) sizeOfDataInCache
{
    double size = 0;
    NSArray *contentsOfCache = [DataCache contentsOfCache];
    for (NSURL *file in contentsOfCache) {
        size += [[[file resourceValuesForKeys:[NSArray arrayWithObject:NSURLFileSizeKey] error:nil] objectForKey:NSURLFileSizeKey] doubleValue];
    }
    
    return size;
    
}

+ (BOOL) cacheHasData:(NSData *)data
{
    NSFileManager *cacheManager = [NSFileManager defaultManager];
    NSArray *contentsOfCache = [DataCache contentsOfCache];
    NSString *path;
    BOOL hasData = NO;
    
    for (NSURL * file in contentsOfCache) {
        if ([file isFileURL]) {
            path = [file path];
            NSData *cacheData = [cacheManager contentsAtPath:path];
            if ([cacheData isEqualToData:data])
                hasData = YES;
            break;
        }
    }
    
    return hasData;
}

@end
