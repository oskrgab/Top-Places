//
//  PhotoViewController.m
//  Top Places
//
//  Created by Oscar Cortez on 8/13/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;


#define CUSTOM_FORMAT FlickrPhotoFormatLarge

-(UIImage *) imageForPhoto: (NSDictionary *) photo 
{
    NSData *imageData = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photo format:CUSTOM_FORMAT]];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.imageView.image = [self imageForPhoto:self.photoInformation];
    self.navigationItem.title = [self.photoInformation valueForKey:FLICKR_PHOTO_TITLE];
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
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
