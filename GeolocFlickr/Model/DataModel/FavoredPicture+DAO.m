//
//  FavoredPicture+DAO.m
//  GeolocFlickr
//
//  Created by François Juteau on 01/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FavoredPicture+DAO.h"
#import "AppDelegate.h"
#import "City+DAO.h"

@implementation FavoredPicture (DAO)

+ (NSManagedObjectContext *)database
{
    // permet de récupéré la base de donnée
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    return context;
}

// insert
+(FavoredPicture *)newWithImage:(NSData *)_image fromUrl:(NSURL *)_url fromCity:(NSString *)_city
{
    NSManagedObjectContext *database = [self database];
    FavoredPicture *picture = [NSEntityDescription insertNewObjectForEntityForName:@"FavoredPicture"
                                          inManagedObjectContext:database];
    
    [picture setUrl:[NSString stringWithFormat:@"%@",_url]];
    [picture setImageData:_image];
    
    City *favCity = [City getCityForName:_city];
    [favCity addFavoredPicturesObject:picture];
    
    return picture;
}

// delete
+(void)deleteFavoredPicture:(FavoredPicture *)picture
{
    NSManagedObjectContext * database = [self database];
    [database deleteObject:picture];
    
    NSError *error;
    [database save:&error];
    if (error)
    {
        NSLog(@"*************ERROR SAVING DELETE");
    }
}

// get all cities
+(NSArray *)allFavoredPictures
{
    NSManagedObjectContext * database = [self database];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"FavoredPicture"];
    
    return [database executeFetchRequest:request error:nil];
}

// Save the city in the context
+(void)saveFavoredPicture
{
    NSError *error;
    [[FavoredPicture database] save:&error];
    if (error)
    {
        NSLog(@"*************ERROR SAVING ADD");
    }
}

@end
