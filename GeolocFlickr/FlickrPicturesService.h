//
//  FlickrPicturesService.h
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    double longitude;
    double latitude;
} PicturesServiceLocation;

@interface FlickrPicturesService : NSObject

- (NSArray *) picturesAroundLocation:(PicturesServiceLocation) location;

@end
