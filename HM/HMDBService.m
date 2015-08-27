//
//  HMDBService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMDBService.h"
#import "DBUtil.h"
@implementation HMDBService

//HM_USER
- (HMUser*) getHMUserWithUid:(NSString*)uid
{
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_USER WHERE UID=?" Parameters:[NSArray arrayWithObjects:uid, nil]];
    if (datas!=nil && datas.count>0) {
        HMUser* hmUser = [[HMUser alloc] init];
        
        NSDictionary* data = [datas objectAtIndex:0];
        hmUser.uid             = [data valueForKey:@"UID"];
        hmUser.pwd             = [data valueForKey:@"PWD"];
        hmUser.userType        = [data valueForKey:@"USER_TYPE"];
        hmUser.userUnitName    = [data valueForKey:@"USER_UNIT_NAME"];
        hmUser.rememberAccount = [data valueForKey:@"REMEMBER_ACCOUNT"];
        return hmUser;
    }
    
    return nil;
}

- (HMUser*) getLastHMUser
{
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_USER ORDER BY LAST_LOGIN DESC" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        HMUser* hmUser = [[HMUser alloc] init];
        
        NSDictionary* data = [datas objectAtIndex:0];
        hmUser.uid             = [data valueForKey:@"UID"];
        hmUser.pwd             = [data valueForKey:@"PWD"];
        hmUser.userType        = [data valueForKey:@"USER_TYPE"];
        hmUser.userUnitName    = [data valueForKey:@"USER_UNIT_NAME"];
        hmUser.rememberAccount = [data valueForKey:@"REMEMBER_ACCOUNT"];
        
        return hmUser;
    }
    
    return nil;
}

- (void) insertOrUpdateHMUser:(HMUser*)hmUser
{
    HMUser* oldHMUser = [self getHMUserWithUid:hmUser.uid];
    if (oldHMUser) {
        [self updateHMUser:hmUser];
    } else {
        [self insertHMUser:hmUser];
    }
}

- (void) insertHMUser:(HMUser*)hmUser
{
    [DBUtil dbUtil];
    NSMutableString *userType = [[NSMutableString alloc] init];
    NSLog(@"userType1=%@~endInsert",hmUser.userType);
    if ([hmUser.userType isEqualToString:@"Trial"]) {
        [userType appendString:@"試用會員"];
    } else if ([@"TRSC" isEqualToString:hmUser.userType]) {
        [userType appendString:@"正式會員"];
    }
    [DBUtil executeUpdateWithSQL:@"INSERT INTO HM_USER (UID, PWD, USER_TYPE, USER_UNIT_NAME, REMEMBER_ACCOUNT, LAST_LOGIN) VALUES (?, ?, ?, ?, ?, ?)" Parameters:[NSArray arrayWithObjects:hmUser.uid, hmUser.pwd, userType, hmUser.userUnitName?hmUser.userUnitName:[NSNull null], hmUser.rememberAccount,  [NSNumber numberWithLong:[NSDate timeIntervalSinceReferenceDate]], nil]];
}

- (void) updateHMUser:(HMUser*)hmUser
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [DBUtil dbUtil];
    NSMutableString *userType = [[NSMutableString alloc] init];
    NSLog(@"userType2=%@ ~endUpdate %i",hmUser.userType, [@"Trial" isEqualToString:hmUser.userType]);

    if ([@"Trial" isEqualToString:hmUser.userType]) {
        [userType appendString:@"試用會員"];
    } else if ([@"TRSC" isEqualToString:hmUser.userType]) {
        [userType appendString:@"正式會員"];
    } else {
        [userType appendFormat:hmUser.userType];
    }
    [DBUtil executeUpdateWithSQL:@"UPDATE HM_USER SET PWD=?, USER_TYPE=?, USER_UNIT_NAME=?, REMEMBER_ACCOUNT=?, LAST_LOGIN=? WHERE UID=?" Parameters:[NSArray arrayWithObjects:hmUser.pwd, userType, hmUser.userUnitName?hmUser.userUnitName:[NSNull null], hmUser.rememberAccount, [NSNumber numberWithLong:[NSDate timeIntervalSinceReferenceDate]], hmUser.uid, nil]];
}



