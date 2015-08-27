//
//  LoginController.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "AbstractViewController.h"

@interface LoginController : AbstractViewController

@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction) closeKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *savePassAndAccount;
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end
