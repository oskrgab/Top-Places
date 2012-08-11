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

@end

@implementation TopPlacesTVC

@synthesize places = _places;

-(void) setPlaces:(NSArray *)places
{
    if (_places != places) {
        _places = places;
        [self.tableView reloadData];
    }
}

-(NSArray *) places
{
    if (!_places) {
        return [[FlickrFetcher topPlaces]sortedArrayUsingComparator:
                ^(id obj1, id obj2) {
                    return [[obj1 valueForKeyPath:@"_content"] compare:[obj2 valueForKeyPath:@"_content"]];
                }];
    }
    else
        return _places;
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
    return [self.places count];
}

#define CITY 0
#define PROVINCE 1
#define COUNTRY 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *placeDescription = [[self.places objectAtIndex:indexPath.row] valueForKeyPath:@"_content"];
    NSArray *dividedDescription = [placeDescription componentsSeparatedByString:@", "];
    cell.textLabel.text = [dividedDescription objectAtIndex:CITY];
    cell.detailTextLabel.text = [[dividedDescription objectAtIndex:PROVINCE] stringByAppendingFormat:@", %@",[dividedDescription objectAtIndex:COUNTRY]];
    
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

#pragma mark - Segue 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"List Of Photos"]) {
        [segue.destinationViewController setPlace:[self.places objectAtIndex:[self.tableView indexPathForCell:sender].row]];
    }
}
@end