//HMBG
- (HMBG*) getHMBGWithFillTime:(NSNumber*)fillTime
{
    if (fillTime) {
        [DBUtil dbUtil];
        NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG WHERE FILL_TIME=?" Parameters:[NSArray arrayWithObjects:fillTime, nil]];
        if (datas!=nil && datas.count>0) {
            HMBG* hmbg = [[HMBG alloc] init];
            
            NSDictionary* data = [datas objectAtIndex:0];
            hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbg.uid      = [data valueForKey:@"UID"];
            hmbg.type     = [data valueForKey:@"TYPE"];
            hmbg.val      = [data valueForKey:@"VAL"];
            hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            return hmbg;
        }
    }
    
    return nil;
}

- (HMBG*) getLastHMBG
{
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG ORDER BY FILL_TIME DESC" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        HMBG* hmbg = [[HMBG alloc] init];
        
        NSDictionary* data = [datas objectAtIndex:0];
        hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
        hmbg.uid      = [data valueForKey:@"UID"];
        hmbg.type     = [data valueForKey:@"TYPE"];
        hmbg.val      = [data valueForKey:@"VAL"];
        hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
        
        return hmbg;
    }
    
    return nil;
}

- (NSArray*) getHMBGWithSendFlagN
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG WHERE SEND_FLAG='N' OR SEND_FLAG='F'" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBG* hmbg;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbg = [[HMBG alloc] init];
            hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbg.uid      = [data valueForKey:@"UID"];
            hmbg.type     = [data valueForKey:@"TYPE"];
            hmbg.val      = [data valueForKey:@"VAL"];
            hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbg];
        }
    }
    return list;
}

- (NSArray*) getHMBGWithSendFlagNotN
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG ORDER BY FILL_TIME DESC" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBG* hmbg;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbg = [[HMBG alloc] init];
            hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbg.uid      = [data valueForKey:@"UID"];
            hmbg.type     = [data valueForKey:@"TYPE"];
            hmbg.val      = [data valueForKey:@"VAL"];
            hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbg];
        }
    }
    return list;
}

- (NSArray*) getHMBGWithSendFlagNotN:(HMUser*) HMUser
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG WHERE UID = ? ORDER BY FILL_TIME DESC" Parameters:[NSArray arrayWithObjects:HMUser.uid, nil]];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBG* hmbg;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbg = [[HMBG alloc] init];
            hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbg.uid      = [data valueForKey:@"UID"];
            hmbg.type     = [data valueForKey:@"TYPE"];
            hmbg.val      = [data valueForKey:@"VAL"];
            hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbg];
        }
    }
    return list;
}

- (void) insertOrUpdateHMBG:(HMBG*)hmbg
{
    HMBG* old = [self getHMBGWithFillTime:hmbg.fillTime];
    if (old) {
        [self updateHMBG:hmbg];
    } else {
        [self insertHMBG:hmbg];
    }
}

- (NSArray*) getHMBGRemoteFromDate:(NSString*) startDay toDate:(NSString*) toDay withUser:(HMUser*)hmUser
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BG_REMOTE WHERE FILL_TIME >= ? AND FILL_TIME <= ? AND UID =?" Parameters:[NSArray arrayWithObjects: startDay, toDay,hmUser.uid, nil]];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBG* hmbg;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbg = [[HMBG alloc] init];
            hmbg.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbg.uid      = [data valueForKey:@"UID"];
            hmbg.type     = [data valueForKey:@"TYPE"];
            hmbg.val      = [data valueForKey:@"VAL"];
            hmbg.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbg];
        }
    }
    return list;
}


