//
//  City.h
//  GeolocFlickr
//
//  Created by orsys on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
