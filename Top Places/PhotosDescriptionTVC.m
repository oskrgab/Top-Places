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
@end

@implementation PhotosDescriptionTVC
@synthesize photos = _photos;
@synthesize place = _place;

#define MAX_RESULTS 10

-(NSArray *) photos
{
    if (!_photos) {
        return [FlickrFetcher photosInPlace:self.place maxResults:MAX_RESULTS];
    }
    else
        return _photos;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
