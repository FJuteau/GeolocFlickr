//
//  FavoriteDetailVC.m
//  GeolocFlickr
//
//  Created by François Juteau on 02/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import "FavoriteDetailVC.h"
#import "FJReaderView.h"
#import "Picture.h"
#import "FavoredPicture+DAO.h"
#import "City.h"

@interface FavoriteDetailVC () <FJReaderViewDelegate>

@property (weak, nonatomic) IBOutlet FJReaderView *readerView;

// Liste des photos à afficher
@property (strong, nonatomic) NSArray * pictures;
@property (strong, nonatomic) FavoredPicture * pictureToDisplay;

@end

@implementation FavoriteDetailVC

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.readerView.delegate = self;
    
    self.readerView.hidden = YES;
    
    [self update];
    self.readerView.hidden = NO;
    [self.readerView showPage:self.pictureIndex animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
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
    [self.pictures enumerateObjectsUsingBlock:^(FavoredPicture *obj, NSUInteger idx, BOOL *stop)
     {
         obj.imageData = nil;
     }];
}


- (void) update
{
    // Récupération des photos
    self.pictures = [NSMutableArray arrayWithArray:[FavoredPicture allFavoredPictures]];
}

#pragma mark - ReaderView Delegate

- (UIView *)readerView:(id)sender pageAtIndex:(int)index
{
    self.pictureIndex = index;
    self.pictureToDisplay = self.pictures[index];
    
    UIView * pageView;
    
    if (self.pictureToDisplay.imageData)
    {
        UIImage * downloadedImage = [UIImage imageWithData:self.pictureToDisplay.imageData];
        
        pageView = [[UIImageView alloc] initWithImage:downloadedImage];
        pageView.contentMode = UIViewContentModeScaleAspectFit;
        
        City *currentCity = self.pictureToDisplay.where;
        
        [self.navigationItem setTitle:currentCity.name];
    }
    
    return pageView;
}


- (NSUInteger) numberOfPagesInReaderView:(id)readerView
{
    // .count : nombre d'éléments dans un tableau
    return self.pictures.count;
}


#pragma mark - Handle methods

- (IBAction)handleUnfavorite:(id)sender
{
    [FavoredPicture deleteFavoredPicture:self.pictureToDisplay];
    [FavoredPicture saveFavoredPicture];
    [self update];
    [self.readerView showPage:self.pictureIndex animated:NO];
}


@end
