//
//  SettingController.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/26.
//
//

#import <Foundation/Foundation.h>
#import "AbstractViewController.h"

@interface SettingController : AbstractViewController

- (IBAction)logout:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
- (IBAction) popSelfView:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *theOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *theNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *rePassword;
- (IBAction)modify:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
