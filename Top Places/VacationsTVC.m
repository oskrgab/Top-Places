//
//  VacationsTVC.m
//  Top Places
//
//  Created by Oscar Cortez on 9/25/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "VacationsTVC.h"

@interface VacationsTVC ()
@property (nonatomic, strong) NSArray *vacations; // A string with vacation names that are stored in the documents directory
@end

@implementation VacationsTVC

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
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:3];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    self.vacations = [manager contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[ NSURLLocalizedNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
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
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if ([self.vacations count] > 0) {
        cell.textLabel.text = [[[self.vacations objectAtIndex:indexPath.row] resourceValuesForKeys:@[NSURLLocalizedNameKey] error:nil] valueForKey:NSURLLocalizedNameKey];
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
