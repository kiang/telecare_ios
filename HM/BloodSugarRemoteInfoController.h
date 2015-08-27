//
//  BloodSugarRemoteInfoController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUser.h"
#import "BloodSugarInfoService.h"
#import "BloodPressureRemoteInfoController.h"

@interface BloodSugarRemoteInfoController : UIViewController<UITableViewDataSource>

@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) HMUser*   hmUser;
@property (strong, nonatomic) NSArray*  data;
@property (strong, nonatomic) IBOutlet UITableView*             tableView;
@property (strong, nonatomic) IBOutlet UIImageView*             imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView;

- (IBAction)showImageView:(id)sender;
- (IBAction)backgroundTouch:(id)sender;
- (IBAction)gotoBloodPressureView:(id)sender;

@end
