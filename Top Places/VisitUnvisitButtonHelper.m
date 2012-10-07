//
//  VisitUnvisitButtonHelper.m
//  Top Places
//
//  Created by Oscar Cortez on 10/4/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "VisitUnvisitButtonHelper.h"

@implementation VisitUnvisitButtonHelper

+ (void) isPhoto:(NSDictionary *)photo inVacation:(NSString *)vacationName successHandler:(success_handler_t)successHandler
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [photo valueForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[ descriptor ];
    
    [VacationHelper openVacation:vacationName usingBlock:^(UIManagedDocument *vacation) {
        BOOL isInVacation;
        NSArray *matches = [vacation.managedObjectContext executeFetchRequest:request error:nil];
        if ([matches count] == 1) {
            isInVacation = YES;
            successHandler(isInVacation);
        }
        else {
            isInVacation = NO;
            successHandler(isInVacation);
        }
    }];
}

+ (void) visitPhoto:(NSDictionary *)photo forVacation:(NSString *)vacationName
{
    [VacationHelper openVacation:vacationName usingBlock:^(UIManagedDocument *vacation) {
        [Photo photoForFlickerInfo:photo inContext:vacation.managedObjectContext];
    }];
}

+ (void) unvisitPhoto:(NSDictionary *)photo forVacation:(NSString *)vacationName
{
    [VacationHelper openVacation:vacationName usingBlock:^(UIManagedDocument *vacation) {
        [vacation.managedObjectContext deleteObject:[Photo photoForFlickerInfo:photo inContext:vacation.managedObjectContext]];
    }];
}
@end
