//
//  FlickrPicturesService.m
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "FlickrPicturesService.h"
#import "Picture.h"

static NSString * key = @"5d1b1e5f14198d772bba0c3f57605fd5";

@implementation FlickrPicturesService

- (NSArray *) picturesAroundLocation:(PicturesServiceLocation)location
{
    // creer l'url a appeler
    NSString * url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%f&lon=%f&format=json&nojsoncallback=1", key, location.latitude, location.longitude];
    
    // Telechargement
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    // Parsing du JSON
    NSDictionary * jsonAnswer;
    // Si JSONObjectWithData prend un data "nil", alors l'app plante
    @try {
        jsonAnswer = [NSJSONSerialization JSONObjectWithData:data
                                                     options:0
                                                       error:nil];
    }
    @catch (NSException *exception) {
        // no internet
    }
    
    
    NSArray * photoDicts = jsonAnswer[@"photos"][@"photo"];
    
    // Création du tableau de Picture
    NSMutableArray * array =[[NSMutableArray alloc] init];
    
    for (NSDictionary * item in photoDicts)
    {
        Picture * p = [[Picture alloc] init];
        p.title = item[@"title"];
        p.url = [self urlForPictureWithFrame:item[@"farm"] server:item[@"server"] identifier:item[@"id"] secret:item[@"secret"]];
        
        [array addObject:p];
    }
    
    // !!!! On n'utilise pas d'array mutable en paramètre pour qu'il ne hange pas trop de taille !!!
    return [array copy];
}

- (NSURL *) urlForPictureWithFrame:(NSNumber *)frame
                             server:(NSString *)server
                         identifier:(NSString *)identifier
                             secret:(NSString *)secret
{
    NSString * url = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", frame, server, identifier, secret];
    
    return [NSURL URLWithString:url];
}
    
@end
