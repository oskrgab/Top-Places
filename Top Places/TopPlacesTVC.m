//
//  TopPlacesTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/10/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "PhotosDescriptionTVC.h"
#import "PlaceAnnotations.h"
#import "MapViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesTVC () 

@end

@implementation TopPlacesTVC

@synthesize places = _places;

- (NSArray *) placesAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    for (NSDictionary *place in self.places) {
        [annotations addObject:[PlaceAnnotations annotationForPlace:place]];
    }
    return annotations;
}

-(void) setPlaces:(NSArray *)places
{
    if (_places != places) {
        _places = places;
        [self updateDetailViewController];
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (void) updateDetailViewController
{
    if ([[self.splitViewController.viewControllers lastObject] isKindOfClass:[UINavigationController class]]) {
        if ([[[[self.splitViewController.viewControllers lastObject] viewControllers] objectAtIndex:0] isKindOfClass:[MapViewController class]]) {
            [[[[self.splitViewController.viewControllers lastObject] viewControllers] objectAtIndex:0] setAnnotations:[self placesAnnotations]];
        }
    }
    else {
        MapViewController *mapVC = [[MapViewController alloc] init];
        PhotoViewController *photoVC = [[PhotoViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapVC];
        [navigationController addChildViewController:photoVC];
        
    }
        
}
- (IBAction)mapButtonPressed:(id)sender
{
    
}

- (IBAction)refresh:(id)sender
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t placesDownloadQueue = dispatch_queue_create("places downloader", NULL);
    dispatch_async(placesDownloadQueue, ^{
        NSArray *places = [[FlickrFetcher topPlaces]sortedArrayUsingComparator:
                       ^(id obj1, id obj2) {
                           return [[obj1 valueForKeyPath:@"_content"] compare:[obj2 valueForKeyPath:@"_content"]];
                       }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            self.places = places;
        });
    });
    
    dispatch_release(placesDownloadQueue);

    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

#define CITY 0
#define PROVINCE 1
#define COUNTRY 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *placeDescription = [[self.places objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *dividedDescription = [placeDescription componentsSeparatedByString:@", "];
    cell.textLabel.text = [dividedDescription objectAtIndex:CITY];
    
    if ([dividedDescription count] == 3)
        cell.detailTextLabel.text = [[dividedDescription objectAtIndex:PROVINCE] stringByAppendingFormat:@", %@",[dividedDescription objectAtIndex:COUNTRY]];
    else
        cell.detailTextLabel.text = [dividedDescription objectAtIndex:PROVINCE];
                                     
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Segue 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"List Of Photos"]) {
        [segue.destinationViewController setPlace:[self.places objectAtIndex:[self.tableView indexPathForCell:sender].row]];
    }
    if ([segue.identifier isEqualToString:@"Show Places in Map"]) {
        [segue.destinationViewController setAnnotations:[self placesAnnotations]];
    }
    
}


@end
