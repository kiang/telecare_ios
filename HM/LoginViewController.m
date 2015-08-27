//
//  LoginViewController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize forgetPassAccount;
@synthesize closeForgetPassButton;
@synthesize forgetPassView;
@synthesize registerFormButton;
@synthesize registerAccount;
@synthesize registerPassword1;
@synthesize registerPassword2;
@synthesize savePassAndAccount;
@synthesize account;
@synthesize password;
@synthesize hmDbService  = _hmDbService;
@synthesize hmUser       = _hmUser;
@synthesize forgetPassButton;
@synthesize loginButton;
@synthesize versionLabel = _versionLabel;
@synthesize infoLabel    = _infoLabel;
@synthesize forgetPassButtonPressedBackground;
@synthesize loginButtonPressedBackground;
@synthesize registerButtonPressedBackground;
@synthesize registerFormCloseButton;
@synthesize registerView;
@synthesize registerButton;


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
    
    [BackgroundUploadService stop];
    
    // Do any additional setup after loading the view.
    
    //按鈕按下反應
    forgetPassButtonPressedBackground = [UIImage imageNamed:@"forgetPassB.png"];
    [forgetPassButton setBackgroundImage:forgetPassButtonPressedBackground forState:UIControlStateHighlighted];
    
    loginButtonPressedBackground = [UIImage imageNamed:@"loginB.png"];
    [loginButton setBackgroundImage:loginButtonPressedBackground forState:UIControlStateHighlighted];
    
    registerButtonPressedBackground = [UIImage imageNamed:@"registerB.png"];
    [registerButton setBackgroundImage:registerButtonPressedBackground forState:UIControlStateHighlighted];
    
    UIImage * registerFormButtonPressedBackground = [UIImage imageNamed:@"registerButtonB.png"];
    [registerFormButton setBackgroundImage:registerFormButtonPressedBackground forState:UIControlStateHighlighted];
    
    UIImage * registerFormCloseButtonPressedBackground = [UIImage imageNamed:@"closeB.png"];
    [registerFormCloseButton setBackgroundImage:registerFormCloseButtonPressedBackground forState:UIControlStateHighlighted];
    
    [closeForgetPassButton setBackgroundImage:registerFormCloseButtonPressedBackground forState:UIControlStateHighlighted];

    
    self.hmDbService = [[HMDBService alloc] init];
    self.hmUser = [self.hmDbService getLastHMUser];
    if (!self.hmUser) self.hmUser = [[HMUser alloc] init];
    if ([@"Y" isEqualToString:self.hmUser.rememberAccount]) {
        account.text  = self.hmUser.uid;
        password.text = self.hmUser.pwd;
        savePassAndAccount.on = YES;
    } else {
        savePassAndAccount.on = NO;
    }
    
    self.registerView.hidden = true;
    self.forgetPassView.hidden = true;
    
    self.versionLabel.text = [NSString stringWithFormat:@"版本資訊:V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    //self.versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    self.registerAccount.delegate = self;
    self.registerPassword1.delegate = self;
    self.registerPassword2.delegate = self;
    self.forgetPassAccount.delegate = self;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* c = [[NSDateComponents alloc]init];
    c.day = -90;
    
    NSDate* dateBefore90 = [cal dateByAddingComponents:c toDate:[NSDate date] options:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit];
    [[[HMDBService alloc]init]deleteDatas:dateBefore90];
}

