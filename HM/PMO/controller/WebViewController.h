//
//  WebViewController.h
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "AbstractViewController.h"

@interface WebViewController : AbstractViewController <UIWebViewDelegate>

- (IBAction)logout:(id)sender;
@property NSInteger     webIndex;
- (IBAction) popToTopView:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)closeKeyboard:(id)sender;
- (IBAction)setting:(id)sender;
@end
