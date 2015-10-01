//
//  NetworkManager.h
//  test
//
//  Created by François Juteau on 04/09/2015.
//  Copyright (c) 2015 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myCompletion)(NSData *data);

@interface NetworkManager : NSObject

+(void)getDataFromUrl:(NSURL *)url withCompletion:(myCompletion)compblock;

@end
