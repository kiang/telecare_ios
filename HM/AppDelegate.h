//
//  AppDelegate.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDBService.h"
#import "UploadVitalSignBloodPressureService.h"
#import "UploadVitalSignBloodSugarService.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer* backgroundUploadDataTimer;
@property (strong, nonatomic) HMDBService* dbService;

@end
