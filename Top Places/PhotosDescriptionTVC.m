//
//  PhotosDescriptionTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/11/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotosDescriptionTVC.h"
#import "PhotoViewController.h"

@interface PhotosDescriptionTVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation PhotosDescriptionTVC
@synthesize spinner = _spinner;
@synthesize photos = _photos;
@synthesize place = _place;

#define MAX_RESULTS 50

- (void) setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        [self.tableView reloadData];
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner.color = [UIColor grayColor];
    [self.spinner startAnimating];

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
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        [segue.destinationViewController setPhotoInformation:[self.photos objectAtIndex:[self.tableView indexPathForCell:sender].row]];
    }
}

@end
