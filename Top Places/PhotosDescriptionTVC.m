//
//  PhotosDescriptionTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/11/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotosDescriptionTVC.h"

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    NSLog(@"%@",self.photos);
    NSString *photoTitle, *photoDescription;

    photoTitle = [[self.photos objectAtIndex:indexPath.row]valueForKeyPath:FLICKR_PHOTO_TITLE];
    photoDescription = [[self.photos objectAtIndex:indexPath.row]valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if (photoTitle){
        cell.textLabel.text = photoTitle;
        cell.detailTextLabel.text = photoDescription;
    }
    else if (photoDescription){
        cell.textLabel.text = photoTitle;
    }
    else
        cell.textLabel.text = @"Unknown";
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
