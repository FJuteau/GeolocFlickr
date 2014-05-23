//
//  City+DAO.h
//  GeolocFlickr
//
//  Created by orsys on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "City.h"

@interface City (DAO)

// insert
+ (id) new;

// delete
+ (void) deleteCity:(City *)city;

// get all cities
+  (NSArray *) allCities;

@end
