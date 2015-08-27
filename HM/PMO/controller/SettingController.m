//
//  SettingController.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/26.
//
//

#import "SettingController.h"
#import "ChangePasswordService.h"

@interface SettingController()

@property NSInteger         controllerViewType;
@property PMODBService      *dbService;
@property HMUser            *hmUser;

@end

@implementation SettingController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setTheOldPassword:nil];
    [self setTheNewPassword:nil];
    [self setRePassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
- (IBAction)modify:(id)sender
{
    if ([self.theOldPassword.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入舊密碼" Delegate:self];
    } else if ([self.theNewPassword.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入新密碼" Delegate:self];
    } else if (![self.theNewPassword.text isEqualToString:self.rePassword.text])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"新密碼與確認密碼不一致" Delegate:self];
    } else
    {
        self.activityIndicator.hidden = NO;
        ChangePasswordService *service = [[ChangePasswordService alloc] initWithAccount:self.hmUser.uid OldPassword:self.theOldPassword.text NewPassword:self.theNewPassword.text ElementName:@"ChangePasswordResult" Target:self Action:@selector(changePasswordResult:) ErrorAction:@selector(didReceiveConnectionError:)];
        [service start];
    }
}

- (void)changePasswordResult:(ChangePasswordService*)service
{
    self.activityIndicator.hidden = YES;
    if (service.error)
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:service.message Delegate:self];
    } else
    {
        // Update local user data
        self.hmUser.pwd = self.theNewPassword.text;
        [self.dbService insertOrUpdateHMUser:self.hmUser];
        [PMOConstants showAlertWithTitle:SUCCESS_ALERT_TITLE Message:@"密碼修改成功，\n下次請使用新密碼登入。" Delegate:self];
        
        // Clear text
        self.theOldPassword.text   = nil;
        self.theNewPassword.text   = nil;
        self.rePassword.text    = nil;
    }
}

@end
