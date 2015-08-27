//
//  MeasureBloodPressureController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
#import "HMUser.h"
#import "UploadVitalSignBloodPressureService.h"
#import "OMGToast.h"

@interface MeasureBloodPressureController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* bloodPressureTextField1;
@property (strong, nonatomic) IBOutlet UITextField* bloodPressureTextField2;
@property (strong, nonatomic) IBOutlet UITextField* bloodPressureTextField3;
@property (strong, nonatomic) HMUser*               hmUser;

- (IBAction)send:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
