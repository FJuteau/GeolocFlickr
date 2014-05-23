//
//  City+DAO.m
//  GeolocFlickr
//
//  Created by orsys on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "City+DAO.h"
#import "AppDelegate.h"
#import "CityLocalizer.h"

@implementation City (DAO)

+ (NSManagedObjectContext *) database
{
    // permet de récupéré la base de donnée
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    return context;
}

+(id) new
{
    NSManagedObjectContext * database = [self database];
    City * city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:database];
//
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // temporaire
//        city.name = @"Paris";
//        city.latitude = @48.51;
//        city.longitude = @2.21;
//    });
    
    [CityLocalizer localize:city];
    
    
    return city;
}

+(void)deleteCity:(City *)city
{
    NSManagedObjectContext * database = [self database];
    [database deleteObject:city];
}

+(NSArray *)allCities
{
    NSManagedObjectContext * database = [self database];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"City"];
    
    return [database executeFetchRequest:request error:nil];
}

@end

