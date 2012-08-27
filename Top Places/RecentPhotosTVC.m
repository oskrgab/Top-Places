//
//  RecentPhotosTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/19/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "PhotoViewController.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (NSArray *) getRecentPhotos
{
    NSArray *recentPhotos = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    return recentPhotos;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.photos = [self getRecentPhotos];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    static NSString *CellIdentifier = @"Recent Photo Description";
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
      
}


#pragma mark - Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Recent Photo"]) {
        [segue.destinationViewController setPhotoInformation:[self.photos objectAtIndex:[self.tableView indexPathForCell:sender].row]];
    }

}



@end
