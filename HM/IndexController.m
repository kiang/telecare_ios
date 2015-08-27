//
//  IndexController.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IndexController.h"


@interface IndexController ()
@end

@implementation IndexController
@synthesize uploadButton;
@synthesize uploadBloodSugarButton;
@synthesize localBloodSugarButton;
@synthesize remoteBloodSugarButton;
@synthesize localBloodPressureButton;
@synthesize remoteBloodPressureButton;
@synthesize settingButton;
@synthesize submitPassChangeButton;
@synthesize bloodPressureDateTime;
@synthesize closeBloodPressureDatePickerButton;
@synthesize bloodSugarDateTime;
@synthesize closeBloodSugarDatePickerButton;
@synthesize closeDataDatepickerButton;
@synthesize settingExitButton;
@synthesize settingView;
@synthesize settingCloseButton;
@synthesize startDateTextField = _startDateTextField;
@synthesize endDateTextField = _endDateTextField;
@synthesize closeDataButton;
@synthesize timeTypeSegmentedControl = _timeTypeSegmentedControl;
@synthesize Data;
@synthesize datePicker         = _datePicker;
@synthesize bloodPressureTextField1;
@synthesize bloodPressureTextField2;
@synthesize bloodPressureTextField3;
@synthesize bloodPressureCloseButton;
@synthesize bloodSugarTextField;
@synthesize bloodSugarCloseButton;
@synthesize bloodSugarView;
@synthesize theOldPasswordTextField = _theOldPasswordTextField;
@synthesize theNew1PasswordTextField = _theNew1PasswordTextField;
@synthesize cancelButton;
@synthesize theNew2PasswordTextField = _theNew2PasswordTextField;
@synthesize cancelBloodSugarButton;
@synthesize messagePoint;
@synthesize message;
@synthesize userIdLabel;
@synthesize userTypeLabel;
@synthesize changePassButton;
@synthesize bloodSugarButton;
@synthesize bloodPressureButton;
@synthesize dataButton;
@synthesize changePassView;
@synthesize changePassCloseButton;
@synthesize userUnitNameLabel;
@synthesize hmDbService = _hmDbService;
@synthesize hmUser      = _hmUser;
@synthesize radio1;
@synthesize radio2;
@synthesize bloodPressure;
@synthesize popUpWindow;
@synthesize datePickerDateAndTime;
UIDatePicker* picker2;
UIDatePicker* picker;
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
    
    //test
    NSLog(@"IndexController %@",NSStringFromSelector(_cmd));
    
    [super viewDidLoad];
    [BackgroundUploadService start];
    self.hmDbService = [[HMDBService alloc] init];
    self.hmUser = [self.hmDbService getLastHMUser];
    self.userIdLabel.text       = [NSString stringWithFormat:@"帳號：%@", self.hmUser.uid];
    NSLog(@"self.hmUser.userType:%@", self.hmUser.userType);
    self.userTypeLabel.text     = self.hmUser.userType;
    NSString *unitName = [[NSString alloc] initWithFormat:@"(%@)", self.hmUser.userUnitName];
    [self.userUnitNameLabel setFont: [UIFont systemFontOfSize:10.0]];
    if (![self.hmUser.userType isEqualToString:@"試用會員"]) {
        self.userUnitNameLabel.text = unitName;
    }
    self.closeDataDatepickerButton.hidden = true;
    
    //navigation title
    CGRect frame = CGRectMake(0, 0, 400, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = @"衛生福利部關心您";
    //label.shadowColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.396 green:0.404 blue:0.247 alpha:1];
    self.navigationItem.titleView = label;
    
    //navigation left button
//    if (popUpWindow == nil) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.bounds = CGRectMake(0, 0, 58.0, 42.0);
        [backButton setBackgroundImage:[UIImage imageNamed:@"backA.png"]
                    forState:UIControlStateNormal];
        UIImage * backButtonPressed = [UIImage imageNamed:@"backB.png"];
        [backButton setBackgroundImage:backButtonPressed forState:UIControlStateHighlighted];
        [backButton addTarget:self 
                       action:@selector(OnClick_btnBack:) 
             forControlEvents:UIControlEventTouchUpInside];
        backButton.hidden = true;
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
//    } else {
//        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.bounds = CGRectMake(0, 0, 58.0, 26.0);
//        [backButton setImage:[UIImage imageNamed:@"backA.png"] 
//                    forState:UIControlStateNormal];
//        UIImage * backButtonPressed = [UIImage imageNamed:@"backB.png"];
//        [backButton setBackgroundImage:backButtonPressed forState:UIControlStateHighlighted];
//        [backButton addTarget:self 
//                       action:@selector(OnClick_btnBack:) 
//             forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        self.navigationItem.leftBarButtonItem = backButtonItem;
//    }
    
    //navigation right button
    UIButton * logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.bounds = CGRectMake(0, 0, 58.0, 42.0);
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logoutA.png"] 
                forState:UIControlStateNormal];
    UIImage * logoutButtonPressed = [UIImage imageNamed:@"logoutB.png"];
    [logoutButton setBackgroundImage:logoutButtonPressed forState:UIControlStateHighlighted];
    [logoutButton addTarget:self 
                   action:@selector(logout:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    self.navigationItem.rightBarButtonItem = logoutButtonItem;
    
    //按鈕按下反應
    UIImage * changePassButtonPressed = [UIImage imageNamed:@"button_2.png"];
    [changePassButton setBackgroundImage:changePassButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodSugarButtonPressed = [UIImage imageNamed:@"bloodSugarB.png"];
    [bloodSugarButton setBackgroundImage:bloodSugarButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodPressureButtonPressed = [UIImage imageNamed:@"bloodPressureB.png"];
    [bloodPressureButton setBackgroundImage:bloodPressureButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * dataButtonPressed = [UIImage imageNamed:@"dataB.png"];
    [dataButton setBackgroundImage:dataButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * changePassClosePressed = [UIImage imageNamed:@"closeB.png"];
    [changePassCloseButton setBackgroundImage:changePassClosePressed forState:UIControlStateHighlighted];
    
    [bloodSugarCloseButton setBackgroundImage:changePassClosePressed forState:UIControlStateHighlighted];
    
    [bloodPressureCloseButton setBackgroundImage:changePassClosePressed forState:UIControlStateHighlighted];
    
    [closeDataButton setBackgroundImage:changePassClosePressed forState:UIControlStateHighlighted];
    
    [settingCloseButton setBackgroundImage:changePassClosePressed forState:UIControlStateHighlighted];
    
    UIImage * settingExitPressed = [UIImage imageNamed:@"exitB.png"];
    [settingExitButton setBackgroundImage:settingExitPressed forState:UIControlStateHighlighted];
    
    UIImage * uploadButtonPressed = [UIImage imageNamed:@"uploadB.png"];
    [uploadButton setBackgroundImage:uploadButtonPressed forState:UIControlStateHighlighted];
    [uploadBloodSugarButton setBackgroundImage:uploadButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * cancelButtonPressed = [UIImage imageNamed:@"cancelB.png"];
    [cancelButton setBackgroundImage:cancelButtonPressed forState:UIControlStateHighlighted];
    [cancelBloodSugarButton setBackgroundImage:cancelButtonPressed forState:UIControlStateHighlighted];
    
    UIImage * bloodSugarDataPressed = [UIImage imageNamed:@"bloodSugarDataB.png"];
    [localBloodSugarButton setBackgroundImage:bloodSugarDataPressed forState:UIControlStateHighlighted];
    [remoteBloodSugarButton setBackgroundImage:bloodSugarDataPressed forState:UIControlStateHighlighted];
    
     UIImage * bloodPressureDataPressed = [UIImage imageNamed:@"BloodPressureDataB.png"];
    [localBloodPressureButton setBackgroundImage:bloodPressureDataPressed forState:UIControlStateHighlighted];
    [remoteBloodPressureButton setBackgroundImage:bloodPressureDataPressed forState:UIControlStateHighlighted];
    
    UIImage * submitPressed = [UIImage imageNamed:@"submitB.png"];
    [submitPassChangeButton setBackgroundImage:submitPressed forState:UIControlStateHighlighted];
    
    UIImage * settingPressed = [UIImage imageNamed:@"settingB.png"];
    [settingButton setBackgroundImage:settingPressed forState:UIControlStateHighlighted];
    
    [self.timeTypeSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateSelected];
    
    [self.timeTypeSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor colorWithRed:0.22 green:0.18 blue:0.153 alpha:1] , nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor, nil]] forState:UIControlStateNormal];
    
    self.changePassView.hidden = true;
    self.bloodSugarView.hidden = true;
    self.bloodPressure.hidden = true;
    self.Data.hidden = true;
    self.settingView.hidden = true;
    self.closeBloodSugarDatePickerButton.hidden = true;
    self.closeBloodPressureDatePickerButton.hidden = true;
    
    self.theOldPasswordTextField.delegate = self;
    self.theNew1PasswordTextField.delegate = self;
    self.theNew2PasswordTextField.delegate = self;
    self.bloodSugarTextField.delegate = self;
    self.bloodPressureTextField1.delegate = self;
    self.bloodPressureTextField2.delegate = self;
    self.bloodPressureTextField3.delegate = self;
    self.startDateTextField.delegate = self;
    self.endDateTextField.delegate = self;
    self.bloodSugarDateTime.delegate = self;
    self.bloodPressureDateTime.delegate = self;

    
    radio1 = [UIImage imageNamed:@"radioA.png"];
    radio2 = [UIImage imageNamed:@"radioB.png"];
    
    picker    = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    picker.datePickerMode   = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    picker2    = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    picker2.datePickerMode   = UIDatePickerModeDateAndTime;
    picker2.maximumDate = [NSDate date];
    [picker2 addTarget:self action:@selector(dateAndTimeChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.datePickerDateAndTime = picker2;
    self.bloodSugarDateTime.inputView = self.datePickerDateAndTime;
    self.bloodPressureDateTime.inputView = self.datePickerDateAndTime;
    
    self.datePicker = picker;
    self.startDateTextField.inputView = self.datePicker;
//TODO    self.datePicker.frame

    self.endDateTextField.inputView   = self.datePicker;
    
    NSDate* today = [NSDate date];
    NSDate* sevenDaysAgo = [self getDateFromDate:today OffsetDay:-1];
    
    self.startDateTextField.text = [self getDateString:sevenDaysAgo];
    self.endDateTextField.text = [self getDateString:today];
    
    self.bloodPressureDateTime.text = [self getDateString2:today];
    self.bloodSugarDateTime.text = [self getDateString2:today];
    
    [self popUpShow];
	// Do any additional setup after loading the view.
    

}

- (void) dateAndTimeChanged:(id)sender
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateStr = [formatter stringFromDate:self.datePickerDateAndTime.date];
    NSLog(@"dateStr:%@", dateStr);
    if (self.bloodSugarDateTime.isFirstResponder) {
        NSLog(@"dateChanged start");
        self.bloodSugarDateTime.text = dateStr;
    } else if (self.bloodPressureDateTime.isFirstResponder) {
        self.bloodPressureDateTime.text = dateStr;
    }else {
        NSLog(@"dateChanged none");
    }
}

-(void)popUpShow {
    if (popUpWindow == nil) {
        
    } else if ([popUpWindow isEqualToString:@"1"]) {
        self.bloodSugarTextField.text = @"";
        self.bloodSugarDateTime.text = [self getDateString2:[NSDate date]];
        self.bloodSugarView.hidden = false;
        self.bloodPressure.hidden = true;
        self.Data.hidden = true;
        self.settingView.hidden = true;
    } else if ([popUpWindow isEqualToString:@"2"]) {
        self.bloodPressureTextField1.text = @"";
        self.bloodPressureTextField2.text = @"";
        self.bloodPressureTextField3.text = @"";
        self.bloodPressureDateTime.text = [self getDateString2:[NSDate date]];
        self.bloodPressure.hidden = false;
        self.bloodSugarView.hidden = true;
        self.Data.hidden = true;
        self.settingView.hidden = true;
    } else if ([popUpWindow isEqualToString:@"3"]) {
        self.Data.hidden = false;
        self.bloodSugarView.hidden = true;
        self.bloodPressure.hidden = true;
        self.settingView.hidden = true;
    }
}

- (NSDate*) getDateFromDate:(NSDate*)date OffsetDay:(NSInteger)offset
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* c = [[NSDateComponents alloc]init];
    c.day = offset;
    
    return [cal dateByAddingComponents:c toDate:date options:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit];
}

- (NSString*) getDateString:(NSDate*)date
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    if (date==nil) {
        date = [[NSDate alloc]init];
    }
    return [fmt stringFromDate:date];
}

- (NSString*) getDateString2:(NSDate*)date
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (date==nil) {
        date = [[NSDate alloc]init];
    }
    return [fmt stringFromDate:date];
}


-(IBAction)OnClick_btnBack:(id)sender  {    //返回上一頁
    NSLog(@"go back");
    if (popUpWindow == nil) {
        //[BackgroundUploadService stop];
        //[self dismissModalViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];    
    }
}
-(IBAction)logout:(id)sender {
    [self.hmDbService deleteAllUserDatas];
    [self performSegueWithIdentifier:@"goLogout" sender:self];
}

- (void)viewDidUnload
{
    [self setUserIdLabel:nil];
    [self setUserTypeLabel:nil];
    [self setUserUnitNameLabel:nil];
    [self setUserUnitNameLabel:nil];
    [self setChangePassButton:nil];
    [self setBloodSugarButton:nil];
    [self setBloodPressureButton:nil];
    [self setDataButton:nil];
    [self setChangePassView:nil];
    [self setChangePassCloseButton:nil];
    [self setTheOldPasswordTextField:nil];
    [self setTheNew1PasswordTextField:nil];
    [self setTheNew2PasswordTextField:nil];
    [self setMessagePoint:nil];
    [self setMessage:nil];
    [self setBloodSugarView:nil];
    [self setBloodSugarCloseButton:nil];
    [self setBloodSugarTextField:nil];
    [self setBloodPressure:nil];
    [self setBloodPressureCloseButton:nil];
    [self setBloodPressureTextField1:nil];
    [self setBloodPressureTextField2:nil];
    [self setBloodPressureTextField3:nil];
    [self setTimeTypeSegmentedControl:nil];
    [self setData:nil];
    [self setCloseDataButton:nil];
    [self setStartDateTextField:nil];
    [self setEndDateTextField:nil];
    [self setSettingView:nil];
    [self setSettingCloseButton:nil];
    [self setSettingExitButton:nil];
    [self setCloseDataDatepickerButton:nil];
    [self setBloodSugarDateTime:nil];
    [self setCloseBloodSugarDatePickerButton:nil];
    [self setBloodPressureDateTime:nil];
    [self setCloseBloodPressureDatePickerButton:nil];
    [self setUploadButton:nil];
    [self setCancelButton:nil];
    [self setCancelBloodSugarButton:nil];
    [self setUploadBloodSugarButton:nil];
    [self setLocalBloodSugarButton:nil];
    [self setRemoteBloodSugarButton:nil];
    [self setLocalBloodPressureButton:nil];
    [self setRemoteBloodPressureButton:nil];
    [self setSubmitPassChangeButton:nil];
    [self setSettingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.bloodSugarDateTime.isFirstResponder) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        picker2.date = [formatter dateFromString:self.bloodSugarDateTime.text];
        picker2.maximumDate = [NSDate date];
        CGFloat x = (self.datePickerDateAndTime.frame.origin.x + self.datePickerDateAndTime.frame.size.width - 90);
        NSLog(@"datepicker y: %f", self.datePickerDateAndTime.frame.size.height);
        CGFloat y = self.datePickerDateAndTime.frame.size.height - 2;
        NSLog(@"blood sugar button position: x-%f, y-%f",x,y);
        self.closeBloodSugarDatePickerButton.frame = CGRectMake(x, 190, 100, 30);
        self.closeBloodSugarDatePickerButton.titleLabel.text = @"確認";
        self.closeBloodSugarDatePickerButton.hidden = false;
    } else if (self.bloodPressureDateTime.isFirstResponder) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        picker2.date = [formatter dateFromString:self.bloodPressureDateTime.text];
        picker2.maximumDate = [NSDate date];
        CGFloat x = (self.datePickerDateAndTime.frame.origin.x + self.datePickerDateAndTime.frame.size.width - 90);
        CGFloat y = self.datePickerDateAndTime.frame.origin.y - self.closeBloodPressureDatePickerButton.frame.size.height - 2;
        NSLog(@"blood sugar button position: x-%f, y-%f",x,y);
        self.closeBloodPressureDatePickerButton.frame = CGRectMake(x, 190, 100, 30);
        self.closeBloodPressureDatePickerButton.titleLabel.text = @"確認";
        self.closeBloodPressureDatePickerButton.hidden = false;
    } else if (self.startDateTextField.isFirstResponder || self.endDateTextField.isFirstResponder) {
        CGFloat x = (self.datePicker.frame.origin.x + self.datePicker.frame.size.width - 90);
        CGFloat y = self.datePicker.frame.origin.y - self.closeDataDatepickerButton.frame.size.height - 2;
        NSLog(@"button position: x-%f, y-%f",x,y);
        self.closeDataDatepickerButton.frame = CGRectMake(x, 175, 100, 30);
        self.closeDataDatepickerButton.titleLabel.text = @"確認";
        self.closeDataDatepickerButton.hidden = false;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        if (self.startDateTextField.isFirstResponder) {
            picker.date = [formatter dateFromString:self.startDateTextField.text];
            picker.minimumDate = nil;
            picker.maximumDate = [formatter dateFromString:self.endDateTextField.text];
        } else {
            picker.date = [formatter dateFromString:self.endDateTextField.text];
            picker.minimumDate = [formatter dateFromString:self.startDateTextField.text];
            picker.maximumDate = [NSDate date];
        }
    }
}

