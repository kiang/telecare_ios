//
//  BloodSugarShowGraphControllerViewController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUser.h"
#import "BloodPressureShowGraphControllerViewController.h"
#import "HMDBService.h"
#import "BloodSugarRemoteController.h"

@interface BloodSugarShowGraphControllerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarGraphLogoutButton;
@property (strong, nonatomic) NSData*   imageData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *back;

@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) HMUser*   hmUser;

@property (strong, nonatomic) NSJSONSerialization* dataJson;
@property (strong, nonatomic) IBOutlet UIButton *goBloodPressureGraph;
@end
