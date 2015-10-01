//
//  FavoredPicture+DAO.h
//  GeolocFlickr
//
//  Created by François Juteau on 01/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import "FavoredPicture.h"

@interface FavoredPicture (DAO)

// insert
+(FavoredPicture *)newWithImage:(NSData *)_image fromUrl:(NSURL *)_url fromCity:(NSString *)_city;

// delete
+(void)deleteFavoredPicture:(FavoredPicture *)picture;

// get all cities
+(NSArray *)allFavoredPictures;

// Save the city in the context
+(void)saveFavoredPicture;

@end
