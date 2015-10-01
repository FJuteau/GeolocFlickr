//
//  AddCityViewController.h
//  GeolocFlickr
//
//  Created by François Juteau on 27/08/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreLocation;

@interface AddCityViewController : UIViewController

@property (nonatomic) NSString *cityName;
@property (nonatomic) CLLocationCoordinate2D coords;

@end
