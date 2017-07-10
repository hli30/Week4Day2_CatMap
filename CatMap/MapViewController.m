//
//  MapViewController.m
//  CatMap
//
//  Created by Harry Li on 2017-06-20.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "MapViewController.h"
#import "Photo.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self configureView];
}

- (void)setDetails:(Photo *)photo{
    _photo = photo;
    [self configureView];
}

- (void)configureView{
    self.navigationItem.title = self.photo.title;
    self.photoCoord = self.photo.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
    self.mapView.region = MKCoordinateRegionMake(self.photoCoord, span);
    [self.mapView addAnnotation:self.photo];
}

@end
