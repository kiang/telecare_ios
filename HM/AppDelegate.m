//
//  AppDelegate.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "OMGToast.h"
#import "bleService.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate

@synthesize window = _window;
@synthesize backgroundUploadDataTimer = _backgroundUploadDataTimer;
@synthesize dbService = _dbService;


- (void)uploadBGResponse:(UploadVitalSignBloodSugarService*)service
{
    if(!service.error) {
        service.hmbg.sendFlag = @"Y";
        [OMGToast showWithText:@"上傳血糖資料成功" duration:2];
    } else {
        service.hmbg.sendFlag = @"F";
        //[OMGToast showWithText:@"上傳血糖資料失敗" duration:2];
    }
    [self.dbService insertOrUpdateHMBG:service.hmbg];
}

- (void)uploadBPResponse:(UploadVitalSignBloodPressureService*)service
{
    if(!service.error) {
        service.hmbp.sendFlag = @"Y";
        [OMGToast showWithText:@"上傳血壓資料成功" duration:2];
    } else {
        service.hmbp.sendFlag = @"F";
        //[OMGToast showWithText:@"上傳血壓資料失敗" duration:2];
    }
    [self.dbService insertOrUpdateHMBP:service.hmbp];
}

- (void)uploadData
{
    NSArray* datas;
    HMUser*  user;
    
    datas = [self.dbService getHMBGWithSendFlagN];
    HMBG* bg;
    for (int i=0,len=datas.count; i<len; ++i) {
        bg = [datas objectAtIndex:i];
        user = [self.dbService getHMUserWithUid:bg.uid];
        [[[UploadVitalSignBloodSugarService alloc]initWithHMUser:user HMBG:bg Target:self Action:@selector(uploadBGResponse:)]start];
    }
    
    
    datas = [self.dbService getHMBPWithSendFlagN];
    HMBP* bp;
    for (int i=0,len=datas.count; i<len; ++i) {
        bp = [datas objectAtIndex:i];
        user = [self.dbService getHMUserWithUid:bp.uid];
        [[[UploadVitalSignBloodPressureService alloc]initWithHMUser:user HMBP:bp Target:self Action:@selector(uploadBPResponse:)]start:1];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
    self.backgroundUploadDataTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(uploadData) userInfo:nil repeats:true];
    self.dbService = [[HMDBService alloc]init];
     */
    /*
    UIImage *navBar = [UIImage imageNamed:@"topBackground.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
     */
    
    UIStoryboard *mainStoryboard = nil;
    if(false && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        mainStoryboard = [ UIStoryboard storyboardWithName:@"MainStoryboard-extend" bundle:nil];
    }
    else
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    }
    
    self.window = [ [UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ mainStoryboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[bleService sharedInstance] getBluetoothState] == CBCentralManagerStatePoweredOff)
    {
        [OMGToast showWithText:@"藍牙已關閉，請開啟藍牙以自動接收血壓資料。" duration:5];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
