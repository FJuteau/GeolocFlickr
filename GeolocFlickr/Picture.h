//
//  Picture.h
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSURL * url;

@property (strong, nonatomic) NSData * imageData;
@end
