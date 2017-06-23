//
//  Photo.m
//  CatMap
//
//  Created by Harry Li on 2017-06-19.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "Photo.h"
@import CoreLocation;

@implementation Photo

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _title = dict[@"title"];
        _photoId = dict[@"id"];
        _photoURL = [self generateURL:dict];
    }
    return self;
}

-(NSURL *)generateURL:(NSDictionary *)dict{
    NSString *farm = dict[@"farm"];
    NSString *server = dict[@"server"];
    NSString *photoId = self.photoId;
    NSString *secret = dict[@"secret"];
    
    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, photoId, secret];
    
    NSURL *photoURL = [NSURL URLWithString:urlString];
    
    return photoURL;
}






@end
