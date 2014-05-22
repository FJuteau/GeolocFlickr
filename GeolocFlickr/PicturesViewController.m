//
//  PicturesViewController.m
//  GeolocFlickr
//
//  Created by orsys on 22/05/2014.
//  Copyright (c) 2014 François Juteau. All rights reserved.
//

#import "PicturesViewController.h"
#import "FJReaderView.h"
#import "Picture.h"
#import "FlickrPicturesService.h"

@interface PicturesViewController () <FJReaderViewDelegate>

@property (weak, nonatomic) IBOutlet FJReaderView *ReaderView;

// Liste des photos à afficher
@property (strong, nonatomic) NSArray * pictures;

@end

@implementation PicturesViewController

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
    
    //[self update];
}

- (void) update
{
    // Lieu (temporaire)
    PicturesServiceLocation location;
    location.longitude = 0;
    location.latitude = 0;
    
    // Récupération des photos
    FlickrPicturesService * fetcher = [[FlickrPicturesService alloc] init];
    self.pictures = [fetcher picturesAroundLocation:location];
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
    
    // KVC
//    [self.pictures makeObjectsPerformSelector:@selector(setImageData:) withObject:nil];
    
    // block API
//    [self.pictures enumerateObjectsUsingBlock:^(Picture obj, NSUInteger idx, BOOL *stop) {
//        obj.imageData = nil;
//    }];
}

- (UIView *) readerView:(id)sender pageAtIndex:(int)index
{
    Picture * pictureToDisplay = self.pictures[index];
    NSURL * urlForPictureToDisplay = pictureToDisplay.url;
    
    NSData * dataFromDownloadedPicture;
    // Si la data existe déjà, on l'utilise, sinon on la télécharge
    if (pictureToDisplay.imageData)
    {
        dataFromDownloadedPicture = pictureToDisplay.imageData;
    }
    else
    {
        dataFromDownloadedPicture = [NSData dataWithContentsOfURL:urlForPictureToDisplay];
        pictureToDisplay.imageData = dataFromDownloadedPicture;
    }
    
    UIImage * downloadedImage = [UIImage imageWithData:dataFromDownloadedPicture];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:downloadedImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

- (int) numberOfPagesInReaderView:(id)readerView
{
    // .count : nombre d'éléments dans un tableau
    return self.pictures.count;
    
}

@end
