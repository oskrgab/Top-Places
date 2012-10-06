//
//  Photo+Create.m
//  Top Places
//
//  Created by Oscar Cortez on 9/27/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Place+Create.h"
#import "Tag+Create.h"

@implementation Photo (Create)

+ (Photo *) photoForFlickerInfo:(NSDictionary *)info inContext:(NSManagedObjectContext *)context
{
    Photo *photo;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [info valueForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[ descriptor ];
    
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || [matches count] > 1) {
        // handle error
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.title = [info valueForKey:FLICKR_PHOTO_TITLE];
        photo.imageURL = [[FlickrFetcher urlForPhoto:info format:FlickrPhotoFormatLarge] absoluteString];
        photo.unique = [info valueForKey:FLICKR_PHOTO_ID];
        photo.subtitle = [info valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.place = [Place placeWithName:[info objectForKey:FLICKR_PHOTO_PLACE_NAME] andCreationDate:[NSDate date] inContext:context];
        photo.tags = [Tag setOfTagswithString:[info objectForKey:FLICKR_TAGS] inContext:context];
        
    } else if ([matches count] == 1) {
        photo = [matches lastObject];
    }
    return photo;
        
}


@end
