
//
//  Place+Create.m
//  Top Places
//
//  Created by Oscar Cortez on 9/27/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

+ (Place *) placeWithName:(NSString *)name andCreationDate:(NSDate *)creationDate inContext:(NSManagedObjectContext *)context
{
    Place *place;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[ sortDescriptor ];
    
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || [matches count] > 1) {
        // handle error
    } else if ([matches count] == 0) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
        place.dateAdded = creationDate;
        
    } else if ([matches count] == 1) {
        place = [matches lastObject];
    }
    
    return place;
}
@end
