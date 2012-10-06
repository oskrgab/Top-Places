//
//  MapViewController.h
//  Top Places
//
//  Created by Oscar Cortez on 8/29/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImage *) mapViewController: (MapViewController *) sender imageForAnnotation: (id <MKAnnotation>) annotation;
@end
@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // id <MKAnnotations>
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
- (void) updateMapView;
@end
