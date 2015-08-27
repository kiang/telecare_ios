//
//  MeasureBloodPressureController.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeasureBloodPressureController.h"

@implementation MeasureBloodPressureController

@synthesize bloodPressureTextField1 = _bloodPressureTextField1;
@synthesize bloodPressureTextField2 = _bloodPressureTextField2;
@synthesize bloodPressureTextField3 = _bloodPressureTextField3;
@synthesize hmUser                  = _hmUser;

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

//- (void) uploadVitalSignServiceResult:(UploadVitalSignBloodPressureService*)service
//{
//    [[[UIAlertView alloc]initWithTitle:service.error?@"錯誤":@"資訊"
//                               message:service.message
//                              delegate:self
//                     cancelButtonTitle:@"確定"
//                     otherButtonTitles:nil]show];
//}

- (IBAction)send:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"hmUser:%@", self.hmUser);
    
    
//    UploadVitalSignBloodPressureService* service = [[UploadVitalSignBloodPressureService alloc] initWithUserId:self.hmUser.uid UserPassword:self.hmUser.pwd BloodPressureValue1:self.bloodPressureTextField1.text BloodPressureValue2:self.bloodPressureTextField2.text BloodPressureValue3:self.bloodPressureTextField3.text Target:self Action:@selector(uploadVitalSignServiceResult:)];
    
//    [service start];
    
    if (!self.bloodPressureTextField1.text
    ||  !self.bloodPressureTextField2.text
    ||  !self.bloodPressureTextField3.text
    ||  [self.bloodPressureTextField1.text isEqualToString:@""]
    ||  [self.bloodPressureTextField2.text isEqualToString:@""]
    ||  [self.bloodPressureTextField3.text isEqualToString:@""]) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"錯誤" message:@"請輸入數值" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [view show];
        
        return;
    }
    
    HMBP* hmbp = [[HMBP alloc] init];
    hmbp.uid = self.hmUser.uid;
    hmbp.bpl = [NSNumber numberWithInt:[self.bloodPressureTextField2.text intValue]];
    hmbp.bph = [NSNumber numberWithInt:[self.bloodPressureTextField1.text intValue]];
    hmbp.pluse = [NSNumber numberWithInt:[self.bloodPressureTextField3.text intValue]];
    hmbp.sendFlag = @"N";
    
    HMDBService* service = [[HMDBService alloc] init];
    [service insertOrUpdateHMBP:hmbp];
    
    self.bloodPressureTextField1.text = nil;
    self.bloodPressureTextField2.text = nil;
    self.bloodPressureTextField3.text = nil;
    
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
