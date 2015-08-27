//
//  BloodPressureDataController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
@interface BloodPressureDataController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *forLogout;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray*         datas;
@property (strong, nonatomic) NSDateFormatter* dateformtter;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodPressureButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UIButton *bloodSugarDataButton;
@property (strong, nonatomic) HMDBService* hmDbService;
@property (strong, nonatomic) HMUser*      hmUser;
@end
