//
//  NetworkingManager.h
//  CatMap
//
//  Created by Harry Li on 2017-06-20.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@class UIImage;


@interface NetworkingManager : NSObject

- (void)fetchPhotoDataWithCompletion:(void (^)(NSArray *photoData))completionHandler;
- (void)fetchCatImageForURL:(NSURL *)url completion:(void (^)(UIImage * image))completionHandler;
- (void)fetchLocationCoordinateForPhoto:(NSString *)photoId completion:(void (^)(CLLocationCoordinate2D location))completionHandler;

@end
