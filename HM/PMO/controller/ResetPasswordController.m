//
//  ResetPasswordController.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "ResetPasswordController.h"
#import "ResetPwdService.h"

@interface ResetPasswordController()

@property NSInteger         controllerViewType;

@end

@implementation ResetPasswordController

- (void)viewDidLoad
{
    self.controllerViewType = NO_NAVIGATION_BAR;
    [super viewDidLoad];
}

- (IBAction)resetPassword:(id)sender
{
    if ([self.account.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入Email" Delegate:self];
    } else
    {
        self.activityIndicator.hidden = NO;
        ResetPwdService *service = [[ResetPwdService alloc] initWithAccount:self.account.text ElementName:@"ResetPasswordResult" Target:self Action:@selector(resetPasswordResult:) ErrorAction:@selector(didReceiveConnectionError:)];
        [service start];
    }
}

- (void) resetPasswordResult:(ResetPwdService*)service
{
    self.activityIndicator.hidden = YES;
    if (service.error)
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:service.message Delegate:self];
    } else
    {
        [PMOConstants showAlertWithTitle:SUCCESS_ALERT_TITLE Message:@"已將密碼寄到您的帳號信箱。\n請確認新密碼後以新密碼登入。" Delegate:self];
        [self closeSelfModalView:nil];
    }
}

- (void)viewDidUnload
{
    [self setAccount:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