- (void)viewDidUnload
{
    [self setAccount:nil];
    [self setPassword:nil];
    [self setSavePassAndAccount:nil];
    [self setForgetPassButton:nil];
    [self setLoginButton:nil];
    [self setRegisterButton:nil];
    [self setRegisterView:nil];
    [self setRegisterFormButton:nil];
    [self setRegisterFormButton:nil];
    [self setRegisterFormCloseButton:nil];
    [self setAccount:nil];
    [self setRegisterAccount:nil];
    [self setRegisterPassword1:nil];
    [self setRegisterPassword2:nil];
    [self setForgetPassView:nil];
    [self setForgetPassAccount:nil];
    [self setCloseForgetPassButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)validateUserWebServiceResult:(ValidateUserWebService*)service
{
    if(service.error) {
        [[[UIAlertView alloc]initWithTitle:@"錯誤"
                                   message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        if (self.hmUser) {
            self.hmUser.uid             = service.userId;
            self.hmUser.pwd             = service.userPassword;
            self.hmUser.userType        = service.userType;
            self.hmUser.userUnitName    = service.userUnitName;
            self.hmUser.rememberAccount = savePassAndAccount.on?@"Y":@"N";
        }
        [self.hmDbService insertOrUpdateHMUser:self.hmUser];
        
        [self performSegueWithIdentifier:@"goIndex" sender:self];
    }
}
- (IBAction)login:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([account.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"錯誤帳號或密碼"
                                                       message:@"請輸入帳號"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"確定",nil];
        [alert show];
    } else if ([password.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"錯誤帳號或密碼"
                                                       message:@"請輸入密碼"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"確定",nil];        
        [alert show];
    } else {
        
        Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
        if ([reachability isReachable]) {
        
        ValidateUserWebService* service = [[ValidateUserWebService alloc] initWithUserId:account.text UserPassword:password.text Target:self Action:@selector(validateUserWebServiceResult:)];
        [service start];
        } else {
            HMUser* dbUser = [self.hmDbService getHMUserWithUid:account.text];
            bool b = [password.text isEqualToString:dbUser.pwd];
            if(!b) {
                [[[UIAlertView alloc]initWithTitle:@"錯誤"
                                           message:@"錯誤帳號或密碼"
                                          delegate:self
                                 cancelButtonTitle:@"確定"
                                 otherButtonTitles:nil]show];
            } else {
                if (self.hmUser) {
                    self.hmUser.uid             = dbUser.uid;
                    self.hmUser.pwd             = dbUser.pwd;
                    self.hmUser.userType        = dbUser.userType;
                    self.hmUser.userUnitName    = dbUser.userUnitName;
                    self.hmUser.rememberAccount = savePassAndAccount.on?@"Y":@"N";
                }
                [self.hmDbService insertOrUpdateHMUser:self.hmUser];
                
                [self performSegueWithIdentifier:@"goIndex" sender:self];
            }
            
        }
    }
}

- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES]; //close keyboard
    self.infoLabel.hidden = true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)showInfo:(id)sender
{
    self.infoLabel.hidden = false;
}

- (IBAction)openRegister:(id)sender {
    self.registerAccount.text = @"";
    self.registerPassword1.text = @"";
    self.registerPassword2.text = @"";
    self.registerView.hidden = false;
}
- (IBAction)registerFormClose:(id)sender {
    self.registerView.hidden = true;
}
- (void)registerUserServiceResult:(RegisterUserService*)service
{
    if(service.error) {
        [[[UIAlertView alloc]initWithTitle:@"警告"
                                   message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"通知"
                                   message:@"電子郵件信箱驗證中，\n請至電子郵件信箱收信，\n並重新登入。"
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
        self.registerView.hidden = true;
    }
}
- (IBAction)submitRegister:(id)sender {
    if (![self.registerPassword1.text isEqualToString:self.registerPassword2.text]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼與確認密碼不一致" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if (self.registerPassword1.text.length < 6 || self.registerPassword1.text.length > 15) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼格式錯誤" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    }else {
        RegisterUserService* registerUserServicee = [[RegisterUserService alloc] initWithUserId:registerAccount.text UserPassword:registerPassword1.text Target:self Action:@selector(registerUserServiceResult:)];
        [registerUserServicee start];
    }
}
- (IBAction)showForgetPass:(id)sender {
    self.forgetPassAccount.text = @"";
    self.forgetPassView.hidden = false;
}

- (IBAction)send:(id)sender {
    if ([forgetPassAccount.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"錯誤"
                                                       message:@"請輸入帳號"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"確定",nil];
        [alert show];
    } else {
        ResetPasswordService* service = [[ResetPasswordService alloc] initWithUserId:forgetPassAccount.text Target:self Action:@selector(resetPasswordServiceResult:)];
        [service start];
    }
}
- (void)resetPasswordServiceResult:(ResetPasswordService*)service
{
    [[[UIAlertView alloc]initWithTitle:service.error?@"警告":@"通知" message:service.message
                              delegate:self
                     cancelButtonTitle:@"確定"
                     otherButtonTitles:nil]show];
    if (!service.error) {
        self.forgetPassView.hidden = true;
    }
}
- (IBAction)closeForgetPass:(id)sender {
    self.forgetPassView.hidden = true;
}
@end
