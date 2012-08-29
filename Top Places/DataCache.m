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
@synthesize maxCacheSize = _maxCacheSize;

#define DEFAULT_SIZE 10000000 // 10 megabytes

- (double) maxCacheSize
{
    if (!_maxCacheSize)
        _maxCacheSize = DEFAULT_SIZE;
    
    return _maxCacheSize;
}

- (void) cacheData:(NSData *)data withName:(NSString *)name
{
    NSURL *fileURL = [[DataCache myCacheDirectory] URLByAppendingPathComponent:name];
    
    if (![self URLForFile:name]) {
        if ([DataCache sizeOfDataInCache] < self.maxCacheSize) {
            [data writeToURL:fileURL atomically:NO];
        }
        else {
            [DataCache removeOldestDataInCache];
            [self cacheData:data withName:name];
        }
            
    }
}

- (NSURL *) URLForFile:(NSString *)fileName
{
    
}


+ (NSURL *) myCacheDirectory
{
    NSFileManager *cacheManager =[NSFileManager defaultManager];
    NSURL *directory = [[[cacheManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    
    //NSLog(@"%@",directory);
    
    return directory;
}

+ (NSArray *) contentsOfCache
{
    NSFileManager *cacheManager =[NSFileManager defaultManager];
    NSURL *cacheDirectory = [self myCacheDirectory];
    NSArray *keysForPropertiesInURL = [NSArray arrayWithObjects:NSURLCreationDateKey, NSURLFileSizeKey,NSURLLocalizedNameKey, nil];
    
    NSArray *contents = [cacheManager contentsOfDirectoryAtURL:cacheDirectory includingPropertiesForKeys:keysForPropertiesInURL options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    // NSLog(@"%@",contents);
    
    return contents;
}

+ (void) removeOldestDataInCache
{
    NSFileManager *cacheManager = [NSFileManager defaultManager];
    NSArray *contentsOfCache = [self contentsOfCache];
    
    contentsOfCache = [contentsOfCache sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2){
        NSDate *date1, *date2;
        date1 = [[obj1 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil]objectForKey:NSURLCreationDateKey];
        date2 = [[obj2 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil]objectForKey:NSURLCreationDateKey];
        return [date1 compare:date2];
    }];
    
    //NSLog(@"%@",contentsOfCache);
    
    [cacheManager removeItemAtURL:[contentsOfCache objectAtIndex:0] error:nil];
    
    //NSLog(@"%@", [cacheManager contentsOfDirectoryAtURL:[self myCacheDirectory] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]);
    
}

+ (double) sizeOfDataInCache
{
    double size = 0;
    NSArray *contentsOfCache = [self contentsOfCache];
    for (NSURL *file in contentsOfCache) {
        size += [[[file resourceValuesForKeys:[NSArray arrayWithObject:NSURLFileSizeKey] error:nil] objectForKey:NSURLFileSizeKey] doubleValue];
    }
    
    // NSLog(@"%f",size);
    
    return size;
    
}



@end
