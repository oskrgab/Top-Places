//
//  Tag+Create.m
//  Top Places
//
//  Created by Oscar Cortez on 9/28/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *) tagWithName:(NSString *) name inContext: (NSManagedObjectContext *) context
{
    Tag *tag;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[ sortDescriptor ];
    
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || [matches count] > 1) {
        // handle error
    } else if ([matches count] == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.name = [name capitalizedString];
        tag.numberOfPhotos = @([tag.photos count]);
    } else if ([matches count] == 1) {
        tag = [matches lastObject];
    }
    
    return tag;

}

+ (NSSet *) setOfTagswithString:(NSString *)tagsString inContext: (NSManagedObjectContext *) context
{
    NSArray *arrayOfStringTags = [tagsString componentsSeparatedByString:@" "];
    NSMutableSet *setOfTags;
    
    for (NSString *aTag in arrayOfStringTags) {
        [setOfTags addObject:[Tag tagWithName:aTag inContext:context]];
    }
    
    return setOfTags;
}


@end
