//
//  CityLocalizer.m
//  GeolocFlickr
//
//  Created by orsys on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "CityLocalizer.h"

@import CoreLocation;

@interface CityLocalizer() <CLLocationManagerDelegate>

@property (strong, nonatomic) City * city;
@property (strong, nonatomic) CLLocationManager * locationManager;

@end

@implementation CityLocalizer

static NSMutableArray * LivingInstance;

+ (void) localize:(City *)city
{
    CityLocalizer* localizer = [[CityLocalizer alloc]init];
    localizer.city = city;
    localizer.locationManager = [[CLLocationManager alloc] init];
    localizer.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    localizer.locationManager.delegate = localizer;
    [localizer.locationManager startUpdatingLocation];
    
    if (!LivingInstance)
    {
        LivingInstance = [[NSMutableArray alloc] init];
    }
    
    [LivingInstance addObject:localizer];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * lastKownLocation = [locations lastObject];
    
    [manager stopUpdatingLocation];
    
    self.city.longitude = @(lastKownLocation.coordinate.longitude);
    self.city.latitude = @(lastKownLocation.coordinate.latitude);
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:lastKownLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark * firstPlaceMark = [placemarks firstObject];
                       self.city.name = firstPlaceMark.locality;
                       
                       [LivingInstance removeObject:self];
                   }];
}
@end
