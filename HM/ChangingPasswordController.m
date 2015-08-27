//
//  ChangingPasswordController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChangingPasswordController.h"

@implementation ChangingPasswordController

@synthesize theOldPasswordTextField = _theOldPasswordTextField;
@synthesize theNew1PasswordTextField = _theNew1PasswordTextField;
@synthesize theNew2PasswordTextField = _theNew2PasswordTextField;
@synthesize hmDbService = _hmDbService;
@synthesize hmUser      = _hmUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.hmDbService = [[HMDBService alloc] init];
    self.hmUser = [self.hmDbService getLastHMUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) changeResult:(ChangingPasswordService*)service
{
    NSString* title;
    if (service.error) {
        title = @"錯誤";
    } else {
        title = @"通知";
        self.hmUser.pwd = service.theNewPassword;
        [self.hmDbService insertOrUpdateHMUser:self.hmUser];
    }
    [[[UIAlertView alloc]initWithTitle:title message:service.message
                              delegate:self
                     cancelButtonTitle:@"確定"
                     otherButtonTitles:nil]show];
}

- (IBAction) change:(id)sender;
{
    if ([self.theOldPasswordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請輸入舊密碼" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if ([self.theNew1PasswordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請輸入新密碼" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if (![self.theNew1PasswordTextField.text isEqualToString:self.theNew2PasswordTextField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"新密碼與再次確認不一致" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else {
        ChangingPasswordService* service = [[ChangingPasswordService alloc] initWithUserId:self.hmUser.uid TheOldPassword:self.theOldPasswordTextField.text TheNewPassword:self.theNew1PasswordTextField.text Target:self Action:@selector(changeResult:)];
        [service start];
    }
}

- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES]; //close keyboard
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

@end
