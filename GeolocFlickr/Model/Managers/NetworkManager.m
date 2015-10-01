//
//  NetworkManager.m
//  test
//
//  Created by François Juteau on 04/09/2015.
//  Copyright (c) 2015 FJ. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager

+(void)getDataFromUrl:(NSURL *)url withCompletion:(myCompletion)compblock
{
    dispatch_queue_t globalHighQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(globalHighQ,^
                   {
                       // Code à executer en async.
                       NSData *data = [NSData dataWithContentsOfURL:url];
                       
                       // CallBack dans la MainQueue
                       dispatch_async(dispatch_get_main_queue(),^
                                      {
                                          compblock(data);
                                      });
                       
                   });
}

@end
