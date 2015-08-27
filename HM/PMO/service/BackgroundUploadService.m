    //
//  BackgroundUploadService.m
//  HM
//
//  Created by HUANG Andrerw on 12/11/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundUploadService.h"
#import "PMODBService.h"
#import "HMUser.h"
#import "UploadVitalSignBloodSugarService.h"
#import "UploadVitalSignBloodPressureService.h"

@implementation BackgroundUploadService
static NSTimer*     timer;
static PMODBService *dbService;

+ (void) start
{
    if (timer==nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(uploadData) userInfo:nil repeats:true];
        NSLog(@"timer start");
    }
    
    if (dbService == nil) {
        dbService = [[PMODBService alloc]init];
    }
}

+ (void) stop
{
    if (time!=nil) {
        [timer invalidate];
        timer = nil;
        NSLog(@"timer stop");
    }
}

+ (void)uploadData
{
    NSArray* datas;
    HMUser*  user;
    int inputType;
    
    datas = [dbService getHMBGWithSendFlagN];
    HMBG* bg;
    for (int i=0,len=datas.count; i<len; ++i) {
        bg = [datas objectAtIndex:i];
        user = [dbService getHMUserWithUid:bg.uid];
        [[[UploadVitalSignBloodSugarService alloc]initWithHMUser:user HMBG:bg Target:self Action:@selector(uploadBGResponse:)]start];
    }
    
    
    datas = [dbService getHMBPWithSendFlagN];
    HMBP* bp;
    for (int i=0,len=datas.count; i<len; ++i) {
        bp = [datas objectAtIndex:i];
        user = [dbService getHMUserWithUid:bp.uid];
        inputType = bp.sendFlag;
        
        if ([bp.sendFlag isEqualToString:@"D"])
            inputType = 0;  //device upload
        else
            inputType = 1;  //manual upload

        NSLog(@"bp.sendFlag:%@",bp.sendFlag);
        
        [[[UploadVitalSignBloodPressureService alloc]initWithHMUser:user HMBP:bp Target:self Action:@selector(uploadBPResponse:)]start:inputType];
    }
}

+ (void)uploadBGResponse:(UploadVitalSignBloodSugarService*)service
{
    if(!service.error) {
        service.hmbg.sendFlag = @"Y";
        [OMGToast showWithText:@"上傳血糖資料成功" duration:2];
    } else {
        service.hmbg.sendFlag = @"F";
        //[OMGToast showWithText:@"上傳血糖資料失敗" duration:2];
    }
    [dbService insertOrUpdateHMBG:service.hmbg];
}

+ (void)uploadBPResponse:(UploadVitalSignBloodPressureService*)service
{
    if(!service.error) {
        service.hmbp.sendFlag = @"Y";
        [OMGToast showWithText:@"上傳血壓資料成功" duration:2];
    } else {
        service.hmbp.sendFlag = @"F";
        //[OMGToast showWithText:@"上傳血壓資料失敗" duration:2];
    }
    [dbService insertOrUpdateHMBP:service.hmbp];
}

@end
