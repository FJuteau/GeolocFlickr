//
//  City+DAO.m
//  GeolocFlickr
//
//  Created by François Juteau on 23/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "City+DAO.h"
#import "AppDelegate.h"
#import "CityLocalizer.h"

@implementation City (DAO)

+ (NSManagedObjectContext *)database
{
    // permet de récupéré la base de donnée
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    return context;
}


+(City *)newWithName:(NSString *)_name
{
    NSManagedObjectContext * database = [self database];
    City * city = [NSEntityDescription insertNewObjectForEntityForName:@"City"
                                                inManagedObjectContext:database];
    
    if ([_name isEqual:@""]) // Si on active la localisation
    {
        [CityLocalizer localize:city];
    }
    else
    {
        [city setName:_name];
    }
    
    return city;
}


+(void)deleteCity:(City *)city
{
    NSManagedObjectContext * database = [self database];
    [database deleteObject:city];
    
    NSError *error;
    [database save:&error];
    if (error)
    {
        NSLog(@"*************ERROR SAVING DELETE");
    }
}


+(City *)getCityForName:(NSString *)_name
{
    NSManagedObjectContext * database = [self database];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"City"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", _name];
    
    return [[database executeFetchRequest:request error:nil] firstObject];
}


+(NSArray *)allCities
{
    NSManagedObjectContext * database = [self database];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"City"];
    
    return [database executeFetchRequest:request error:nil];
}

-(void)saveCity
{
    NSError *error;
    [[City database] save:&error];
    if (error)
    {
        NSLog(@"*************ERROR SAVING ADD");
    }
}

@end

