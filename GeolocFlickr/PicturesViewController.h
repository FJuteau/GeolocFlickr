//
//  PicturesViewController.h
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPicturesService.h"

@interface PicturesViewController : UIViewController

@property (assign, readwrite, nonatomic) PicturesServiceLocation location;

@end
