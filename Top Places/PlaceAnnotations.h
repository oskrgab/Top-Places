//
//  PhotoAnnotations.h
//  Top Places
//
//  Created by Oscar Cortez on 8/30/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface PlaceAnnotations : NSObject <MKAnnotation>
@property (nonatomic, strong) NSDictionary *place;

+ (PlaceAnnotations *) annotationForPlace: (NSDictionary *) place;

@end
