//
//  PhotoAnnotations.h
//  Top Places
//
//  Created by Oscar Cortez on 8/31/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FlickrFetcher.h"


@interface PhotoAnnotations : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *photo;

+ (PhotoAnnotations *) annotationForPhoto: (NSDictionary *) photo;

@end
