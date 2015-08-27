//
//  ManualUploadController.m
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "ManualUploadController.h"
#import "OMGToast.h"

@interface ManualUploadController()

@property NSInteger         controllerViewType;
@property UIDatePicker      *dateTimePicker;
@property PMODBService      *dbService;
@property HMUser            *hmUser;

@end

@implementation ManualUploadController

- (void)viewDidLoad
{
    self.controllerViewType = HAS_NAVIGATION_BAR;
    [super viewDidLoad];

    // Initialize date time picker
    self.dateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.dateTimePicker.maximumDate = [NSDate date];
    [self.dateTimePicker addTarget:self action:@selector(dateTimeChanged:) forControlEvents:UIControlEventValueChanged];
    self.selectDateTime.inputView = self.dateTimePicker;
    
    // Initialize selectDateTime input text
    self.selectDateTime.text = [PMOConstants getFormatDateTimeWithDate:[NSDate date]];
}

- (void) dateTimeChanged:(id)sender
{
    self.selectDateTime.text = [PMOConstants getFormatDateTimeWithDate:self.dateTimePicker.date];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.selectDateTime isFirstResponder])
    {
        // Reset date time picker maximum date
        NSDate *nowDate = [NSDate date];
        self.dateTimePicker.maximumDate = nowDate;
        self.dateTimePicker.date = nowDate;
    }
    [super textFieldDidBeginEditing:textField];
}

- (IBAction)uploadBloodSugar:(id)sender
{
    if ([self.selectDateTime.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入時間" Delegate:self];
    } else if ([self.bloodSugar.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入血糖數值" Delegate:self];
    } else
    {
        self.activityIndicator.hidden = NO;
        // Save to HMBG
        [self.dbService saveHMBGWithAccount:self.hmUser.uid Type:[self getTimeType] DateTime:self.selectDateTime.text Value:self.bloodSugar.text];
        [OMGToast showWithText:@"血糖資料已儲存" duration:2];
        
        // Clear text
        self.selectDateTime.text = nil;
        self.bloodSugar.text     = nil;
        self.activityIndicator.hidden = YES;
    }
}

- (NSString*) getTimeType
{
    switch (self.bloodSugarTimeType.selectedSegmentIndex) {
        case 0:return  @"AC";
        case 1:return  @"PC";
        default:return @"NM";
    }
}

- (IBAction)uploadBloodPressure:(id)sender
{
    if ([self.selectDateTime.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入時間" Delegate:self];
    } else if ([self.bph.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入收縮壓數值" Delegate:self];
    } else if ([self.bpl.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入舒張壓數值" Delegate:self];
    } else if ([self.pluse.text isEqualToString:@""])
    {
        [PMOConstants showAlertWithTitle:ERROR_ALERT_TITLE Message:@"請輸入脈搏數值" Delegate:self];
    } else
    {
        self.activityIndicator.hidden = NO;
        // Save to HMBP
        [self.dbService saveHMBPWithAccount:self.hmUser.uid DateTime:self.selectDateTime.text Bpl:self.bpl.text Bph:self.bph.text Pluse:self.pluse.text InputType:@"N"];
        [OMGToast showWithText:@"血壓資料已儲存" duration:2];
        
        // Clear text
        self.selectDateTime.text    = nil;
        self.bph.text               = nil;
        self.bpl.text               = nil;
        self.pluse.text             = nil;
        self.activityIndicator.hidden = YES;
    }
}

- (IBAction) closeKeyboard:(id)sender
{
    if ([self.selectDateTime isFirstResponder])
    {
        self.selectDateTime.text = [PMOConstants getFormatDateTimeWithDate:self.dateTimePicker.date];
    }
    [super closeKeyboard:sender];
}

- (void)viewDidUnload {
    [self setBottomMenu:nil];
    [self setSelectDateTime:nil];
    [self setBloodSugar:nil];
    [self setBloodSugarTimeType:nil];
    [self setActivityIndicator:nil];
    [self setBph:nil];
    [self setBpl:nil];
    [self setPluse:nil];
    [super viewDidUnload];
}
@end
