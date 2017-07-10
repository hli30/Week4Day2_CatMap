//
//  ViewController.m
//  CatMap
//
//  Created by Harry Li on 2017-06-19.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "ViewController.h"
#import "MyCustomCollectionViewCell.h"
#import "Photo.h"
#import "MapViewController.h"
#import "NetworkingManager.h"
#import "SearchViewController.h"
@import MapKit;

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
SearchViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *photoArray;
@property (nonatomic) NetworkingManager *networkingManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkingManager = [[NetworkingManager alloc] init];
    [self fetchPhotoDataForTag:@"cat"];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)fetchPhotoDataForTag:(NSString *)tag{
    [self.networkingManager fetchPhotoDataForTag:tag withCompletion:^(NSArray *photoData) {
        self.photoArray = [NSMutableArray array];
        
        for (NSDictionary *cat in photoData) {
            Photo *catPhoto = [[Photo alloc] initWithDictionary:cat];
            [self.photoArray addObject:catPhoto];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
}


#pragma mark - Button Action

- (void)searchButtonPressed:(UIBarButtonItem *)sender{
    [self performSegueWithIdentifier:@"searchView" sender:self];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"searchView"]) {
        SearchViewController *searchVC = (SearchViewController *)[segue destinationViewController];
        searchVC.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"showDetail"]) {
        MapViewController *mapViewVC = (MapViewController *)[segue destinationViewController];
        NSIndexPath *path = (NSIndexPath *)sender;
        
        Photo *currentPhoto = self.photoArray[path.item];
        
        [mapViewVC setDetails:currentPhoto];
        mapViewVC.photoCoord = currentPhoto.coordinate;
    }
}


#pragma mark - Delegate

- (void)passInfo:(NSString *)info{
    [self fetchPhotoDataForTag:info];
    [self.collectionView reloadData];
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    if (![self.photoArray[indexPath.item] catImage]) {
        Photo *currentPhoto = self.photoArray[indexPath.item];
                        
        [self.networkingManager fetchCatImageForURL:currentPhoto.photoURL completion:^(UIImage *image) {
            currentPhoto.catImage = image;
            [self.networkingManager fetchLocationCoordinateForPhoto:currentPhoto.photoId completion:^(CLLocationCoordinate2D location) {
                currentPhoto.coordinate = location;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.catImageView.image = [self.photoArray[indexPath.item] catImage];
                }];
            }];
        }];
    } else {
        cell.catImageView.image = [self.photoArray[indexPath.item] catImage];
    }
    
    cell.catLabel.text = [self.photoArray[indexPath.item] title];
    
    return cell;
}


#pragma mark - CollectionView didSelect

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

@end
