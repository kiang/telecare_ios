//
//  ResetPasswordController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordController.h"

@implementation ResetPasswordController
@synthesize account;

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

- (void)resetPasswordServiceResult:(ResetPasswordService*)service
{
    [[[UIAlertView alloc]initWithTitle:service.error?@"錯誤":@"資訊" message:service.message
                              delegate:self
                     cancelButtonTitle:@"確定"
                     otherButtonTitles:nil]show];
}
- (IBAction)resetPassword:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([account.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"錯誤"
                                                       message:@"請輸入帳號"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"確定",nil];
        [alert show];
    } else {
        ResetPasswordService* service = [[ResetPasswordService alloc] initWithUserId:account.text Target:self Action:@selector(resetPasswordServiceResult:)];
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
