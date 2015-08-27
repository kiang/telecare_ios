//
//  ChangingPasswordController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
#import "ChangingPasswordService.h"

@interface ChangingPasswordController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* theOldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField* theNew1PasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField* theNew2PasswordTextField;

@property (strong, nonatomic) HMDBService* hmDbService;
@property (strong, nonatomic) HMUser*      hmUser;

- (IBAction) change:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
