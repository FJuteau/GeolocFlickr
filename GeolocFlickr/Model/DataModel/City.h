//
//  City.h
//  GeolocFlickr
//
//  Created by François Juteau on 01/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavoredPicture;

@interface City : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *favoredPictures;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addFavoredPicturesObject:(FavoredPicture *)value;
- (void)removeFavoredPicturesObject:(FavoredPicture *)value;
- (void)addFavoredPictures:(NSSet *)values;
- (void)removeFavoredPictures:(NSSet *)values;

@end
