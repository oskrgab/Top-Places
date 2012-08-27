//
//  TopPlacesTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 8/10/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "PhotosDescriptionTVC.h"

@interface TopPlacesTVC () 
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation TopPlacesTVC
@synthesize spinner = _spinner;

@synthesize places = _places;

-(void) setPlaces:(NSArray *)places
{
    if (_places != places) {
        _places = places;
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

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    dispatch_queue_t placesDownloadQueue = dispatch_queue_create("places downloader", NULL);
    dispatch_async(placesDownloadQueue, ^{
        self.places = [[FlickrFetcher topPlaces]sortedArrayUsingComparator:
                       ^(id obj1, id obj2) {
                           return [[obj1 valueForKeyPath:@"_content"] compare:[obj2 valueForKeyPath:@"_content"]];
                       }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        });
    });
    
    dispatch_release(placesDownloadQueue);

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
}


@end
