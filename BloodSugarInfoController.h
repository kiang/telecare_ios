//
//  BloodSugarInfoController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodSugarInfoService.h"
#import "BloodPressureInfoService.h"
#import "HMDBService.h"
#import "BloodPressureRemoteInfoController.h"

@interface BloodSugarInfoController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* startDateTextField;
@property (strong, nonatomic) IBOutlet UITextField* endDateTextField;
@property (strong, nonatomic) IBOutlet UIImageView*  imageView;
@property (strong, nonatomic) UIDatePicker* datePicker;
@property (strong, nonatomic) HMUser*       hmUser;

- (IBAction) changeToNextStepView:(id)sender;
- (IBAction) changeToNextStepViewWithOneDayAgo:(id)sender;
- (IBAction) backgroundTouch:(id)sender;

@end
