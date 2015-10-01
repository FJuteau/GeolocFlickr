//
//  PicturesViewController.m
//  GeolocFlickr
//
//  Created by François Juteau on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "PicturesViewController.h"
#import "FJReaderView.h"
#import "Picture.h"
#import "FavoredPicture+DAO.h"
#import "CacheImageManager.h"

@interface PicturesViewController () <FJReaderViewDelegate>

@property (weak, nonatomic) IBOutlet FJReaderView *ReaderView;

// Liste des photos à afficher
@property (strong, nonatomic) NSArray * pictures;
@property (strong, nonatomic) Picture * pictureToDisplay;

@end

@implementation PicturesViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ReaderView.delegate = self;
    
    self.ReaderView.hidden = YES;
    
    dispatch_queue_t netQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(netQ,
    ^{
        // Code à executer en async.
        [self update];
        
        // CallBack dans la MainQueue
        dispatch_async(dispatch_get_main_queue(),
        ^{
            self.ReaderView.hidden = NO;
            if (self.pictures.count>0)
            {
                [self.ReaderView showPage:0 animated:NO];
            }
            
        });
                       
    });
    
    [self update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // for in
    for (Picture * p in self.pictures)
    {
        p.imageData = nil;
    }
    
//     KVC
    [self.pictures makeObjectsPerformSelector:@selector(setImageData:) withObject:nil];
    
//     block API
    [self.pictures enumerateObjectsUsingBlock:^(Picture *obj, NSUInteger idx, BOOL *stop)
    {
            obj.imageData = nil;
        }];
}


- (void) update
{
    // Récupération des photos
    FlickrPicturesService * fetcher = [[FlickrPicturesService alloc] init];
    self.pictures = [fetcher picturesAroundLocation:self.location];
}

#pragma mark - ReaderView Delegate

- (UIView *)readerView:(id)sender pageAtIndex:(int)index
{
    self.pictureToDisplay = self.pictures[index];
    
    UIView * pageView;
    

    
    if (self.pictureToDisplay.imageData)
    {
        UIImage * downloadedImage = [UIImage imageWithData:self.pictureToDisplay.imageData];
        
         pageView = [[UIImageView alloc] initWithImage:downloadedImage];
        pageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        dispatch_queue_t netQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(netQ,
       ^{
           // Code à executer en async.
           NSData * data = [NSData dataWithContentsOfURL:self.pictureToDisplay.url];
           
           // CallBack dans la MainQueue
           dispatch_async(dispatch_get_main_queue(),
              ^{
                  self.pictureToDisplay.imageData = data;
                  
                  [self.ReaderView showPage:index animated:NO];
              });
           
       });
        
        pageView = [[UIView alloc] init];
        pageView.backgroundColor = [UIColor blackColor];
        
        UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] init];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [spinner startAnimating];
        spinner.center = CGPointMake(pageView.bounds.size.width / 2, pageView.bounds.size.height / 2);
        spinner.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin;
        
        [pageView addSubview:spinner];
        
    }
    
    return pageView;
}


- (NSUInteger) numberOfPagesInReaderView:(id)readerView
{
    // .count : nombre d'éléments dans un tableau
    return self.pictures.count;
    
}


#pragma mark - Handle methods

- (IBAction)handleFavorite:(id)sender
{
    [FavoredPicture newWithImage:self.pictureToDisplay.imageData fromUrl:self.pictureToDisplay.url fromCity:self.tabBarItem.title];
    [FavoredPicture saveFavoredPicture];
}


@end
