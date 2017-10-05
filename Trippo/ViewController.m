//
//  ViewController.m
//  Trippo
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *screenshotView;
@property (strong, atomic) UIImage *screenshot;
@end

@implementation ViewController


- (void)configureWithImage: (NSData *)imageData {
    self.screenshot = [[UIImage alloc] initWithData:imageData];
    if (self.screenshotView != nil) {
        self.screenshotView.image = self.screenshot;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
