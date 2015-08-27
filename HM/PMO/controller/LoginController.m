//
//  LoginController.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "LoginController.h"
#import "ValidateUserService.h"
#import "BackgroundUploadService.h"

@interface LoginController ()

@property NSInteger         controllerViewType;
@property PMODBService      *dbService;
@property HMUser            *hmUser;

@end

@implementation LoginController

- (void)viewDidLoad
{
    self.controllerViewType = NO_NAVIGATION_BAR;
    [super viewDidLoad];
    
    [BackgroundUploadService stop];
    
    if ([@"Y" isEqualToString:self.hmUser.rememberAccount]) {
        self.account.text  = self.hmUser.uid;
        self.password.text = self.hmUser.pwd;
        self.savePassAndAccount.on = YES;
    } else {
        self.savePassAndAccount.on = NO;
    }
    
    //self.versionLabel.text = [NSString stringWithFormat:@"版本資訊:V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
    // Delete local vital sign data befor 3 months
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* c = [[NSDateComponents alloc]init];
    c.day = -90;
    
    NSDate* dateBefore90 = [cal dateByAddingComponents:c toDate:[NSDate date] options:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit];
    [self.dbService deleteDatas:dateBefore90];
}

- (IBAction)login:(id)sender
{
    if ([self.account.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入帳號" Delegate:self];
    } else if ([self.password.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入密碼" Delegate:self];
    } else
    {
        // Check network condition, if offline, login with local latest user
        Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
        if ([reachability isReachable])
        {
            self.activityIndicator.hidden = NO;
            ValidateUserService *service = [[ValidateUserService alloc] initWithAccount:self.account.text Password:self.password.text ElementName:@"ValidateUserResult" Target:self Action:@selector(ValidateUserServiceResult:) ErrorAction:@selector(didReceiveConnectionError:)];
            [service start];
        } else
        {
            // Local latest login
            HMUser* dbUser = [self.dbService getHMUserWithUid:self.account.text];
            bool b = [self.password.text isEqualToString:dbUser.pwd];
            if(!b)
            {
                [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"錯誤帳號或密碼" Delegate:self];
            } else
            {
                // Login and update db data
                if (self.hmUser)
                {
                    self.hmUser.uid             = dbUser.uid;
                    self.hmUser.pwd             = dbUser.pwd;
                    self.hmUser.userType        = dbUser.userType;
                    self.hmUser.userUnitName    = dbUser.userUnitName;
                    self.hmUser.rememberAccount = self.savePassAndAccount.on?@"Y":@"N";
                }
                [self.dbService insertOrUpdateHMUser:self.hmUser];
                
                [self performSegueWithIdentifier:@"login" sender:self];
            }
        }
    }
}

- (void) ValidateUserServiceResult:(ValidateUserService*)service
{
    self.activityIndicator.hidden = YES;
    if (service.error)
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:service.message Delegate:self];
    } else
    {
        // Save latest user
        if (self.hmUser) {
            self.hmUser.uid             = self.account.text;
            self.hmUser.pwd             = self.password.text;
            self.hmUser.userType        = service.type;
            self.hmUser.userUnitName    = service.unitName;
            self.hmUser.rememberAccount = self.savePassAndAccount.on?@"Y":@"N";
        }
        [self.dbService insertOrUpdateHMUser:self.hmUser];
        
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)viewDidUnload {
    [self setAccount:nil];
    [self setPassword:nil];
    [self setSavePassAndAccount:nil];
    [self setActivityIndicator:nil];
    [self setVersionLabel:nil];
    [super viewDidUnload];
}

@end
