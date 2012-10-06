//
//  PhotoViewController.m
//  Top Places
//
//  Created by Oscar Cortez on 8/13/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotoViewController.h"
#import "DataCache.h"
#import "VacationHelper.h"
#import "Photo+Create.h"
#import "VisitUnvisitButtonHelper.h"
#import "FlickrFetcher.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *currentVacation;
@end

@implementation PhotoViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize spinner = _spinner;


#define CUSTOM_FORMAT FlickrPhotoFormatLarge

-(UIImage *) imageForPhoto: (NSDictionary *) photo 
{
    DataCache *myCache = [[DataCache alloc] init];
    NSData *imageData;
    
    if ([myCache URLForFile:[photo valueForKey:FLICKR_PHOTO_ID]]) {
        imageData = [NSData dataWithContentsOfURL:[myCache URLForFile:[photo valueForKey:FLICKR_PHOTO_ID]]];
    }
    else {
        imageData = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photo format:CUSTOM_FORMAT]];
        [myCache cacheData:imageData withName:[photo valueForKey:FLICKR_PHOTO_ID]];
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}


- (void) viewWillAppear:(BOOL)animated
{
    self.scrollView.delegate = self;
    dispatch_queue_t photoDownloader = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(photoDownloader, ^{
        UIImage *image = [self imageForPhoto:self.photoInformation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
            self.imageView.image = image;
            self.navigationItem.title = [self.photoInformation valueForKey:FLICKR_PHOTO_TITLE];
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            self.scrollView.contentSize = self.imageView.image.size;

        });
    });
    dispatch_release(photoDownloader);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner.color = [UIColor grayColor];
    [self.spinner startAnimating];
    if (self.currentVacation)
        if (![VisitUnvisitButtonHelper isPhoto:self.photoInformation inVacation:self.currentVacation])
            self.navigationItem.rightBarButtonItem.title = @"Visit";
        else
            self.navigationItem.rightBarButtonItem.title = @"Unvisit";
    else
        self.navigationItem.rightBarButtonItem.title = @"Visit";
        
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (IBAction)visitUnvisitPressed:(UIBarButtonItem *)sender {
    
        // Choose a vacation from the url's of vacation in the directory, then use their localizedNameKey property in its URL to retrieve the vacation Name and open it
    NSString *vacation = @"My Vacations";
    self.currentVacation = vacation;
    
    if (![VisitUnvisitButtonHelper isPhoto:self.photoInformation inVacation:self.currentVacation]) {
        [VisitUnvisitButtonHelper visitPhoto:self.photoInformation forVacation:self.currentVacation];
        self.navigationItem.rightBarButtonItem.title = @"Unvisit";
    }
    else {
        [VisitUnvisitButtonHelper unvisitPhoto:self.photoInformation forVacation:self.currentVacation];
        self.navigationItem.rightBarButtonItem.title = @"Visit";
    }
    
}

@end
