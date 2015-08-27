//
//  BloodSugarInfoController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodSugarInfoController.h"

@implementation BloodSugarInfoController
@synthesize startDateTextField = _startDateTextField;
@synthesize endDateTextField   = _endDateTextField;
@synthesize imageView          = _imageView;
@synthesize datePicker         = _datePicker;
@synthesize hmUser             = _hmUser;

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
    UIDatePicker* picker    = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    picker.datePickerMode   = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.datePicker = picker;
    self.startDateTextField.inputView = self.datePicker;
    self.endDateTextField.inputView   = self.datePicker;
    
    HMDBService* service = [[HMDBService alloc] init];
    self.hmUser = [service getLastHMUser];
    
    NSDate* today = [NSDate date];
    NSDate* sevenDaysAgo = [self getDateFromDate:today OffsetDay:-7];
    
    self.startDateTextField.text = [self getDateString:sevenDaysAgo];
    self.endDateTextField.text = [self getDateString:today];
    
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

- (IBAction) changeToNextStepViewWithOneDayAgo:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSDate* today = [NSDate date];
    NSDate* oneDayAgo = [self getDateFromDate:today OffsetDay:-1];
    
    self.startDateTextField.text = [self getDateString:oneDayAgo];
    self.endDateTextField.text = [self getDateString:today];
    
    [self performSegueWithIdentifier:@"bloodPressureRemoteInfoView" sender:self];
}

- (IBAction) changeToNextStepView:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.startDateTextField.text.length ==0 || self.endDateTextField.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入查詢日期"
                                  delegate:self
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil]show];
        return;
    }
    
    [self performSegueWithIdentifier:@"bloodPressureRemoteInfoView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[segue identifier] isEqualToString:@"bloodPressureRemoteInfoView"]) {
        BloodPressureRemoteInfoController* c = [segue destinationViewController];
        c.startDate = self.startDateTextField.text;
        c.endDate   = self.endDateTextField.text;
        c.hmUser    = self.hmUser;
    }
}



- (void) dateChanged:(id)sender
{
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

- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:true];
    self.imageView.image = nil;
}

//@protocol UITextFieldDelegate <NSObject>
//@optional

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [formatter stringFromDate:self.datePicker.date];
    textField.text = dateStr;
    return true;
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

//@end

@end
