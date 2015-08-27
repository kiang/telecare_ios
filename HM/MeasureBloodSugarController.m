//
//  MeasureBloodSugarController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeasureBloodSugarController.h"

@implementation MeasureBloodSugarController

@synthesize timeTypeSegmentedControl = _timeTypeSegmentedControl;
@synthesize bloodSugarTextField      = _bloodSugarTextField;
@synthesize hmUser                   = _hmUser;



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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    HMDBService* hmDbService = [[HMDBService alloc] init];
    self.hmUser = [hmDbService getLastHMUser];
    if (!self.hmUser) self.hmUser = [[HMUser alloc] init];
    
    NSLog(@"hmUser:%@", self.hmUser);
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

//- (void) uploadVitalSignServiceResult:(UploadVitalSignBloodSugarService*)service
//{
//    [[[UIAlertView alloc]initWithTitle:service.error?@"錯誤":@"資訊"
//                               message:service.message
//                              delegate:self
//                     cancelButtonTitle:@"確定"
//                     otherButtonTitles:nil]show];
//}
- (NSString*) getTimeType
{
    switch (self.timeTypeSegmentedControl.selectedSegmentIndex) {
        case 0:return  @"AC";
        case 1:return  @"PC";
        default:return @"NM";
    }
}
- (IBAction)send:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"hmUser:%@", self.hmUser);
    
    
//    UploadVitalSignBloodSugarService* service = [[UploadVitalSignBloodSugarService alloc] initWithUserId:self.hmUser.uid UserPassword:self.hmUser.pwd TimeType:[self getTimeType] BloodSugarValue:self.bloodSugarTextField.text Target:self Action:@selector(uploadVitalSignServiceResult:)];
    
//    [service start];
    
    if([self.bloodSugarTextField.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        return;
    }
    
    HMBG* hmbg = [[HMBG alloc] init];
    hmbg.uid = self.hmUser.uid;
    hmbg.type = [self getTimeType];
    hmbg.val = [NSNumber numberWithInt:[self.bloodSugarTextField.text intValue]];
    hmbg.sendFlag = @"N";
    
    HMDBService* service = [[HMDBService alloc] init];
    [service insertOrUpdateHMBG:hmbg];
    
    self.bloodSugarTextField.text = nil;
    [OMGToast showWithText:@"儲存成功" duration:2];
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
