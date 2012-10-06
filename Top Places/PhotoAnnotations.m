//
//  PhotoAnnotations.m
//  Top Places
//
//  Created by Oscar Cortez on 8/31/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotoAnnotations.h"

@implementation PhotoAnnotations

+ (PhotoAnnotations *) annotationForPhoto:(NSDictionary *)photo
{
    PhotoAnnotations *annotations = [[PhotoAnnotations alloc]init];
    annotations.photo = photo;
    return annotations;
}

- (NSString *) title
{
    NSString *photoTitle = [self.photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if (![photoTitle isEqualToString:@""])
        return photoTitle;
    else if (![photoDescription isEqualToString:@""])
        return photoDescription;
    else
        return @"Unknown";
    
}

- (NSString *) subtitle
{
    if (![[self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]isEqualToString:@""])
        return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    else
        return @"";
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}
@end
