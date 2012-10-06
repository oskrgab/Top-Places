//
//  VacationHelper.h
//  Top Places
//
//  Created by Oscar Cortez on 9/26/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;
@end