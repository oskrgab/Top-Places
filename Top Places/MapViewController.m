//
//  MapViewController.m
//  Top Places
//
//  Created by Oscar Cortez on 8/29/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceAnnotations.h"
#import "PhotoAnnotations.h"
#import "PhotosDescriptionTVC.h"
#import "PhotoViewController.h"

@interface MapViewController () <MKMapViewDelegate> 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

- (void) updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
    MKCoordinateRegion region = MKCoordinateRegionMake([self centerOfAnnotations:self.annotations], [self spanForAnnotations:self.annotations]);
    [self.mapView setRegion:region animated:YES];
}

- (void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
    
}

- (void) setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!view) {
        view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        view.canShowCallout = YES;
        if (self.delegate) view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    view.annotation = annotation;
    [(UIImageView *) view.leftCalloutAccessoryView setImage:nil];
    return view;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    dispatch_queue_t thumbnailDownloader = dispatch_queue_create("Thumbnail Downloader", NULL);
    dispatch_async(thumbnailDownloader, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *) view.leftCalloutAccessoryView setImage:image];
        });
    });
    dispatch_release(thumbnailDownloader);

}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[PlaceAnnotations class]]){
        [self performSegueWithIdentifier:@"Show Photos from Place" sender:view];
    }
    if ([view.annotation isKindOfClass:[PhotoAnnotations class]]) {
        [self performSegueWithIdentifier:@"Show Selected Photo from Map" sender:view];
    }
        
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define MAX_LATITUD @"Max Latitud Value"
#define MIN_LATITUD @"Min Latitud Value"
#define MAX_LONGITUD @"Max Longitud Value"
#define MIN_LONGITUD @"Min Longitud Value"

- (NSDictionary *) maxAndMinLatitudAndLongitudValuesForAnnotations: (NSArray *) annotations
{
    CLLocationDegrees maxLat, minLat, maxLon, minLon;
    maxLat = [[annotations lastObject] coordinate].latitude;
    minLat = [[annotations lastObject] coordinate].latitude;
    maxLon = [[annotations lastObject] coordinate].longitude;
    minLon = [[annotations lastObject] coordinate].longitude;
        
    for (id <MKAnnotation> annotation in self.annotations) {
        double currentLat, currentLon;
        currentLat = [annotation coordinate].latitude;
        currentLon = [annotation coordinate].longitude;
        if (currentLat >= maxLat)
            maxLat = currentLat;
        if (currentLat <= minLat)
            minLat = currentLat;
        if (currentLon >= maxLon)
            maxLon = currentLon;
        if (currentLon <= minLon)
            minLon = currentLon;
    }
    
    NSDictionary *values = @{ MAX_LATITUD : @(maxLat), MIN_LATITUD : @(minLat), MAX_LONGITUD : @(maxLon), MIN_LONGITUD : @(minLon) };
    return values;
}

- (CLLocationCoordinate2D) centerOfAnnotations:(NSArray *) annotations
{
    NSDictionary *values = [self maxAndMinLatitudAndLongitudValuesForAnnotations:annotations];
    CLLocationDegrees maxLat, minLat, maxLon, minLon, cLat, cLon;
    maxLat = [[values objectForKey:MAX_LATITUD]doubleValue];
    minLat = [[values objectForKey:MIN_LATITUD]doubleValue];
    maxLon = [[values objectForKey:MAX_LONGITUD]doubleValue];
    minLon = [[values objectForKey:MIN_LONGITUD]doubleValue];
    
    cLat = (maxLat - minLat)/2 + minLat;
    cLon = (maxLon - minLon)/2 + minLon;
    
    return CLLocationCoordinate2DMake(cLat, cLon);
}

- (MKCoordinateSpan) spanForAnnotations: (NSArray *) annotations
{
    NSDictionary *values = [self maxAndMinLatitudAndLongitudValuesForAnnotations:annotations];
    CLLocationDegrees maxLat, minLat, maxLon, minLon, deltaLat, deltaLon;
    maxLat = [[values objectForKey:MAX_LATITUD]doubleValue];
    minLat = [[values objectForKey:MIN_LATITUD]doubleValue];
    maxLon = [[values objectForKey:MAX_LONGITUD]doubleValue];
    minLon = [[values objectForKey:MIN_LONGITUD]doubleValue];
    
    deltaLat = (maxLat - minLat);
    deltaLon = (maxLon - minLon);
    
    return MKCoordinateSpanMake(deltaLat, deltaLon);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos from Place"]) {
        [segue.destinationViewController setPlace:[[sender annotation] place]];
    }
    if ([segue.identifier isEqualToString:@"Show Selected Photo from Map"]) {
        [segue.destinationViewController setPhotoInformation:[[sender annotation]photo]];
    }
}

@end
