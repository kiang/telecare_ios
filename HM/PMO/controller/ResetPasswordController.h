//
//  ResetPasswordController.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "AbstractViewController.h"

@interface ResetPasswordController : AbstractViewController

- (IBAction) closeSelfModalView:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *account;
- (IBAction)resetPassword:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
