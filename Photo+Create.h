//
//  Photo+Create.h
//  Top Places
//
//  Created by Oscar Cortez on 9/27/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

+ (Photo *) photoForFlickerInfo:(NSDictionary *) info inContext: (NSManagedObjectContext *) context;

@end
