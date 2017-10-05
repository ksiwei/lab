//
//  ShareViewController.m
//  TrippoShare
//
//  Created by Siwei Kang on 10/4/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#define HIDE_POST_DIALOG

@interface ShareViewController ()

@end

@implementation ShareViewController

NSUInteger m_inputItemCount = 0; // Keeps track of the number of attachments we have opened asynchronously.
NSString * m_invokeArgs = NULL;  // A string to be passed to your AIR app with information about the attachments.
NSString * APP_SHARE_GROUP = @"group.com.trippo";
const NSString * APP_SHARE_URL_SCHEME = @"trippo";
CGFloat m_oldAlpha = 1.0; // Keeps the original transparency of the Post dialog for when we want to hide it.

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}


- ( void ) didSelectPost
{
    [ self passSelectedItemsToApp ];
    // Note: This call is expected to be made here. Ignore it. We'll tell the host we are done after we've invoked the app.
    [ self.extensionContext completeRequestReturningItems: @[] completionHandler: nil ];
}
- ( void ) addImagePathToArgumentList: ( NSString * ) imagePath
{
    assert( NULL != imagePath );
    
    // The list of arguments we will pass to the AIR app when we invoke it.
    // It will be a comma-separated list of file paths: /path/to/image1.jpg,/path/to/image2.jpg
    if ( NULL == m_invokeArgs )
    {
        m_invokeArgs = imagePath;
    }
    else
    {
        m_invokeArgs = [ NSString stringWithFormat: @"%@,%@", m_invokeArgs, imagePath ];
    }
}

- ( NSString * ) saveImageToAppGroupFolder: ( UIImage * ) image
                                imageIndex: ( int ) imageIndex
{
    assert( NULL != image );
    
    NSData * jpegData = UIImageJPEGRepresentation( image, 1.0 );
    
    NSURL * containerURL = [ [ NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: APP_SHARE_GROUP ];
    NSString * documentsPath = containerURL.path;
    
    // Note that we aren't using massively unique names for the files in this example:
    NSString * fileName = [ NSString stringWithFormat: @"image%d.jpg", imageIndex ];
    
    NSString * filePath = [ documentsPath stringByAppendingPathComponent: fileName ];
    [ jpegData writeToFile: filePath atomically: YES ];
    NSLog(@"Share: file path %@", filePath);
    //Mahantesh -- Store image url to NSUserDefaults
    
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:APP_SHARE_GROUP];
    [defaults setObject:filePath forKey:@"url"];
    [defaults synchronize];
    
    return filePath;
}

- ( void ) passSelectedItemsToApp
{
    NSExtensionItem * item = self.extensionContext.inputItems.firstObject;
    
    // Reset the counter and the argument list for invoking the app:
    m_invokeArgs = NULL;
    m_inputItemCount = item.attachments.count;
    
    // Iterate through the attached files
    for ( NSItemProvider * itemProvider in item.attachments )
    {
        // Check if we are sharing a Image
        if ( [ itemProvider hasItemConformingToTypeIdentifier: ( NSString * ) kUTTypeImage ] )
        {
            // Load it, so we can get the path to it
            [ itemProvider loadItemForTypeIdentifier: ( NSString * ) kUTTypeImage
                                             options: NULL
                                   completionHandler: ^ ( UIImage * image, NSError * error )
             {
                 static int itemIdx = 0;
                 
                 if ( NULL != error )
                 {
                     NSLog( @"There was an error retrieving the attachments: %@", error );
                     return;
                 }
                 
                 // The app won't be able to access the images by path directly in the Camera Roll folder,
                 // so we temporary copy them to a folder which both the extension and the app can access:
                 NSString * filePath = [ self saveImageToAppGroupFolder: image imageIndex: itemIdx ];
                 
                 // Now add the path to the list of arguments we'll pass to the app:
                 [ self addImagePathToArgumentList: filePath ];
                 
                 // If we have reached the last attachment, it's time to hand control to the app:
                 if ( ++itemIdx >= m_inputItemCount )
                 {
                     [ self invokeApp: m_invokeArgs ];
                 }
             } ];
        }
    }
}
- ( void ) invokeApp: ( NSString * ) invokeArgs
{
    // Prepare the URL request
    // this will use the custom url scheme of your app
    // and the paths to the photos you want to share:
    NSString * urlString = [ NSString stringWithFormat: @"%@://%@", APP_SHARE_URL_SCHEME, ( NULL == invokeArgs ? @"" : invokeArgs ) ];
    NSURL * url = [ NSURL URLWithString: urlString ];
    
    NSString *className = @"UIApplication";
    if ( NSClassFromString( className ) )
    {
        id object = [ NSClassFromString( className ) performSelector: @selector( sharedApplication ) ];
        [ object performSelector: @selector( openURL: ) withObject: url ];
    }
    
    // Now let the host app know we are done, so that it unblocks its UI:
    [ super didSelectPost ];
}

#ifdef HIDE_POST_DIALOG
- ( NSArray * ) configurationItems
{
    // Comment out this whole function if you want the Post dialog to show.
    [ self passSelectedItemsToApp ];
    
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}
#endif


#ifdef HIDE_POST_DIALOG
- ( void ) willMoveToParentViewController: ( UIViewController * ) parent
{
    // This is called at the point where the Post dialog is about to be shown.
    // Make it transparent, so we don't see it, but first remember how transparent it was originally:
    
    m_oldAlpha = [ self.view alpha ];
    [ self.view setAlpha: 0.0 ];
}
#endif

#ifdef HIDE_POST_DIALOG
- ( void ) didMoveToParentViewController: ( UIViewController * ) parent
{
    // Restore the original transparency:
    [ self.view setAlpha: m_oldAlpha ];
}
#endif
#ifdef HIDE_POST_DIALOG
- ( id ) init
{
    if ( self = [ super init ] )
    {
        // Subscribe to the notification which will tell us when the keyboard is about to pop up:
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( keyboardWillShow: ) name: UIKeyboardWillShowNotification    object: nil ];
    }
    
    return self;
}
#endif
#ifdef HIDE_POST_DIALOG
- ( void ) keyboardWillShow: ( NSNotification * ) note
{
    // Dismiss the keyboard before it has had a chance to show up:
    [ self.view endEditing: true ];
}
#endif
@end
