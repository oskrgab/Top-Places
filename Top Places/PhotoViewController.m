//
//  PhotoViewController.m
//  Top Places
//
//  Created by Oscar Cortez on 8/13/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation PhotoViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize spinner = _spinner;


#define CUSTOM_FORMAT FlickrPhotoFormatLarge

-(UIImage *) imageForPhoto: (NSDictionary *) photo 
{
    NSData *imageData = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photo format:CUSTOM_FORMAT]];
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
@end
