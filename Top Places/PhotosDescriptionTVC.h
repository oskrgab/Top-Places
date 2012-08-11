//
//  PhotosDescriptionTVC.h
//  Top Places
//
//  Created by Oscar Cortez on 8/11/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface PhotosDescriptionTVC : UITableViewController

@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSDictionary *place;

@end
