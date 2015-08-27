//
//  BloodSugarRemoteController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUser.h"
#import "BloodSugarInfoService.h"
#import "BloodPressureRemoteController.h"
#import "BloodSugarShowGraphControllerViewController.h"
@interface BloodSugarRemoteController : UIViewController<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarRemoteLogoutButton;
@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) HMUser*   hmUser;
@property (strong, nonatomic) NSArray*  data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *trendGraphButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)showTrendGraph:(id)sender;
- (IBAction)closeTrendGraph:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureDataButton;
@property (strong, nonatomic) IBOutlet UIButton *closeTrendGraphButton;
@property (strong, nonatomic) NSData * showImageData;
@property (strong, nonatomic) NSJSONSerialization* dataJson;
@end
