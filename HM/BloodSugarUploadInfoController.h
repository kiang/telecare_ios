//
//  BloodSugarUploadInfoController.h
//  HM
//
//  Created by HUANG Andrerw on 12/11/2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"

@interface BloodSugarUploadInfoController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView*             tableView;
@property (strong, nonatomic) NSArray*                          datas;
@property (strong, nonatomic) NSDateFormatter*                  dateformtter;

@end