-(void) insertOrUpdateHMBGRemote:(HMBG*) hmbg {
    HMBG* old = [self getHMBGWithFillTime:hmbg.fillTime];
    if (old) {
        [self updateHMBGRemote:hmbg];
    } else {
        [self insertHMBGRemote:hmbg];
    }
}

-(void) updateHMBGRemote:(HMBG*)hmbg {
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"UPDATE HM_BG_REMOTE SET UID=?, TYPE=?, VAL=?, SEND_FLAG=? WHERE FILL_TIME=?" Parameters:[NSArray arrayWithObjects:hmbg.uid, hmbg.type, hmbg.val, hmbg.sendFlag, hmbg.fillTime, nil]];
}

-(void) insertHMBGRemote:(HMBG*)hmbg {
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"INSERT INTO HM_BG_REMOTE(FILL_TIME, UID, TYPE, VAL, SEND_FLAG) VALUES (?, ?, ?, ?, ?)" Parameters:[NSArray arrayWithObjects:hmbg.fillTime, hmbg.uid, hmbg.type, hmbg.val, @"N", nil]];
}

- (void) insertHMBG:(HMBG*)hmbg
{
    [DBUtil dbUtil];
    //[DBUtil executeUpdateWithSQL:@"INSERT INTO HM_BG(FILL_TIME, UID, TYPE, VAL, SEND_FLAG) VALUES (?, ?, ?, ?, ?)" Parameters:[NSArray arrayWithObjects:[NSNumber numberWithLong:[NSDate timeIntervalSinceReferenceDate]], hmbg.uid, hmbg.type, hmbg.val, @"N", nil]];
    [DBUtil executeUpdateWithSQL:@"INSERT INTO HM_BG(FILL_TIME, UID, TYPE, VAL, SEND_FLAG) VALUES (?, ?, ?, ?, ?)" Parameters:[NSArray arrayWithObjects:hmbg.fillTime, hmbg.uid, hmbg.type, hmbg.val, @"N", nil]];
}

- (void) updateHMBG:(HMBG*)hmbg
{
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"UPDATE HM_BG SET UID=?, TYPE=?, VAL=?, SEND_FLAG=? WHERE FILL_TIME=?" Parameters:[NSArray arrayWithObjects:hmbg.uid, hmbg.type, hmbg.val, hmbg.sendFlag, hmbg.fillTime, nil]];
}



//HM_BP
- (HMBP*) getHMBPWithFillTime:(NSNumber*)fillTime
{
    if (fillTime) {
        [DBUtil dbUtil];
        NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BP WHERE FILL_TIME=?" Parameters:[NSArray arrayWithObjects:fillTime, nil]];
        if (datas!=nil && datas.count>0) {
            HMBP* hmbp = [[HMBP alloc] init];
            
            NSDictionary* data = [datas objectAtIndex:0];
            hmbp.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbp.uid      = [data valueForKey:@"UID"];
            hmbp.bpl      = [data valueForKey:@"BPL"];
            hmbp.bph      = [data valueForKey:@"BPH"];
            hmbp.pluse    = [data valueForKey:@"PULSE"];
            hmbp.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            return hmbp;
        }
    }
    
    return nil;
}

- (HMBP*) getLastHMBP
{
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BP ORDER BY FILL_TIME DESC" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        HMBP* hmbp = [[HMBP alloc] init];
        
        NSDictionary* data = [datas objectAtIndex:0];
        hmbp.fillTime = [data valueForKey:@"FILL_TIME"];
        hmbp.uid      = [data valueForKey:@"UID"];
        hmbp.bpl      = [data valueForKey:@"BPL"];
        hmbp.bph      = [data valueForKey:@"BPH"];
        hmbp.pluse    = [data valueForKey:@"PULSE"];
        hmbp.sendFlag = [data valueForKey:@"SEND_FLAG"];
        
        return hmbp;
    }
    
    return nil;
}

