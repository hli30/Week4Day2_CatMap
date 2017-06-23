//
//  SearchViewController.h
//  CatMap
//
//  Created by Harry Li on 2017-06-22.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

- (void)passInfo:(NSString *)info;

@end

@interface SearchViewController : UIViewController

@property id<SearchViewControllerDelegate> delegate;

@end
