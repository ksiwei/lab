//
//  ViewController.h
//  Trippo
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController : UIViewController <G8TesseractDelegate>

-(void) configureWithImage:(NSData *)image;

@end

