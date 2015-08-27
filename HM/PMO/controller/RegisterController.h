//
//  RegisterController.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "AbstractViewController.h"

@interface RegisterController : AbstractViewController<UIPickerViewDataSource>

- (IBAction) closeSelfModalView:(id)sender;
- (IBAction) closeKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *rePassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sex;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UITextField *areaCode;
@property (strong, nonatomic) IBOutlet UITextField *birth;
- (IBAction)register:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)sendRegister:(id)sender;


@end
