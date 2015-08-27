//
//  HMDBService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMUser.h"
#import "HMBG.h"
#import "HMBP.h"

@interface HMDBService : NSObject

//HMUser
- (HMUser*) getHMUserWithUid:(NSString*)uid;
- (HMUser*) getLastHMUser;
- (void)    insertOrUpdateHMUser:(HMUser*)hmUser;

//HMBG
- (HMBG*)    getHMBGWithFillTime:(NSNumber*)fillTime;
- (HMBG*)    getLastHMBG;
- (NSArray*) getHMBGWithSendFlagN;
- (NSArray*) getHMBGWithSendFlagNotN;
- (NSArray*) getHMBGWithSendFlagNotN:(HMUser*) HMUser;
- (void)     insertOrUpdateHMBG:(HMBG*)hmbg;

//HMBP
- (HMBP*)    getHMBPWithFillTime:(NSNumber*)fillTime;
- (HMBP*)    getLastHMBP;
- (NSArray*) getHMBPWithSendFlagN;
- (NSArray*) getHMBPWithSendFlagNotN;
- (NSArray*) getHMBPWithSendFlagNotN:(HMUser*) HMUser;
- (void)     insertOrUpdateHMBP:(HMBP*)hmbp;

-(void) deleteDatas:(NSDate *) date;
-(void) deleteAllUserDatas;

//HMBGREMOTE
- (void) insertOrUpdateHMBGRemote:(HMBG*) hmbg;
- (NSArray*) getHMBGRemoteFromDate:(NSString*) startDay toDate:(NSString*) toDay withUser:(HMUser*)hmUser;
@end
