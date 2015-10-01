//
//  FavoredPicture.h
//  GeolocFlickr
//
//  Created by François Juteau on 01/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface FavoredPicture : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) City *where;

@end
