//
//  CacheImageManager.m
//  test
//
//  Created by François Juteau on 04/09/2015.
//  Copyright (c) 2015 FJ. All rights reserved.
//

#import "CacheImageManager.h"
#import "NetworkManager.h"

static NSCache *imagesCache;

@implementation CacheImageManager

+(void)getImageFromUrlPath:(NSString *)urlPath withCompletion:(cacheImageCompletion)compblock
{
    if (!imagesCache) {
        imagesCache = [[NSCache alloc] init];
    }
    
    if (![imagesCache objectForKey:urlPath])
    {
        NSURL *imageUrl = [NSURL URLWithString:urlPath];
        [NetworkManager getDataFromUrl:imageUrl withCompletion:^(NSData *data)
        {
            if (data)
            {
                [imagesCache setObject:[UIImage imageWithData:data] forKey:urlPath];
                compblock([imagesCache objectForKey:urlPath]);
            }
            else
            {
                NSLog(@"CACHE IMAGE MANAGER : NO DATA");
            }
            
        }];
    }
    else
    {
         compblock([imagesCache objectForKey:urlPath]);
    }
}

@end
