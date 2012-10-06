//
//  Place+Create.h
//  Top Places
//
//  Created by Oscar Cortez on 9/27/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+ (Place *) placeWithName:(NSString *) name andCreationDate:(NSDate *) creationDate inContext: (NSManagedObjectContext *) context;
@end
