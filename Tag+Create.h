//
//  Tag+Create.h
//  Top Places
//
//  Created by Oscar Cortez on 9/28/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *) tagWithName:(NSString *) name inContext: (NSManagedObjectContext *) context;
+ (NSSet *) setOfTagswithString:(NSString *) tagsString inContext: (NSManagedObjectContext *) context; // Returns a set of tags given a string with tags that are separated by a space
@end
