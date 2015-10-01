//
//  City+DAO.h
//  GeolocFlickr
//
//  Created by François Juteau on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "City.h"

@interface City (DAO)

// insert
+(City *)newWithName:(NSString *)_name;

// delete
+(void)deleteCity:(City *)city;

+(City *)getCityForName:(NSString *)_name;

// get all cities
+(NSArray *)allCities;

// Save the city in the context
-(void)saveCity;

@end
