//
//  CacheImageManager.h
//  test
//
//  Created by François Juteau on 04/09/2015.
//  Copyright (c) 2015 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^cacheImageCompletion)(UIImage *image);

@interface CacheImageManager : NSObject

+(void)getImageFromUrlPath:(NSString *)urlPath withCompletion:(cacheImageCompletion)compblock;

@end
