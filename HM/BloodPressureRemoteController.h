//
//  BloodPressureRemoteController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUser.h"
#import "BloodPressureInfoService.h"
#import "BloodSugarRemoteController.h"
#import "BloodPressureShowGraphControllerViewController.h"

@interface BloodPressureRemoteController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) HMUser*   hmUser;
@property (strong, nonatomic) NSArray*  data;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureRemoteLogoutButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *trendGraphButton;
- (IBAction)showTrendGraph:(id)sender;
- (IBAction)closeTrendGraph:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarDataButton;
@property (strong, nonatomic) IBOutlet UIButton *closeTrendGraphButton;
@property NSData * showImageData;
@property (strong, nonatomic) NSJSONSerialization* dataJson;
@end
