//
//  LoginViewController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidateUserWebService.h"
#import "HMDBService.h"
#import "RegisterUserService.h"
#import "ResetPasswordService.h"
#import "BackgroundUploadService.h"
#import "Reachability.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UISwitch    *savePassAndAccount;
@property (strong, nonatomic) IBOutlet UILabel*     versionLabel;
@property (strong, nonatomic) IBOutlet UILabel*     infoLabel;
@property (strong, nonatomic) HMDBService*         hmDbService;
@property (strong, nonatomic) HMUser*              hmUser;

@property (strong, nonatomic) IBOutlet UIButton *forgetPassButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) UIImage *forgetPassButtonPressedBackground;
@property (strong, nonatomic) UIImage *loginButtonPressedBackground;
@property (strong, nonatomic) UIImage *registerButtonPressedBackground;
- (IBAction)registerFormClose:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *registerFormCloseButton;

@property (strong, nonatomic) IBOutlet UIView *registerView;

- (IBAction)login:(id)sender;
- (IBAction)backgroundTouch:(id)sender;
- (IBAction)showInfo:(id)sender;

- (IBAction)openRegister:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *registerFormButton;
@property (strong, nonatomic) IBOutlet UITextField *registerAccount;

@property (strong, nonatomic) IBOutlet UITextField *registerPassword1;

@property (strong, nonatomic) IBOutlet UITextField *registerPassword2;
- (IBAction)submitRegister:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *forgetPassView;
- (IBAction)showForgetPass:(id)sender;
- (IBAction)send:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *forgetPassAccount;
@property (strong, nonatomic) IBOutlet UIButton *closeForgetPassButton;
- (IBAction)closeForgetPass:(id)sender;

@end
