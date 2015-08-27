//
//  UserInfoController.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"

@interface UserInfoController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel* userIdLabel;
@property (strong, nonatomic) IBOutlet UILabel* userTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel* userUnitNameLabel;

@end
