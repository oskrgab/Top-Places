//
//  VacationHelper.m
//  Top Places
//
//  Created by Oscar Cortez on 9/26/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "VacationHelper.h"
#import "FlickrFetcher.h"

@implementation VacationHelper

+ (void) openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    
    UIManagedDocument *vacation = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        [vacation saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) completionBlock(vacation);
            if (!success) NSLog(@"Couldn't open document at %@",url);
        }];
    } else if (vacation.documentState == UIDocumentStateClosed) {
        [vacation openWithCompletionHandler:^(BOOL success) {
            if (success) completionBlock(vacation);
            if (!success) NSLog(@"Couldn't open document at %@",url);
        }];
    } else if (vacation.documentState == UIDocumentStateNormal) {
        completionBlock(vacation);
    }
    
}


@end
