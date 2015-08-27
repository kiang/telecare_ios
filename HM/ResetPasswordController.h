//
//  ResetPasswordController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetPasswordService.h"

@interface ResetPasswordController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *account;

- (IBAction)resetPassword:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
