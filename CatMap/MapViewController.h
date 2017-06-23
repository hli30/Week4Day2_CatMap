//
//  MapViewController.h
//  CatMap
//
//  Created by Harry Li on 2017-06-20.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@class Photo;

@interface MapViewController : UIViewController

@property (nonatomic) CLLocationCoordinate2D photoCoord;
@property (nonatomic) Photo *photo;

- (void)setDetails:(Photo *)photo;

@end
