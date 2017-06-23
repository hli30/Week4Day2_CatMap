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
@property (nonatomic) NSMutableArray *catPhotoArray;
@property (nonatomic) NetworkingManager *networkingManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkingManager = [[NetworkingManager alloc] init];
    
    [self.networkingManager fetchPhotoDataWithCompletion:^(NSArray *photoData) {
        self.catPhotoArray = [NSMutableArray array];
        
        for (NSDictionary *cat in photoData) {
            Photo *catPhoto = [[Photo alloc] initWithDictionary:cat];
            [self.catPhotoArray addObject:catPhoto];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)searchButtonPressed:(UIBarButtonItem *)sender{
    [self performSegueWithIdentifier:@"searchView" sender:self];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"searchView"]) {
        SearchViewController *searchVC = (SearchViewController *)[segue destinationViewController];
        searchVC.delegate = self;
    }
}


#pragma mark - Delegate

- (void)passInfo:(NSString *)info{
    
    
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.catPhotoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    if (![self.catPhotoArray[indexPath.item] catImage]) {
        Photo *currentPhoto = self.catPhotoArray[indexPath.item];
                        
        [self.networkingManager fetchCatImageForURL:currentPhoto.photoURL completion:^(UIImage *image) {
//            MyCustomCollectionViewCell * cell = (MyCustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            currentPhoto.catImage = image;
            [self.networkingManager fetchLocationCoordinateForPhoto:currentPhoto.photoId completion:^(CLLocationCoordinate2D location) {
                currentPhoto.coordinate = location;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.catImageView.image = [self.catPhotoArray[indexPath.item] catImage];
                }];
            }];
        }];
    } else {
        cell.catImageView.image = [self.catPhotoArray[indexPath.item] catImage];
    }
    
    cell.catLabel.text = [self.catPhotoArray[indexPath.item] title];
    
    return cell;
}


#pragma mark - CollectionView didSelect

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MapViewController *mapViewVC = [[MapViewController alloc] init];
    Photo *currentPhoto = self.catPhotoArray[indexPath.item];
    
    [mapViewVC setDetails:currentPhoto];
//    mapViewVC.photoCoord = currentPhoto.coordinate;
    [self.navigationController pushViewController:mapViewVC animated:YES];
}



//- (NSURL *)buildURL{
//    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=525ee4cddb2e8d117d3e680cde6cb0ae&tags=cat&has_geo=1&extras=url_m&format=json&nojsoncallback=1"];
//    
//    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
//    
//    urlComponents.host = @"api.flickr.com";
//    urlComponents.path = @"/services/rest/";
//    
//    NSURLQueryItem *methodItem = [NSURLQueryItem queryItemWithName:@"method"
//                                                             value:@"flickr.photos.search"];
//    NSURLQueryItem *apiKeyItem = [NSURLQueryItem queryItemWithName:@"api_key"
//                                                             value:@"525ee4cddb2e8d117d3e680cde6cb0ae"];
//    NSURLQueryItem *tagItem = [NSURLQueryItem queryItemWithName:@"tags"
//                                                          value:@"cat"];
//    NSURLQueryItem *hasGeoItem = [NSURLQueryItem queryItemWithName:@"has_geo"
//                                                             value:@"1"];
//    NSURLQueryItem *extrasItem = [NSURLQueryItem queryItemWithName:@"extras"
//                                                             value:@"url_m"];
//    NSURLQueryItem *formatItem = [NSURLQueryItem queryItemWithName:@"format"
//                                                             value:@"json&nojsoncallback=1"];
//    
//    urlComponents.queryItems = @[methodItem, apiKeyItem, tagItem, hasGeoItem, extrasItem, formatItem];
//    NSURL *url = [urlComponents URL];
//    
//    return url;
//}

@end
