//
//  NetworkingManager.m
//  CatMap
//
//  Created by Harry Li on 2017-06-20.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "NetworkingManager.h"
@import UIKit;

@implementation NetworkingManager

//Get image data
-(void)fetchPhotoDataForTag:(NSString *)tag withCompletion:(void (^)(NSArray *photoData))completionHandler{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=525ee4cddb2e8d117d3e680cde6cb0ae&tags=%@&has_geo=1&extras=url_m&format=json&nojsoncallback=1", tag];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        NSDictionary *photoDictionary = jsonDictionary[@"photos"];
        NSArray *catArray = photoDictionary[@"photo"];
        
        completionHandler(catArray);
    }];
    
    [dataTask resume];
}

//Download images
- (void)fetchCatImageForURL:(NSURL *)url completion:(void (^)(UIImage * image))completionHandler{
    NSURL *photoURL= url;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:photoURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        completionHandler(image);
    }];
    
    [downloadTask resume];
}

//Get location data
-(void)fetchLocationCoordinateForPhoto:(NSString *)photoId completion:(void (^)(CLLocationCoordinate2D location))completionHandler{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=525ee4cddb2e8d117d3e680cde6cb0ae&photo_id=%@&format=json&nojsoncallback=1",photoId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        NSDictionary *photoDictionary = jsonDictionary[@"photo"];
        NSDictionary *locationDictionary = photoDictionary[@"location"];
        NSNumber *latitude = [locationDictionary objectForKey:@"latitude"];
        NSNumber *longitude = [locationDictionary objectForKey:@"longitude"];
        
        CLLocationCoordinate2D photoLocation = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        
        completionHandler(photoLocation);
    }];
    
    [dataTask resume];
}

@end
