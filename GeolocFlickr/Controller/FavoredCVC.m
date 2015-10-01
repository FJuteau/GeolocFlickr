//
//  FavoredCVC.m
//  GeolocFlickr
//
//  Created by François Juteau on 01/09/2015.
//  Copyright (c) 2015 François Juteau. All rights reserved.
//

#import "FavoredCVC.h"
#import "FavoredPicture+DAO.h"
#import "CustomCVC.h"
#import "FavoriteDetailVC.h"

@interface FavoredCVC ()

@property (nonatomic, strong) NSMutableArray *favoredPictures;

@end

@implementation FavoredCVC

static NSString * const reuseIdentifier = @"customCVCC";


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // Register cell classes
//    [self.collectionView registerClass:[CustomCVC class] forCellWithReuseIdentifier:@"customCVCC"];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.favoredPictures = [NSMutableArray arrayWithArray:[FavoredPicture allFavoredPictures]];
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favoredPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[CustomCVC alloc]init];
    }
    
    // Configure the cell
    FavoredPicture *favPic = [self.favoredPictures objectAtIndex:indexPath.row];
    NSData *data = [favPic imageData];
    UIImage *image = [UIImage imageWithData:data];
    
    if (image)
    {
        [[cell pictureView] setImage:image];
    }
    else
    {
        NSLog(@"PAS D'IMAGE");
    }
    
    return cell;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomCVC *)sender
{
    if ([[segue identifier] isEqual:@"FAVORITE_SELECTED_SEGUE"])
    {
        FavoriteDetailVC *destination = [segue destinationViewController];
        [destination setPictureIndex:[self.collectionView indexPathForCell:sender].row];
    }
}

@end
