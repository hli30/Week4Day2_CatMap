//
//  SearchViewController.m
//  CatMap
//
//  Created by Harry Li on 2017-06-22.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    [self.delegate passInfo:self.searchTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
