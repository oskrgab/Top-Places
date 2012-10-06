//
//  VisitUnvisitButtonHelper.h
//  Top Places
//
//  Created by Oscar Cortez on 10/4/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VacationHelper.h"
#import "FlickrFetcher.h"
#import "Photo+Create.h"

@interface VisitUnvisitButtonHelper : NSObject

+ (void) visitPhoto:(NSDictionary *) photo forVacation:(NSString *) vacationName;
+ (void) unvisitPhoto:(NSDictionary *) photo forVacation:(NSString *) vacationName;
+ (BOOL) isPhoto:(NSDictionary *)photo inVacation:(NSString *)vacationName;

@end
