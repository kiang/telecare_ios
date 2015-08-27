//
//  RegisterController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterUserService.h"

@interface RegisterController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)registerNow:(id)sender;
- (IBAction)backgroundTouch:(id)sender;


@end
