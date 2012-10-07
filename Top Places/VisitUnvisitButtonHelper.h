//
//  VisitUnvisitButtonHelper.h
//  Top Places
//
//  Created by Oscar Cortez on 10/4/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//
typedef void (^success_handler_t)(BOOL success);

#import <Foundation/Foundation.h>
#import "VacationHelper.h"
#import "FlickrFetcher.h"
#import "Photo+Create.h"

@interface VisitUnvisitButtonHelper : NSObject

+ (void) visitPhoto:(NSDictionary *) photo forVacation:(NSString *) vacationName;
+ (void) unvisitPhoto:(NSDictionary *) photo forVacation:(NSString *) vacationName;
+ (void) isPhoto:(NSDictionary *)photo inVacation:(NSString *)vacationName successHandler:(success_handler_t) successHandler;

@end
