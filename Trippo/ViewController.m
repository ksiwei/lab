//
//  ViewController.m
//  Trippo
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import "ViewController.h"
#import "Trippo-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *screenshotView;
@property (strong, atomic) UIImage *screenshot;
@property (weak, nonatomic) IBOutlet UILabel *recognizedLabel;
@end

@implementation ViewController


- (void)configureWithImage: (NSData *)imageData {
    self.screenshot = [[UIImage alloc] initWithData:imageData];
    if (self.screenshotView != nil) {
        self.screenshotView.image = self.screenshot;

        
        // Languages are used for recognition (e.g. eng, ita, etc.). Tesseract engine
        // will search for the .traineddata language file in the tessdata directory.
        // For example, specifying "eng+ita" will search for "eng.traineddata" and
        // "ita.traineddata". Cube engine will search for "eng.cube.*" files.
        // See https://github.com/tesseract-ocr/tessdata.
        
        // Create your G8Tesseract object using the initWithLanguage method:
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        
        // Optionaly: You could specify engine to recognize with.
        // G8OCREngineModeTesseractOnly by default. It provides more features and faster
        // than Cube engine. See G8Constants.h for more information.
        //tesseract.engineMode = G8OCREngineModeTesseractOnly;
        
        // Set up the delegate to receive Tesseract's callbacks.
        // self should respond to TesseractDelegate and implement a
        // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
        // method to receive a callback to decide whether or not to interrupt
        // Tesseract before it finishes a recognition.
        tesseract.delegate = self;
        
        // Optional: Limit the character set Tesseract should try to recognize from
        tesseract.charWhitelist = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,. :\'\"\\@#!-";
        
        // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
        // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
        // See G8TesseractParameters.h for a complete list of Tesseract variables
        
        // Optional: Limit the character set Tesseract should not try to recognize from
        //tesseract.charBlacklist = @"OoZzBbSs";
        
        // Specify the image Tesseract should recognize on
        tesseract.image = [self.screenshot g8_blackAndWhite];
        
        // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
        tesseract.rect = CGRectMake(0, 40, 1000, 1000);
        
        // Optional: Limit recognition time with a few seconds
        //tesseract.maximumRecognitionTime = 10.0;
        
        // Start the recognition
        [tesseract recognize];
        
        // Retrieve the recognized text
        NSString *text = [tesseract recognizedText];
        NSLog(@"%@", text);
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        int lineNumber = 0;
        NSString *labelText = @"";
        NSScanner *lineScanner = [NSScanner scannerWithString:text];
        while ( ![lineScanner isAtEnd] )
        {
            lineNumber++;
            NSString *line;
            [lineScanner scanUpToString:@"\n" intoString:&line];
            if ( line.length > 10 ) {
                int tokenNumber = 0;
                NSScanner *tokenScanner = [NSScanner scannerWithString:line];
                bool areTokensValid = YES;
                NSString *labelLine = @"";
                while ( ![tokenScanner isAtEnd])
                {
                    tokenNumber++;
                    NSString *token;
                    [tokenScanner scanUpToCharactersFromSet:whitespace intoString:&token];
                    if (token.length < 2 && ![token isEqualToString:@"a"] && ![token isEqualToString:@"A"]) {
                        areTokensValid = NO;
                    }
                    NSLog( @"line %d:token %d: %@", lineNumber, tokenNumber, token );
                    labelLine = [labelLine stringByAppendingString:@" "];
                    labelLine = [labelLine stringByAppendingString:token];
                }
                if (areTokensValid) {
                    labelText = [labelText stringByAppendingString:labelLine];
                    labelText = [labelText stringByAppendingString:@"\n"];
                }
            }
        }
        LocationTagger *tagger = [[LocationTagger alloc] init];
        NSString *results = [tagger tagLocationsfromScriptWithText:labelText];
        NSLog(@"results %@", results);
        self.recognizedLabel.text = results;

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