- (NSArray*) getHMBPWithSendFlagN
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BP WHERE SEND_FLAG='N' OR SEND_FLAG='F'" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBP* hmbp;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbp = [[HMBP alloc] init];
            hmbp.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbp.uid      = [data valueForKey:@"UID"];
            hmbp.bpl      = [data valueForKey:@"BPL"];
            hmbp.bph      = [data valueForKey:@"BPH"];
            hmbp.pluse    = [data valueForKey:@"PULSE"];
            hmbp.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbp];
        }
    }
    return list;
}

- (NSArray*) getHMBPWithSendFlagNotN
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:
                      @"SELECT * FROM HM_BP ORDER BY FILL_TIME DESC" Parameters:nil];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBP* hmbp;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbp = [[HMBP alloc] init];
            hmbp.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbp.uid      = [data valueForKey:@"UID"];
            hmbp.bpl      = [data valueForKey:@"BPL"];
            hmbp.bph      = [data valueForKey:@"BPH"];
            hmbp.pluse    = [data valueForKey:@"PULSE"];
            hmbp.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbp];
        }
    }
    return list;
}

- (NSArray*) getHMBPWithSendFlagNotN:(HMUser*) HMUser
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    [DBUtil dbUtil];
    NSArray* datas = [DBUtil executeQueryWithSQL:@"SELECT * FROM HM_BP WHERE UID = ? ORDER BY FILL_TIME DESC" Parameters:[NSArray arrayWithObjects:HMUser.uid, nil]];
    if (datas!=nil && datas.count>0) {
        NSDictionary* data;
        HMBP* hmbp;
        for (int i=0, len=datas.count; i<len; ++i) {
            data = [datas objectAtIndex:i];
            hmbp = [[HMBP alloc] init];
            hmbp.fillTime = [data valueForKey:@"FILL_TIME"];
            hmbp.uid      = [data valueForKey:@"UID"];
            hmbp.bpl      = [data valueForKey:@"BPL"];
            hmbp.bph      = [data valueForKey:@"BPH"];
            hmbp.pluse    = [data valueForKey:@"PULSE"];
            hmbp.sendFlag = [data valueForKey:@"SEND_FLAG"];
            
            [list addObject:hmbp];
        }
    }
    return list;
}

- (void) insertOrUpdateHMBP:(HMBP*)hmbp
{
    HMBP* old = [self getHMBPWithFillTime:hmbp.fillTime];
    if (old) {
        [self updateHMBP:hmbp];
    } else {
        [self insertHMBP:hmbp];
    }
}

- (void) insertHMBP:(HMBP*)hmbp
{
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"INSERT INTO HM_BP(FILL_TIME, UID, BPL, BPH, PULSE, SEND_FLAG) VALUES (?, ?, ?, ?, ?, ?)" Parameters:[NSArray arrayWithObjects:hmbp.fillTime, hmbp.uid, hmbp.bpl, hmbp.bph, hmbp.pluse, @"N", nil]];
}

-(void) deleteDatas:(NSDate *) date {
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"DELETE FROM HM_BP WHERE FILL_TIME < ?" Parameters:[NSArray arrayWithObjects:[NSNumber numberWithLong:[date timeIntervalSinceReferenceDate]], nil]];
    [DBUtil executeUpdateWithSQL:@"DELETE FROM HM_BG WHERE FILL_TIME < ?" Parameters:[NSArray arrayWithObjects:[NSNumber numberWithLong:[date timeIntervalSinceReferenceDate]], nil]];
}

-(void) deleteAllUserDatas {
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"DELETE FROM HM_USER" Parameters:[NSArray arrayWithObjects: nil]];
}

- (void) updateHMBP:(HMBP*)hmbp
{
    [DBUtil dbUtil];
    [DBUtil executeUpdateWithSQL:@"UPDATE HM_BP SET UID=?, BPL=?, BPH=?, PULSE=?, SEND_FLAG=? WHERE FILL_TIME=?" Parameters:[NSArray arrayWithObjects:hmbp.uid, hmbp.bpl, hmbp.bph, hmbp.pluse, hmbp.sendFlag, hmbp.fillTime, nil]];
}


@end
