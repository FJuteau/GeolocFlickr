//
//  CityLocalizer.h
//  GeolocFlickr
//
//  Created by orsys on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface CityLocalizer : NSObject

+ (void) localize:(City *)city;

@end
