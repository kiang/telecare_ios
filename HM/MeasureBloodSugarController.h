//
//  MeasureBloodSugarController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
#import "HMUser.h"
#import "UploadVitalSignBloodSugarService.h"
#import "OMGToast.h"


@interface MeasureBloodSugarController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl* timeTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField*        bloodSugarTextField;
@property (strong, nonatomic) HMUser*                      hmUser;

- (IBAction)send:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
