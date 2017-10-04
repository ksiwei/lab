//
//  ViewController.m
//  Trippo
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ScreenshotView;

@end

@implementation ViewController

- (void)configureWithImage: (NSData *)imageData {
    self.ScreenshotView.image = [UIImage imageWithData:imageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
