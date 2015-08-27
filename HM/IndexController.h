//
//  IndexController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
#import "ChangingPasswordService.h"
#import "BloodSugarRemoteController.h"
#import "BloodPressureRemoteController.h"
#import "BackgroundUploadService.h"

@interface IndexController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *userUnitNameLabel;

@property (strong, nonatomic) HMDBService* hmDbService;
@property (strong, nonatomic) HMUser*      hmUser;
@property (strong, nonatomic) NSString * popUpWindow;

@property (strong, nonatomic) IBOutlet UIButton *changePassButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (weak, nonatomic) IBOutlet UIView *changePassView;
@property (weak, nonatomic) IBOutlet UIButton *changePassCloseButton;
- (IBAction)changePass:(id)sender;
- (IBAction)change:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *theOldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *theNew1PasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *theNew2PasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelBloodSugarButton;
@property (strong, nonatomic) IBOutlet UIImageView *messagePoint;
@property (strong, nonatomic) IBOutlet UILabel *message;
- (IBAction)closeChangePassPopUp:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bloodSugarView;
- (IBAction)goBloodSugar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarCloseButton;
- (IBAction)closeBloodSugar:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bloodSugarTextField;
@property (strong, nonatomic) UIDatePicker* datePickerDateAndTime;
- (IBAction)send:(id)sender;
- (IBAction)cancelUploadBloodSugar:(id)sender;

@property (strong, nonatomic) UIImage *radio1;
@property (strong, nonatomic) UIImage *radio2;
@property (strong, nonatomic) IBOutlet UIView *bloodPressure;
- (IBAction)goBloodPressure:(id)sender;
- (IBAction)cancelUploadBloodPressure:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureCloseButton;
- (IBAction)closeBloodPressure:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bloodPressureTextField1;
@property (strong, nonatomic) IBOutlet UITextField *bloodPressureTextField2;
@property (strong, nonatomic) IBOutlet UITextField *bloodPressureTextField3;
- (IBAction)uploadBloodPressure:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *timeTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *Data;
- (IBAction)goData:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeDataButton;
- (IBAction)closeData:(id)sender;
@property (strong, nonatomic) UIDatePicker* datePicker;
@property (strong, nonatomic) IBOutlet UITextField *startDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *endDateTextField;
- (IBAction)closeDataPicker:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UIButton *settingCloseButton;
- (IBAction)settingClose:(id)sender;
- (IBAction)openSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *settingExitButton;
- (IBAction)settingExit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeDataDatepickerButton;
- (IBAction)closeDataDatepicket:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bloodSugarDateTime;
@property (strong, nonatomic) IBOutlet UIButton *closeBloodSugarDatePickerButton;
- (IBAction)closeBloodSugarDatePicker:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bloodPressureDateTime;
@property (strong, nonatomic) IBOutlet UIButton *closeBloodPressureDatePickerButton;
- (IBAction)closeBloodPressureDatePicker:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadBloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *localBloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *remoteBloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *localBloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *remoteBloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *settingButton;

@property (strong, nonatomic) IBOutlet UIButton *submitPassChangeButton;
@end
