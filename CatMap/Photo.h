//
//  Photo.h
//  CatMap
//
//  Created by Harry Li on 2017-06-19.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject <MKAnnotation>

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *photoId;
@property (nonatomic, strong) UIImage *catImage;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *) dict;

@end
