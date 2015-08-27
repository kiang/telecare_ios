//
//  RegisterController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterController.h"

@implementation RegisterController
@synthesize account;
@synthesize password;

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

- (void)registerUserServiceResult:(RegisterUserService*)service
{
    if(service.error) {
        [[[UIAlertView alloc]initWithTitle:@"錯誤"
                                   message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        [self performSegueWithIdentifier:@"registerSuccessView" sender:self];
    }
}

- (IBAction)registerNow:(id)sender
{
    RegisterUserService* registerUserServicee = [[RegisterUserService alloc] initWithUserId:account.text UserPassword:password.text Target:self Action:@selector(registerUserServiceResult:)];
    [registerUserServicee start];
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
