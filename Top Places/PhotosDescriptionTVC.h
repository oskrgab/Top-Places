//
//  PhotosDescriptionTVC.h
//  Top Places
//
//  Created by Oscar Cortez on 8/11/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RECENT_PHOTOS_KEY @"PhotosDescriptionTVC.RecentPhotos"

@interface PhotosDescriptionTVC : UITableViewController 

@property (nonatomic,strong) NSDictionary * place;
@property (nonatomic,strong) NSArray *photos; // Collection of Dictionaries with the photo's description
@end