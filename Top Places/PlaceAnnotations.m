//
//  PhotoAnnotations.m
//  Top Places
//
//  Created by Oscar Cortez on 8/30/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PlaceAnnotations.h"
#import "FlickrFetcher.h"

@interface PlaceAnnotations ()

@end

@implementation PlaceAnnotations
@synthesize place = _place;

+ (PlaceAnnotations *) annotationForPlace:(NSDictionary *)place
{
    PlaceAnnotations *annotations = [[PlaceAnnotations alloc] init];
    annotations.place = place;
    return annotations;
}

- (NSString *) title
{
    NSString *placeDescription = [self.place valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *dividedDescription = [placeDescription componentsSeparatedByString:@", "];
    
    return [dividedDescription objectAtIndex:0];
}

- (NSString *) subtitle
{
    NSString *placeDescription = [self.place valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *dividedDescription = [placeDescription componentsSeparatedByString:@", "];
    if ([dividedDescription objectAtIndex:2])
        return [[dividedDescription objectAtIndex:1] stringByAppendingFormat:@", %@",[dividedDescription objectAtIndex:2]];
    else
        return [dividedDescription objectAtIndex:1];
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}


@end