- (IBAction)changePass:(id)sender {
    self.theOldPasswordTextField.text = @"";
    self.theNew1PasswordTextField.text = @"";
    self.theNew2PasswordTextField.text = @"";
    self.changePassView.hidden = false;
}

- (IBAction) changeResult:(ChangingPasswordService*)service
{
    NSString* title;
    if (service.error) {
        title = @"錯誤";
        [[[UIAlertView alloc]initWithTitle:title message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
    } else {
        title = @"通知";
        self.hmUser.pwd = service.theNewPassword;
        [self.hmDbService insertOrUpdateHMUser:self.hmUser];
        [[[UIAlertView alloc]initWithTitle:title message:service.message
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
        self.changePassView.hidden = true;
    }
    
}
/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [formatter stringFromDate:self.datePicker.date];
    textField.text = dateStr;
    return true;
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)change:(id)sender {
    if ([self.theOldPasswordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請輸入舊密碼" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if ([self.theNew1PasswordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請輸入新密碼" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if (![self.theNew1PasswordTextField.text isEqualToString:self.theNew2PasswordTextField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"新密碼與再次確認不一致" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    } else if (self.theNew1PasswordTextField.text.length < 6 || self.theNew1PasswordTextField.text.length > 15) {
        [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼格式錯誤" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
    }else {
        bool num = false, alp = false;
        for (int i = 0; i < self.theNew1PasswordTextField.text.length; i++) {
            if (([self.theNew1PasswordTextField.text characterAtIndex:i] >= 65 && [self.theNew1PasswordTextField.text characterAtIndex:i] <= 90) || ([self.theNew1PasswordTextField.text characterAtIndex:i] >= 97 && [self.theNew1PasswordTextField.text characterAtIndex:i] <= 122)) {
                alp = true;
            }
            if ([self.theNew1PasswordTextField.text characterAtIndex:i] >= 48 && [self.theNew1PasswordTextField.text characterAtIndex:i] <= 57) {
                num = true;
            }
            
            if (num && alp) {
                break;
            }
        }
        if (num && alp) {
        ChangingPasswordService* service = [[ChangingPasswordService alloc] initWithUserId:self.hmUser.uid TheOldPassword:self.theOldPasswordTextField.text TheNewPassword:self.theNew1PasswordTextField.text Target:self Action:@selector(changeResult:)];
        [service start];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼格式錯誤" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show];
        }
    }
}
- (IBAction)closeChangePassPopUp:(id)sender {
    self.changePassView.hidden = true;
}
- (IBAction)goBloodSugar:(id)sender {
    self.bloodSugarTextField.text = @"";
    self.bloodSugarDateTime.text = [self getDateString2:[NSDate date]];
    self.bloodSugarView.hidden = false;
    self.bloodPressure.hidden = true;
    self.Data.hidden = true;
    self.settingView.hidden = true;
    self.changePassView.hidden = true;
}
- (IBAction)closeBloodSugar:(id)sender {
    self.bloodSugarView.hidden = true;
}

- (NSString*) getTimeType
{
    switch (self.timeTypeSegmentedControl.selectedSegmentIndex) {
        case 0:return  @"AC";
        case 1:return  @"PC";
        default:return @"NM";
    }
}

- (IBAction)send:(id)sender {
    if ([self.bloodSugarDateTime.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入時間" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        return;
    } else if([self.bloodSugarTextField.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入血糖數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        return;
    }    
    HMBG* hmbg = [[HMBG alloc] init];
    hmbg.uid = self.hmUser.uid;
    hmbg.type = [self getTimeType];
    hmbg.val = [NSNumber numberWithInt:[self.bloodSugarTextField.text intValue]];
    hmbg.sendFlag = @"N";
    //save date time
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dte = [formatter dateFromString:self.bloodSugarDateTime.text];
    
    hmbg.fillTime = [NSNumber numberWithLong:[dte timeIntervalSinceReferenceDate]];
    
    HMDBService* service = [[HMDBService alloc] init];
    [service insertOrUpdateHMBG:hmbg];
    
    self.bloodSugarTextField.text = nil;
    [OMGToast showWithText:@"血糖資料已儲存" duration:2];
    self.bloodSugarView.hidden = true;
}

- (IBAction)cancelUploadBloodSugar:(id)sender {
    self.bloodSugarView.hidden = true;
}
- (IBAction)goBloodPressure:(id)sender {
    self.bloodPressureTextField1.text = @"";
    self.bloodPressureTextField2.text = @"";
    self.bloodPressureTextField3.text = @"";
    self.bloodPressureDateTime.text = [self getDateString2:[NSDate date]];
    self.bloodPressure.hidden = false;
    self.changePassView.hidden = true;
    self.bloodSugarView.hidden = true;
    self.Data.hidden = true;
    self.settingView.hidden = true;
}

- (IBAction)cancelUploadBloodPressure:(id)sender {
    self.bloodPressure.hidden = true;
}
- (IBAction)closeBloodPressure:(id)sender {
    self.bloodPressure.hidden = true;
}
- (IBAction)uploadBloodPressure:(id)sender {
    if ([self.bloodPressureDateTime.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入時間" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        return;
    } else if ([self.bloodPressureTextField1.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入收縮壓數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        
        return;
    } else if ([self.bloodPressureTextField2.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入舒張壓數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        
        return;
    } else if ([self.bloodPressureTextField3.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入脈搏數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        
        return;
    }   
    HMBP* hmbp = [[HMBP alloc] init];
    hmbp.uid = self.hmUser.uid;
    hmbp.bpl = [NSNumber numberWithInt:[self.bloodPressureTextField2.text intValue]];
    hmbp.bph = [NSNumber numberWithInt:[self.bloodPressureTextField1.text intValue]];
    hmbp.pluse = [NSNumber numberWithInt:[self.bloodPressureTextField3.text intValue]];
    hmbp.sendFlag = @"N";
    
    //save date time
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dte = [formatter dateFromString:self.bloodPressureDateTime.text];
    
    hmbp.fillTime = [NSNumber numberWithLong:[dte timeIntervalSinceReferenceDate]];
    
    HMDBService* service = [[HMDBService alloc] init];
    [service insertOrUpdateHMBP:hmbp];
    
    self.bloodPressureTextField1.text = nil;
    self.bloodPressureTextField2.text = nil;
    self.bloodPressureTextField3.text = nil;
    
    [OMGToast showWithText:@"血壓資料已儲存" duration:2];
    self.bloodPressure.hidden = true;
}
- (IBAction)goData:(id)sender {
    self.Data.hidden = false;
    self.changePassView.hidden = true;
    self.bloodPressure.hidden = true;
    self.bloodSugarView.hidden = true;
    self.settingView.hidden = true;
}
- (IBAction)closeData:(id)sender {
    self.Data.hidden = true;
}
- (void) dateChanged:(id)sender
{
    self.closeDataDatepickerButton.hidden = false;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [formatter stringFromDate:self.datePicker.date];
    NSLog(@"dateStr:%@", dateStr);
    if (self.startDateTextField.isFirstResponder) {
        NSLog(@"dateChanged start");
        self.startDateTextField.text = dateStr;
    } else if (self.endDateTextField.isFirstResponder) {
        NSLog(@"dateChanged end");
        self.endDateTextField.text = dateStr;
    } else {
        NSLog(@"dateChanged none");
    }
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"bloodSugarRemoteInfoView"]) {
        BloodSugarRemoteController * c = [segue destinationViewController];
        c.startDate = self.startDateTextField.text;
        c.endDate   = self.endDateTextField.text;
        c.hmUser    = self.hmUser;
    } else if ([[segue identifier] isEqualToString:@"bloodPressureRemoteInfoView"]) {
        BloodPressureRemoteController * c = [segue destinationViewController];
        c.startDate = self.startDateTextField.text;
        c.endDate   = self.endDateTextField.text;
        c.hmUser    = self.hmUser;
    }
}
- (IBAction)closeDataPicker:(id)sender {
    self.closeDataDatepickerButton.hidden = true;
    [self.view endEditing:true];
}
- (IBAction)settingClose:(id)sender {
    self.settingView.hidden = true;
}

- (IBAction)openSetting:(id)sender {
    self.settingView.hidden = false;
}
- (IBAction)settingExit:(id)sender {
    self.settingView.hidden = true;
}
- (IBAction)closeDataDatepicket:(id)sender {
    [self.view endEditing:true];
    self.closeDataDatepickerButton.hidden = true;
}
- (IBAction)closeBloodSugarDatePicker:(id)sender {
    [self.view endEditing:true];
    self.closeBloodSugarDatePickerButton.hidden = true;
}
- (IBAction)closeBloodPressureDatePicker:(id)sender {
    [self.view endEditing:true];
    self.closeBloodPressureDatePickerButton.hidden = true;
}
@end
