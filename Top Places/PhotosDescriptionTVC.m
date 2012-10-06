//
//  PhotosDescriptionTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/11/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotosDescriptionTVC.h"
#import "PhotoViewController.h"
#import "MapViewController.h"
#import "PhotoAnnotations.h"
#import "FlickrFetcher.h"


@interface PhotosDescriptionTVC () <MapViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation PhotosDescriptionTVC
@synthesize spinner = _spinner;
@synthesize photos = _photos;
@synthesize place = _place;

#define MAX_RESULTS 50

- (NSArray *) photosAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[PhotoAnnotations annotationForPhoto:photo]];
    }
    
    return annotations;
}

- (void) setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        [self updateDetailViewController];
        if (self.tableView.window) [self.tableView reloadData];
    }
}

-(void) updateDetailViewController
{
    
}
- (IBAction)mapButtonPressed:(id)sender
{
    }
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    dispatch_queue_t photoDataDownloadQueue = dispatch_queue_create("Photo Data Downloader", NULL);
    dispatch_async(photoDataDownloadQueue, ^{
        self.photos = [FlickrFetcher photosInPlace:self.place maxResults:MAX_RESULTS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        });
    });
    dispatch_release(photoDataDownloadQueue);
}

- (UIImage *) mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    PhotoAnnotations *photoAnnotation = (PhotoAnnotations *) annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:photoAnnotation.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner.color = [UIColor grayColor];
    [self.spinner startAnimating];
    NSString *city = [[[self.place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
    self.navigationItem.title = city;
    

}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *photoTitle, *photoDescription;

    photoTitle = [[self.photos objectAtIndex:indexPath.row]valueForKeyPath:FLICKR_PHOTO_TITLE];
    photoDescription = [[self.photos objectAtIndex:indexPath.row]valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if (![photoTitle isEqualToString:@""]){
        cell.textLabel.text = photoTitle;
        cell.detailTextLabel.text = photoDescription;
    }
    else if (![photoDescription isEqualToString:@""]){
        cell.textLabel.text = photoDescription;
    }
    else
        cell.textLabel.text = @"Unknown";
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPhotos = [[defaults objectForKey:RECENT_PHOTOS_KEY] mutableCopy];
    NSDictionary *foundPhoto;
    
    if (!recentPhotos) {
        recentPhotos = [NSMutableArray array];
    }
    else {
        for (NSDictionary *aPhoto in recentPhotos) {
            if ([[aPhoto valueForKey:FLICKR_PHOTO_ID] isEqualToString:[[self.photos objectAtIndex:indexPath.row] valueForKey:FLICKR_PHOTO_ID]]) {
                foundPhoto = aPhoto;
            }
        }
    }
    
    [recentPhotos removeObject:foundPhoto];
    [recentPhotos insertObject:[self.photos objectAtIndex:indexPath.row] atIndex:0];
    [defaults setObject:recentPhotos forKey:RECENT_PHOTOS_KEY];
    [defaults synchronize];
        
    
}

#pragma mark - Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo From List Of Photos"]) {
        [segue.destinationViewController setPhotoInformation:[self.photos objectAtIndex:[self.tableView indexPathForCell:sender].row]];
    }
    
    if ([segue.identifier isEqualToString:@"Show Photos in Map"]) {
        [segue.destinationViewController setAnnotations:[self photosAnnotations]];
        [segue.destinationViewController setDelegate:self];
    }
    
}

@end
