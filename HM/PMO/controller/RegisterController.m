//
//  RegisterController.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "RegisterController.h"
#import "GetAreaListService.h"
#import "RegisterUserWithDetailsService.h"

@interface RegisterController ()

@property NSInteger      controllerViewType;
@property NSDictionary   *areaDictionary;
@property UIPickerView   *pickerView;
@property UIDatePicker   *datePicker;
@property NSArray        *areaKeys;
@property NSString       *selectKey;

@end

@implementation RegisterController

- (void)viewDidLoad
{
    self.controllerViewType = NO_NAVIGATION_BAR;
    [super viewDidLoad];
    
    //add tap gesture to close keyboard when scrolling the view
    UITapGestureRecognizer *tabGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tabGuesture.cancelsTouchesInView = false;
    [self.view addGestureRecognizer:tabGuesture];
    
    // Initialize picker
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = true;
    self.areaCode.inputView = self.pickerView;
    
    // Initialize date picker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.birth.inputView = self.datePicker;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 421)];
    CGRect segmentRect = self.sex.frame;
    segmentRect.size.height = 30;
    [self.sex setFrame:segmentRect];
    
    // Initialize area code
    self.areaKeys = [[NSArray alloc] init];
    
    // Load area code
    GetAreaListService *service = [[GetAreaListService alloc] initWithElementName: @"GetAreaListResult" Target:self Action:@selector(getAreaListWebServiceResult:) ErrorAction:nil];
    [service start];
    Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
    if (![reachability isReachable])
    {
        self.areaCode.enabled = NO;
        self.areaCode.text = @"請檢查您的網路狀況";
        self.areaCode.textColor = [UIColor grayColor];
    }
}

- (void) getAreaListWebServiceResult:(GetAreaListService*) service
{
    if (!service.error)
    {
        self.areaDictionary = service.areaDictionary;
        self.areaKeys       = service.keyArray;
        self.selectKey      = [self.areaKeys objectAtIndex:0];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component
{
    id aKey = [self.areaKeys objectAtIndex:row];
    NSString* text = [self.areaDictionary objectForKey:aKey];
    return text;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.areaDictionary count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id aKey = [self.areaKeys objectAtIndex:row];
    self.selectKey = aKey;
    self.areaCode.text = [self.areaDictionary objectForKey:aKey];
}

- (void) dateChanged:(id)sender
{
    self.birth.text = [PMOConstants getFormatDateWithDate:self.datePicker.date];
}

- (NSString*) getSexType
{
    switch (self.sex.selectedSegmentIndex)
    {
        case 0:return  @"M";
        case 1:return  @"F";
        default:return  @"";
    }
}

- (NSString*) getAreaCodeByName:(NSString*)name
{
    NSArray* array = [self.areaDictionary allKeysForObject:name];
    return [array objectAtIndex:0];
}

- (NSString*) getBirthWithBirthText:(NSString*)birth
{
    return [birth stringByReplacingOccurrencesOfString:@"/" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [birth length])];
}

- (void) registerUserWithDetailsResult:(RegisterUserWithDetailsService*)service
{
    self.activityIndicator.hidden = YES;
    if (service.error)
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:service.message Delegate:self];
    } else
    {
        [PMOConstants showAlertWithTitle:SUCCESS_ALERT_TITLE Message:@"電子郵件信箱驗證中，\n請至電子郵件信箱收信，\n並重新登入。" Delegate:self];
        [self closeSelfModalView:nil];
    }
}

- (void) viewDidUnload
{
    [self setAccount:nil];
    [self setPassword:nil];
    [self setRePassword:nil];
    [self setScrollView:nil];
    [self setSex:nil];
    [self setTel:nil];
    [self setAreaCode:nil];
    [self setBirth:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (IBAction)sendRegister:(id)sender
{
    NSLog(@"%d", [self.account.text rangeOfString:@"@"].location == NSNotFound);
    if ([self.account.text isEqualToString: @""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入帳號" Delegate:self];
    } else if ([self.account.text rangeOfString:@"@"].location == NSNotFound || [self.account.text rangeOfString:@"."].location == NSNotFound) {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入正確的email" Delegate:self];
    } else if ([self.password.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入密碼" Delegate:self];
    } else if (![self.password.text isEqualToString:self.rePassword.text])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"密碼與確認密碼不一致" Delegate:self];
    } else if ([[self getSexType] isEqualToString:@""]) {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入性別" Delegate:self];
    } else if ([self.tel.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入電話號碼" Delegate:self];
    } else if ([self.areaCode.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請選擇縣市" Delegate:self];
    } else if ([self.birth.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入生日" Delegate:self];
    } else
    {
        self.activityIndicator.hidden = NO;
        RegisterUserWithDetailsService *service = [[RegisterUserWithDetailsService alloc] initWithAccount:self.account.text Password:self.password.text Sex:[self getSexType] Tel:self.tel.text AreaCode:[self getAreaCodeByName:self.areaCode.text] Birth:[self getBirthWithBirthText:self.birth.text] ElementName:@"RegisterUserWithDetailsResult" Target:self Action:@selector(registerUserWithDetailsResult:) ErrorAction:@selector(didReceiveConnectionError:)];
        [service start];
    }
}

- (IBAction) closeKeyboard:(id)sender
{
    if ([self.areaCode isFirstResponder])
    {
        self.areaCode.text = [self.areaDictionary objectForKey:self.selectKey];
    } else if ([self.birth isFirstResponder])
    {
        [self dateChanged:nil];
    }
    [super closeKeyboard:sender];
}

@end
