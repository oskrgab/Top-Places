//
//  Photo+Deletion.m
//  Top Places
//
//  Created by Oscar Cortez on 10/4/12.
//  Copyright (c) 2012 Oscar Cortez. All rights reserved.
//

#import "Photo+Deletion.h"
#import "Tag+Create.h"

@implementation Photo (Deletion)

- (void) prepareForDeletion
{
    for (Tag *aTag in self.tags) {
        aTag.numberOfPhotos = @([aTag.numberOfPhotos integerValue] - 1);
    }
}
@end
