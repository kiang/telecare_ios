//
//  PMODBService.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "HMUser.h"
#import "HMBG.h"
#import "HMBP.h"

@interface PMODBService : NSObject

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
- (void)     saveHMBGWithAccount:(NSString*)account
                            Type:(NSString*)type
                     DateTime:(NSString*)dateTime
                        Value:(NSString*)value;
- (void)     insertOrUpdateHMBG:(HMBG*)hmbg;

//HMBP
- (HMBP*)    getHMBPWithFillTime:(NSNumber*)fillTime;
- (HMBP*)    getLastHMBP;
- (NSArray*) getHMBPWithSendFlagN;
- (NSArray*) getHMBPWithSendFlagNotN;
- (NSArray*) getHMBPWithSendFlagNotN:(HMUser*) HMUser;
- (void)     saveHMBPWithAccount:(NSString*)account
                        DateTime:(NSString*)dateTime
                             Bpl:(NSString*)bpl
                             Bph:(NSString*)bph
                           Pluse:(NSString*)pluse
                       InputType:(NSString*)inputType;
- (void)     insertOrUpdateHMBP:(HMBP*)hmbp;

-(void) deleteDatas:(NSDate *) date;
-(void) deleteAllUserDatas;

//HMBGREMOTE
- (void) insertOrUpdateHMBGRemote:(HMBG*) hmbg;
- (NSArray*) getHMBGRemoteFromDate:(NSString*) startDay toDate:(NSString*) toDay withUser:(HMUser*)hmUser;

@end
