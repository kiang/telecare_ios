//
//  AbstractViewController.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <UIKit/UIKit.h>
#import "PMOConstants.h"
#import "PMODBService.h"
#import "PMOWebService.h"

@interface AbstractViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *flag;
- (IBAction) closeSelfModalView:(id)sender;
- (IBAction) popToTopView:(id)sender;
- (IBAction) popSelfView:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
- (IBAction) setting:(id)sender;
- (IBAction) logout:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void) didReceiveConnectionError:(PMOWebService*) service;

@end
